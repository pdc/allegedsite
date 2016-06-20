Title: BDD using Jasmine and Karma
Topics: bdd tdd jasmine karma st-ouses
Date: 2016-06-12

With any non-trivial bit of code it is useful to be able to test the
parts in isolation before trying to assemble them in to the final
program. In the Python world you use a standard library called
`unittest` for this (other testing libraries are available). In
JavaScript there are many competing test frameworks, all with daft
names.

The combination I am using for [the St Ouses example][prev] is Jasmine and Karma.


# Jasmine the <s>test</s> specification language

[Jasmine][] describes itself as behaviour-driven development
framework.


## What is behaviour-driven development?

BDD is an evolution on [test-driven development][2]. Here’s my take on it.

The origins of TDD was a desire to increase the quality of program code
by writing automated tests for the units of code as you write them. By
[writing tests for new code before you write the code itself][1] you gain
insight in to how the interfaces between units should be designed and
generally are obliged to come up with better modularized code.

I think it is also good for morale compared with writing tests after
the fact: writing a new test and seeing it fail is good because it
confirms you know what you need to do next, and writing code is all the
more satisfying because you have more confidence it is correct!

I tend to describe  BDD as TDD with better names: it replaces  _test
suites_ and _assertions_ with descriptions of behaviours and
expectations (also called specs).

Specs describe parts of the system by describing a behaviour you want
to implement. Many BDD systems use a separate language for writing
specs (using English phrases introduced with the keywords `Given`,
`When`, and `Then`, and intended to be shared between programmers and
the customer representative). THis requires a translation step before you can execute the tests.

Other BDD systems, such as [RSpec][], use specially written and
cleverly named functions to enable you to write test in Ruby that
almost read like English.


## BDD with Jasmine

With Jasmine you write specs in JavaScript, of course. They look like
this:

    describe('withLoadedEntity', () => {
        it('can create state with loaded entity with full URL', () => {
            // Given state without a loaded entity for this URL
            const state0 = …

            // When we add an entity using a full URL
            const fullUrl = 'http://example.com/bar/person4.json';
            const entity = { … };
            const state = withLoadedEntity(state0, 'person', fullUrl, [entity]);

            // Then the new state contains the loaded entity
            const expected = { … }
            expect(getLoadedEntity(state, fullUrl)).toEqual(expected);
            expect(getLoadedEntity(state, 'person4.json')).toEqual(expected);
        });
        …
    });

Jasmine supplies the `describe`, `it`, `expect` functions and other
facilities for faking other parts of the program.

Generally specs fall in to three parts (sometimes the first or second parts are empty):

1. setting up the initial state of the system under test (the ‘given’ part);
2. performing some operation that affects the state (the ‘when’ part); and
3. expectations of what the state will be afterwards (the ‘then’ part).

There is a certain art to writing specs. First there are the technical
requirements that they run and depend only on the thing you are trying
to test and so on. There is also their other main role—as documentation
for your code. They need to  sense to someone (such as your future
self) reading the code to work out what it means.


## Karma the test-runner

Jasmine also has features for test discovery but instead of using those
I am using a package called Karma.

[Karma][] is a test runner, so it is responsible for finding the spec
(test) files and combining them in to a bundle that can then be run in
a browser (or in PhantomJS). The idea is to test your code in the
dialect of JavaScript it will actually be deployed to.

Using Karma reuses the [Webpack][] configuration used to build the
production code, meaning that it uses the same polyfills and JavaScript
modules. This is important because the assembly of code into modules
and packaging by Webpack all involves mutating the JavaScript code and
potentially introducing incompatibilities.

Karma—like most JavaScript build tools these days—can run in file-
watching mode, where it reruns the tests automatically when you save
source files. This works will with a multi-screen set-up, where you
leave the window running the Karma visible somewhere while working on
the code.


# Other test frameworks are available

This is a big change from how I have developed JavaScript up until now.
Previously the major logic of a site was in the server code and the
JavScript was a little bit of icing on the top of the cake. It is
notoriously hard to test user interfaces, so we relied on manual
testing and hoping things did not get broken too often. As the amount
of client-side code has increased this has become untenable, and
automated testing has become an important part of the JavaScript
programmer’s workflow.




  [1]: http://c2.com/cgi/wiki?CodeUnitTestFirst
  [2]: http://c2.com/cgi/wiki?TestDrivenDevelopment
  [prev]: 04/24.html
  [Jasmine]: http://jasmine.github.io/2.4/introduction.html
  [Karma]: https://karma-runner.github.io/0.13/index.html
  [React]: https://facebook.github.io/react/
  [RSPec]: http://rspec.info/
  [Redux]: http://redux.js.org
  [Webpack]: https://webpack.github.io

