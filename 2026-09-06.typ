#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-06)])

#title()

= Summary
Today work was centered on two things; Getting the `ctest` stuff fully sorted
out, and continuing work on the Typst parser.

Today I finished up work on updating all of the test generator functions under
the ```rust template``` module. This I had already started on a few days ago,
but didn't quite finish up because as I went through them, I found more and more
spots where I needed to also tweak uses of the ```rust ident``` and
```rust path``` functions.

This has so far been met with success. The tests seem to parse just fine, but
now there are no tests. Bear with me. I then decided to tidy up the commit
history so as to have something coherent to follow through in the draft PR. This
has left me with 9 patches that handle parsing modules, filtering on modules,
skipping items by using their full paths from the crate root, and generating
tests that properly refer to the right item paths (as previously they just
assumed all symbols from the Rust crate would be available at the consumer
crate's crate-root.)

The issue now lies in that I forgot to implement support for parsing
```rust use``` statements. Previously, there was no support in `ctest` for this,
as we recursively traversed the whole crate module tree, and assumed that
whatever users wanted tested would be reexported or, more generally, be made
available at the crate root. But now that module support is incoming, we need to
take care of which ```rust use``` statements appear where in a given module.

This I have yet to come up with a solution for and try out implementing it. Thus
far, I've thought about potentially walking the parsed `syn` tree twice; Once
with the current ```rust FfiItems``` (which I already extended to support
recursively storing modules and items defined only within a single module,) and
a second time with some helper type that would carry with it the now filled-in
```rust FfiItems```, and would scan it whenever it stumbled upon a
```rust use``` statement.

This way, even though costly, I could potentially perform a crate-wide lookup
through ```rust FfiItems``` and use the helper type to add symbols to be tested
from other modules into the generated tests, whenever those were reexported at a
given module. Still, this is only an idea I came up with late today, and I may
very well scratch it tomorrow for something else.

In terms of compiler work, I have continued yesterday's refactor on the Menhir
parser, so as to adjust the now wrong OCaml semantic actions associated with
certain productions and types exposed in the accompanying helper module. This is
now completely done. I have changed the way bindings work, which I already
commented on yesterday, and finished executing on today.

I also added support for unary operators, which I had left on hold way back
before I had even read the menhir manual, as I was struggling then to find a way
to denote the precedence of such symbols over binary operators without
artifically modifying the grammar too much. Ever since then, I've learnt about
precedence annotations for productions in Menhir, and that made it extremely
simple to work this out.

I also got rid of the constrained expression types that I used in the operator
type, as those I can't really constrain on the Menhir side. I commented on this
yesterday, and the final decision has been to use the wildcard expression type I
have at parse time, and only constrain the type once I'm working on the
evaluator.

I also had an idea for a pp or ppx rewriter that would let me annotate a type
with special syntax with which to inline it to the type equation on its rhs,
such that if it uses polymorphic variants as markers parameterizing it, another
passed in #sym.alpha can expand on those markers and artifically "extend" the
closed matching by working straight on the source text or AST. I've explored it
some, but decided to leave it for some other day, as it is not high-priority at
all.

Then I tweaked almost everything else that was left as `TODO` comments in the
Menhir parser, which included changing the semantic actions for the productions
that handled control flow expressions, and tweaking an old idea I had tried out
for separately fetching tokens in the lexer for numbers and metrics (Typst as
primitives types for stuff like inches, points, radians and degrees.)

= Blockers
None.

= Plan for the week
I will continue thinking on this new problem about handling ```rust use```
statements in `ctest` tomorrow, as I only realized this quite late today. I
think it won't be that hard once I actually get my hands dirty with it, but I
can't quite say for sure.

In terms of compiler work, I'm currently trying to figure out why is it that a
certain error is popping up in the Menhir grammar for the production handling
show and set rules (in the Typst sense, not the grammar sense).

It complains that the production group that yields show rules is returning an
expression in its semantic action that fits a show rule, but is expecting a set
rule. This is extremely odd as I highly doubt there is any way an input sentence
can get to this state of the automaton while parsing a show-set rule, which is
the only one that expects a set rule with a closed matching on its type
variable. I'm very confused by this one, but we'll see tomorrow.
