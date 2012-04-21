Title: Kanbo on PyPy
Topics: pypy python kanbo
Date: 2012-04-21

I have installed [PyPy][] on my server and switched my [Kanbo][] test server to run on PyPy.

# What is this thing you call PyPy?

[Ian Carney][] and [Woodrow Phoenix][] invented pie pie, a pie whose filling is
more pies.  PyPy is the same principle applied to the programming language
[Python][]. Python already has multiple implementations: the one most people use is
technically CPython (Python implemented in the [C programming language][]);
people trapped in the Java or .NET worlds can use [Jython][1] and
[IronPython][]. Why implement Python in itself? How is that even possible?

Many languages are in fact *self-hosting*. It works by writing a translator that
converts a program in the language in to some lower-level language for which
an implementation already exists. To port your language to a new platform, you
modify the part of the translator that deals with the low-level details for
the new platform, and run it for the first time on some other system where it
does work, generating a translator that will run on the new one.

There are several reasons why it is useful for a language to be self-hosting:

- Extensions to the language can be written in that language,
  whereas at present to extend Python you need to know C;
- You are writing in a higher-level language,
  with all the advantages of flexibility and expressiveness that gives you;
- Computer-scientist bragging rights, since it demonstrates your
  programming language is powerful enough to implement itself.

Earlier versions of PyPy concentrated on flexibility and correctness: they had
back-ends targeting C, [LLVM][], JavaScript, and .NET, and had demonstrated
the use of pluggable semantics to change aspects of the implementation to make
sand-boxed or threadless variations. Programs ran 100&times;, 20&times; or
2&times; slower than CPython.

More recently the team have been focussing more on speed and compatibility
with large C libraries like [NumPy][]. They have implemented a
[just-in-time compiler][JIT] (or *jit*)
that converts hunks of your program in to optimized machine
code, eliminating the byte-code-interpretation step. The effect of this is
that for long-running programs, PyPy can run your code much faster than
CPython, and, [in sufficiently contrived circumstances, faster than C][1].
Other languages (such as Smalltalk, Java, and recently JavaScript) also
exploit jits to reach acceptable speed; PyPy’s jit is novel in that it is generated
automatically:
you do not laboriously write a separate compiler and plug it on the side of
your interpreter; instead the jit compiler is magicked out of your existing byte-code
interpreter.

In the fullness of time, PyPy has the potential to be the reference implementation of Python. There are a lot of TODO items to be ticked off before that can happen, but for long-running servers where you happen to use only parts of the Python library that are compatible with PyPy, it can be used today.

# Kanbo Compatibility

The [Kanbo][] app runs on [Django][]. Thanks to the cleverness of
[Distribute][], [Pip][], and [Virtualenv][], it is fairly straightforward to
create a self-contained Python environment based on PyPy instead of CPython
and install the identical set of packages in to it I was running Kanbo on.

I tried running Kanbo using the current official release 1.8 of PyPy, I
tripped over [a bug with UTC timestamps][2] (which I only see when you
activate the new time-zone-awareness feature in [Django][] 1.4 and visit the
admin pages). This was one of those ‘for want of a nail’ moments: one tiny
thing breaking the entire sophisticated edifice.

Just to see whether it would work, I tried downloading the corresponding
nightly build of PyPy and creating a new virtual environment. It passed all my
unit tests and also ran the admin fine. So for now that is what the Kanbo test
server is running on.

# Kanbo Performance

Thanks to my colleague Ben Jeffery, I have a database with a single board with
about 20,000 cards in it: too many to sort in the time Nginx allows a request
to take. I should be able to concoct a meaningless benchmark from this, given
a free afternoon.  If I do, you shall be the first to know.




  [PyPy]: http://pypy.org/
  [Kanbo]: http://kanbo.me.uk/
  [Woodrow Phoenix]: http://www.woodrowphoenix.co.uk/
  [Ian Carney]: http://en.wikipedia.org/wiki/Ian_Carney
  [Python]: http://python.org/
  [C Programming Language]: http://cm.bell-labs.com/cm/cs/cbook/
  [Jython]: http://www.jython.org/
  [IronPython]: http://ironpython.net/
  [LLVM]: http://llvm.org/
  [JIT]: http://doc.pypy.org/en/latest/jit/index.html
  [1]: http://morepypy.blogspot.co.uk/2011/02/pypy-faster-than-c-on-carefully-crafted.html
  [2]: https://bugs.pypy.org/issue1060
  [NumPy]: http://numpy.scipy.org/
  [Django]: https://www.djangoproject.com/
  [Distribute]: http://packages.python.org/distribute/
  [Pip]: http://www.pip-installer.org/en/latest/index.html
  [Virtualenv]: http://www.virtualenv.org/en/latest/index.html