Title: Cryptographically secured tickets using Microsoft SQL Server with pwdencrypt
Topics: sqlserver pwdencrypt
Icon: ../icon-64x64.png
Date: 20050411

O Google, accept my offering of a method of doing SHA-1-secured
authentication in a stored procedure on Microsoft SQL Server 7 using
the undocumented function `pwdencrypt`. This proved useful to me
recently, so let it be discovered by developers in the future.

This technique is useful when two pages in a web application, say, need
to be able to pass information about who is logged in to the
application. Our typical user Alice visits the log-in page and enters
her log-in name and password. When the application sends back its
response, it includes a `Set-Cookie` header with Alice's user name in
it. Her web browser will include this cookie in subsequent HTTP requests.
Other pages in the application examine the cookie to see who is logged
in.

The problem is, you can't entirely trust the user's web browser.
Suppose Bob wants to read a page restricted to Alice. He could write a
program that connects to the web server with HTTP and includes the
cookie with Alice's name in it, thus impersonating her to the
application.  To prevent this, we don't just store the user name in the
cookie, but instead the cookie contains a _ticket_.

Background on tickets and authentication
-----

A __ticket__ is a token (a character string) that identifies a user to an
application, and contains other information that prevents anyone other
than the application from generating valid tickets. Tickets can be used
in contexts other than cookies; the main requirement is that producers
and consumers of tickets can both access the user database.

<a href="http://www.flickr.com/photos/pdc/6008304/" title="Three times three times three (Flickr)"><img src="http://photos3.flickr.com/6008304\_28f32e999c\_s.jpg" width="75" height="75" alt="" align="left" /></a>
A ticket contains at least three
parts: Alice's log-in name, the expiration date of the ticket, and a _check
field_ to prevent tampering. The check field is random-looking data
calculated using a cryptographically strong hash function with the user
name, expiration date, any other public fields, and a secret key as inputs.
Here is some sample code in Python, using MD5 as the hash function:

<pre>
import md5, time

userSecrets = {'alice': '12345678', 'bob': '23456789'}

def createTicket(user, minutes=30):
    """Given a user, and expiration date, return a ticket."""
    expires = int(time.time() + minutes * 60)
    publicPart = user.encode('UTF-8') + ':' + str(expires)
    checkField = md5.new(publicPart + ':' 
            + userSecrets[user]).hexdigest()
    return publicPart + checkField

print ticket('alice')
</pre>

This generates tickets that look like

<pre>
alice:1113257911:86a7bd6aba6367968252c104e28699f0
</pre>

You check the ticket in two
steps: first, that its expiration date is in the future, and second, that the
public part, when concatenated with the secret key and hashed with MD5,
produces the same result as the check field:

<pre>
def checkTicket(ticket):
    """Given a ticket, return the user name or None."""
    es = ticket.split(':', 3)
    if len(es) != 3 or int(es[1]) <= time.time():
        return None
    user = es[0]
    if not user in userSecrets:
        return None
    data = ticket[:-32] + userSecrets[user]
    if md5.new(data).hexdigest() != es[2]:
        return None
    return user
</pre>
                
Without knowing the secret keys (`userSecrets` in the above code, standing
in for the real database of users), you
can't generate tickets. Note that, if someone manages to intercept the
ticket can use it to impersonate Alice; including an expiration date is
supposed to help reduce the window of opportunity.

The secrets are a random string stored in the user database, never
revealed to other applications, and changed from time to time.
Changing the secret has the effect of invalidating all outstanding
tickets, so this gives you a way to 'log out'.

Digest functions in Microsoft SQL Server
-----

<a href="http://www.flickr.com/photos/pdc/6006966/" title="Rearing pitcher plants (Flickr)"><img src="http://photos6.flickr.com/6006966\_392981b72a\_m.jpg" width="239" height="240" alt="" align="right" /></a>
I wanted to use this technique in an application where the web-server
code can only access the database through SQL stored procedures, and I
wanted to avoid having a stored procedure that allowed the web application
to find out the user's password or secret key (the idea being that even
if an attacker manages to subvert the web server, they will not be able
to get the information needed to forge tickets). This means I needed a way to
calculate a digest within an SQL stored procedure.

