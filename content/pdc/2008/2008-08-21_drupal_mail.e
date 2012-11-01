Date: 2008-08-21
Topics: drupal php mail 
Title: Drupal and email
Image: ../icon-64x64.png
Href: http://drupal.org/

For once something I am learning at work is useful in real life: I am using [Drupal][] (which I have been working on [since last month][2]) to implement [a new version of the CAPTION web site][1]. So far it has been plain sailing, more or less, except I hit a roadblock with user self-registration: Drupal could not send mail. It seems this is a known problem with Drupal that has not been fixed in years.

That fifth parameter
====================

As you search the [dozens of plaintive questions][3] on the Drupal forums and issue tracker, you often hear of the mythical Fifth Parameter. Administrators of newly installed Drupal systems are often told by their ISPs that mail cannot be sent unless they supply the Fifth Parameter. ‘What is the Fifth Parameter, and how can I set it?’ they ask. Often the response is ‘set the from address in the administration pages’, which unfortunately is wrong.

<div class="wide_photo_right">
<a href="http://www.flickr.com/photos/pdc/2754932282/" title="Escape—Woodrow Phoenix by Damian Cugley, on Flickr"><img src="http://farm4.static.flickr.com/3066/2754932282_4abfb8081e_m.jpg" width="240" height="160" alt="Escape—Woodrow Phoenix" /></a>
</div>

The question is fairly easily answered if you have twenty years experience with [RFC 2822][] (né [RFC 822][]) mail, SMTP ([RFC 2821][]), Unix `sendmail`, PHP, and and fairly well-equipped text editor. It goes something like this.

A lot of email gateways nowadays reject mail if it does not have a  a plausible from-address (this is intended as an anti-spam measure). So why does setting the From address setting not help?  Because there are *two* sorts of from address:

- The `From` header in the message itself, and

- The from address on the  envelope, used in the SMTP protocol (also called the *return-path* or the *sender* address).

The former is set from the _From address_  setting in Drupal’s administration interface. What about the envelope from-address?

On Unix systems, mail is sent using a program `sendmail`. It takes an option `‑f` to set the envelope from-address; if it is omitted, the logged-in user’s login name and the hostname of the computer are used to make the email address (which made sense in the days when  everybody at a site shared a single Unix machine which also handled their mail).

In a PHP program, you invoke the `sendmail` program through a function called <code>[mail][]</code>. it has parameters for recipient, subject line, message body, optional additional headers and optional additional parameters for the `sendmail` program. The last of these is the Fifth Parameter that your ISP has mentioned: they expect you to set it to `‑fuser@example.com`.

How Drupal gets it wrong
========================

The Drupal system provides a wrapper function <code>[drupal_mail][]</code> that massages the input parameters before invoking the `mail` function. This allows them to add some checks for common security problems, call hook functions, and also to substitute the from-address from Drupal’s settings.  

<div class="wide_photo_right">
<a href="http://www.flickr.com/photos/pdc/2754933140/" title="Escape—Technical Difficulties by Damian Cugley, on Flickr"><img src="http://farm4.static.flickr.com/3044/2754933140_5f6e64860c_m.jpg" width="240" height="160" alt="Escape—Technical Difficulties" /></a>
</div>

This  works by assembling all the info about the message in to a single Drupal structured array `$message`, and then passing that to <code>[drupal_mail_send][]</code> to do the actual work. The envelope from-address is stored as `$message['from']`. 

What goes wrong is that `drupal_mail_send` ignores `$message['from']` and calls `mail` without setting the Fifth Parameter.

With no Fifth Parameter, `sendmail` is called without its `‑f` options, and sets the from-address to the current user (often a fake user created to run the web server, such as  `www-data` or `httpd`) and the computer’s canonical hostname (which may well not be the same as the web site if your site is a virtual host). In any case it will not match your `From` header line, and sufficiently careful email gateways may bounce the message as a result.

How to fix it
=============

The `drupal_mail_send` function has a feature designed to allow different mail back-ends to be plugged in to Drupal—on some systems you will want to invoke some special SMTP queue program or something.  This works not through the usual hook conventions, but by having a settings variable `smtp_library` that names a file of PHP code that must define a function named `drupal_mail_wrapper`.  Here’s how I exploited this to make mail work on the site I was working on:

First, create a file containing as mail function. Here’s my `mail_wrapper_with_fifth_parameter.php`:

	 <?php
	 /**
	 * Override the mail function
	 * so that we can pass the FIFTH PARAMETER.
	 */
	 function drupal_mail_wrapper($message) {
	  $mimeheaders = array();
	  foreach ($message['headers'] as $name => $value) {
	    $mimeheaders[] = $name .': '. mime_header_encode($value);
	  }
	  return mail(
	    $message['to'],
	    mime_header_encode($message['subject']),
	    // Note: e-mail uses CRLF for line-endings, but PHP's API requires LF.
	    // They will appear correctly in the actual e-mail that is sent.
	    str_replace("\r", '', $message['body']),
	    // For headers, PHP's API suggests that we use CRLF normally,
	    // but some MTAs incorrecly replace LF with CRLF. See #234403.
	    join("\n", $mimeheaders),
	    ($message['from'] ? '-f' . $message['from'] : ''));
	 }

The body of the function is essentially the `else` branch of the conditional in
`drupal_mail_send` (complete with line-ending shenanigans), with the fifth parameter
added.

We need to be able to name this file in `settings.php` so I copied it in to the `includes` directory at the top of my Drupal instance.

Next I edited `sites/default/settings.php` and added this line to the end:

		$conf['smtp_library'] = 'includes/mail_wrapper_with_fifth_parameter.php';

This is the bit that sets the variable that makes the override work in `drupal_mail_send`.  

After this I tried sending mail (via the Forgotten Password form) and (after a few false starts) it worked! Yay!

Why am I so annoyed?
====================

This seems like a lot of effort to go to to restore a parameter that should have been set properly in the original code. I can only assume that Drupal developers tend to use dedicated hosts, which makes the Fifth Parameter unnecessary on their systems, and hence never notice that it cannot be easily set. (In fact, in the olden days, the `‑f` parameter was forbidden because it was useful for spoofing mail.) Many web administrators are struggling with nothing but a one-line mail from their ISP to help them understand the problem.

It would be helpful if there were a way to tell Drupal whether or not to include the `‑f`
option when calling `sendmail`. This would allow the Drupal forums to give admins
struggling with this problem a simple suggestion for how to fix the problem (as opposed to
the fairly elaborate changes outlined above).



Afternote
=========

I discovered that Safari will happily divide a line after a hyphen, even after the hyphen in `‑f`. To avoid this I have subsituted the Unicode <span style="font-variant: small-caps">non-breaking hyphen</span> U+2011. I hope this does not cause your web browser to display gibberish. If you see `â€‘`, please try doing View &#x2192; Text encoding &#x2192; UTF-8 or similar.




  [Drupal]: http://drupal.org/
  [1]: http://caption.org/2/
  [2]: 07/30.html
  [3]: http://drupal.org/search/node/mail+fifth+parameter
  [RFC 2821]: http://tools.ietf.org/html/rfc2821
  [RFC 2822]: http://tools.ietf.org/html/rfc2822
  [RFC 822]: http://tools.ietf.org/html/rfc822
  [mail]: http://uk3.php.net/manual/en/function.mail.php
  [drupal_mail]: http://api.drupal.org/api/function/drupal_mail/6
  [drupal_mail_send]: http://api.drupal.org/api/function/drupal_mail_send/6