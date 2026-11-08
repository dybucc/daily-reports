#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-11-08)])

#title()

= Summary
Today work has focused on two things; The Lean problem on the arithmetic
evaluator, and the problems from the first lecture of the Haskell course. I also
got to tweak a bit of the intercepting proxy.

The Lean problem saw me going through a bunch of refactors to make the
functionality I added simpler. This also came with a bunch of instance
definitions for coercions to make the code cleaner.

Progress on the "choose" operator has barely been made. The idea I had when I
added a new data constructor for the expression type didn't pan out. The plan
was to associate permutation lists and sequence the inner monads.

This didn't go too well once I actually got to it, but by this time of the day I
had already run out of time. The time I allocated for Lean work ended up being
mostly spent on refactoring error handling facilities for the generic monad.

Haskell-wise, things have gone fairly well. I continued working through the
problem set for the first lecture of the course. The first lecture has two
problems, of which I have solved one in full and have planned for the second.

The first problem didn't prove to be too much of a challenge because it was
about building a credit card validator. The steps for the actual validation were
already given so all you really had to do was to define it.

The second problem was to solve the Hanoi towers problem. This was nicer in that
the course authors have a third, optional problem that expands the scope of the
problem. I decided to bite bigger and do something different.

The proposed approach to the problem is fairly brief in that it doesn't go
beyond what one can infer from just staring at the problem for a few minutes. So
I decided to attempt a dynamic programming approach.

Granted, this meant I had to think a bit harder than I would in, say, Rust,
because my memo table must be immutable. The first idea that came to mind and
that I have been working on is to use a state monad.

I decided to go for a tuple-based state monad, where the state I keep is the
memo table (really a list) with explored states. Then I modeled the states as a
triple of pegs with a stacking relation between pegs and the number of disks.

A function would handle considering the available moves in the current state,
based off of the "stackability" of some peg with respect to another peg. Then
another function would explore the path stemming from choosing each move.

I've yet to think better about how would I handle early termination in the
monad, so there's that. But that will wait until next weekend.

= Blockers
None.

= Plan for the week
I expect the `ctest` extension matters to resume tomorrow. This I had left at
finishing the filtering logic refactor, which would then allow me to move on to
testing and potentially debugging the parsing refactor.

Lean work will continue as per the usual.