Sadly there are no official MD5 or SHA-1 routines available to T-SQL
programs. It is possible to add one: I have found a reference to [a
free extended stored proc][1] that implements an MD5 and [another
example using an OLE Automation object][4]. I did not use
this because I don't want to install an extension on
SQL Server, since this will complicate the installer for the
application. When I was discussing this with a colleague, she suggested
looking for the undocumented functions [`pwdencrypt` and `pwdcompare`][5].

As it turns out, Google's top hit for `pwdencrypt` is [an article claiming the algorithm is
flawed][2]; this links to [a paper (in PDF)][3] that describes the
algorithm used. Here's Python code for creating a valid password hash:

<pre>
import sha, random, struct
    
def pwdencrypt(s):
    """Given a password, return a 46-byte hash mash-up."""
    header = '\1\0'
    salt = struct.pack('I', random.randint(0, 0x100000000L))
    hash1 = sha.new(s.encode('UTF-16LE') + salt).digest()
    hash2 = sha.new(s.upper().encode('UTF-16LE') + salt).digest()
    return header + salt + hash1 + hash2
</pre>
        
(This code differs from the SQL implementation in that the 4-byte random
salt is calculated in a different way.) Leaving aside the discussion of
its suitability as a password algorithm, the 46 bytes do include a SHA-1
hash, so we can use it as an alternative to MD5 in the ticket algorithm.
The addition of random salt and the use of two hashes rather than one is
superfluous to our requirements, but do no harm beyond wasting CPU
cycles.


Passing tickets to a stored procedure
-----

One of the deficiencies of the T-SQL language is that binary data cannot
be encoded (using hexadecimal or base-64, for example). My initial approach
was to pass the ticket in a pre-digested form as two
arguments: the public part and the check field, decoded as binary data,
something like this:

<pre>
CREATE PROCEDURE CreateTicket
    @login NVARCHAR(400),
    @minutes REAL,
    @publicPart NVARCHAR(400) OUTPUT,
    @checkField VARBINARY(46) OUTPUT
AS
    DECLARE 
        @secret NVARCHAR(400),
        @expires DATETIME,
        @seconds INT,
        @data NVARCHAR(400)
    SET @secret = (
        SELECT secret FROM Users WHERE login = @login
    )
    SET @expires = DATEADD(MINUTE, @minutes, GETUTCDATE())
    SET @seconds = DATEDIFF(SECOND, '2001-01-01', @expires)
    SET @publicPart = @login + ':' + CAST(@seconds AS VARCHAR(20))
    SET @data = @publicPart + ':' + @secret
    SET @checkField = pwdencrypt(@data)
</pre>

(This code is untested because I am writing this from memory at home, where I do not
have access to SQL Server.)  Checking a ticket is somewhat laborious
because of the limitations on string manipulation in T-SQL.  It starts
like this:

<pre>
CREATE PROCEDURE CheckTicket
    @publicPart NVARCHAR(400),
    @checkField VARBINARY(46),
    @login NVARCHAR(400) OUTPUT
AS
</pre>

... and involves use of `CHARINDEX` and `SUBSTRING` to pick apart the
string and check the expiration date, followed by  `pwdcompare(@data,
@checkField)`.  Details are left as an exercise for the reader,
presuming the reader has an SQL Server handy to try this on.

Later on it turned out the application framework I was using could not
handle binary parameters, so I wrote my own base-64 codec in SQL so that
the ticket could be passed as a single `VARCHAR` argument.

Future changes
-----

Will there be better alternatives in future versions of SQL Server?
Possibly, since security is something Microsoft are currently making a
big fuss about. Having a built-in base-64 codec would be convenient too.

More importantly, will code using `pwdencrypt` stop working in the next
version? According to [this note][6], the output of `pwdencrypt` is
reduced to 26 bytes in SQL Server 2005 betas, and the `pwdcompare`
routine seems to accept either format.


  [1]: http://www.codeproject.com/database/xp_md5.asp 
  [2]: http://www.theregister.co.uk/2002/07/08/cracking_ms_sql_server_passwords/
  [3]: http://www.nextgenss.com/papers/cracking-sql-passwords.pdf
  [4]: http://www.databasejournal.com/features/mssql/article.php/1474671
  [5]: http://www.aspfree.com/c/a/ASP.NET-Code/One-way-encryption
  [6]: http://msmvps.com/gladchenko/archive/2005/04/06/41083.aspx
