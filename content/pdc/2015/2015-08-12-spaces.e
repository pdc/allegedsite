Title: Generosity when Accepting Postcodes
Topics: ux postcode django
Date: 2015-08-12

When designing forms for web sites that accept postcodes or similar, it should
be the web site, not the user, who has to convert it in to a canonical form
that is easy to store and process.


# Introduction

There are lots of codes and identifiers used in everyday life that combine numbers and letters with a little bit of syntax to make them easier to read. Here are some obvious examples:

- British postcodes: CR0 3RL
- ISBNs: 978-3-16-148410-0
- National phone number: (042) 1123 4567
- International phone number: +31 42 1123 4567
- Bank cards: 5404 0000 0000 0068

In all cases the spaces or hyphens grouping the digits in to clusters are
there to make them easier to recognize for humans. When entering a long number it helps when checking what you have typed against what is printed on your card.

The spaces in postcodes  are not needed to make the numbers unique, but alas!
a computer will treat different ways of writing the same number as different
numbers—for example, `(042) 1123 4567` and `042-112 345 67` will be not be
recognized as being the same phone number. Database designers will therefore want us to store codes ina canonical format to make comparisons easy.

One approach some sites use is to require users to enter numbers using a
canonical syntax. Often alas! the convenient canonical form is different from
the one people are used to seeing—for example, credit card numbers might be
required to be just the 16 digits without spaces. This is so annoying and
error-prone that there is a [No Dashes or Spaces hall of shame][1].

The prompt for this article was a most egregious example I  encountered
recently where I was required to enter my postcode without spaces—which was
so unexpected it took me a while to work out what they wanted me to do.


# What should happen

**Rule 1.** Users of your site should be allowed to enter numbers with whatever level of
fidelity to the standard format they are capable of and feel is appropriate:
the form would therefore accept `CR0 3RL`, `cr0 3rl`, and `cr03rl`.

**Rule 2.** When processing the form (or when saving in the database, depending on how the
site code is structured) the input should be canonicalized. This might be to
the standard  format, or it might be convenient to use a format without spaces
like `CR03RL` to save space.

**Rule 3.** When presenting the data to the user at a later date, the value should be
converted to its standard presentational form. (If the canonical form is the
same as the presentational form this step requires no extra work.)

As an optional extra, it will be nice to have client-side support in addition
to server-side validation, such as the following:

- add an HTML5 `pattern` attribute to constrain the input to strings matching
the regex, and

- add JavaScript to the page in question so as the postcode is entered it is
canonicalized while they type, so they know how their input will be
interpreted.

If using the `pattern` attribute, it should match any reasonable input that
can be canonicalized to a valid one.

One thing I have seen one some online forms and would recommend against is having multiple fields for a single code number. It just makes things needlessly complicated.

In the above examples I have used  postcodes but the above rules  should apply to most
special formats.


# Implementation

## Support in Django

This section is shorter than I expected because there happens to be a form
field that understands British  postcodes as part of the
[django-localflavor][] package, along with form items for a variety of other
nationally-determined codes. As well as validating postcodes, it inserts the
space if necessary to canonicalize the format. [The code for the postcode
field][2] is also not a bad model for extending this idea to other fields that
they do not supply.


## Other web frameworks are available

If your web framework does not have a straightforward way to add code to
canonicalize user input before validating it on the server side then it is
defective.


# So

There is no excuse for requiring users to enter postcodes or other codes or
numbers in a special format—especially if it is not the format people are used
to see in other contexts.


  [1]:  http://www.unixwiz.net/ndos-shame.html
  [django-localflavor]: http://django-localflavor.readthedocs.org/en/latest/localflavor/gb/
  [2]: https://github.com/django/django-localflavor/blob/b03a821cffd03c28e965220fe51088480b12187b/localflavor/gb/forms.py#L16
