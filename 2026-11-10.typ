#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-11-10)])

#title()

= Summary
Today work has focused on two things; The `ctest` extension matters and the Lean
problem on the monadic evaluator with multiway calculations. Both have seen
great progress, and I can surprisingly say the parsing refactor was not buggy.

The first thing that I did was to test out the parsing refactor of the `ctest`
extension PR. That turned out better than expected because I didn't have to
debug anything. The thing worked in one go.

While doing that, I found I could simplify the core parsing logic in `syn`'s
visitor interface by moving some code to the post-parsing stage. That also went
well, so I started testing if resolution worked again.

Testing out the successful cases from two weeks ago, I found that resolution
also worked nicely. This does mean that we can finally come back to working on
the next revision of the resolution algorithm.

Lean-wise, I have gone through a few iterations of the monadic evaluator. Thus
far, I've found one idea that seems like it could work. Instead of having an
expression register operations, we go one step back during parsing.

The expression representation on which evaluation takes place considers one of
an atom or a function applied to some list of operands. This function injection
currently also holds a function proper producing a monad over #sym.NN.

This essentially requires that there be a monad in context during evaluation,
such that it may perform the operation. The monad is really meant as an
extension to the monad type class, where binding is not done during evaluation.

This extension type class is essentially a generic handler that takes a list of
monads of its type, and a token (a raw string.) Then it performs whatever
operations it sees fit and yields another constant in its type.

This I've yet to flesh out so that I don't literally require the handler to be
"registered" at parse-time. It would be best if the function injection on
expressions didn't have any functions within it.

= Blockers
None.

= Plan for the week
I expect to continue working on the next revision of the resolution algorithm
tomorrow. I think this is finally it, and we should probably be bound to move on
to the next stage of the PR by the end of next week.

Lean-wise, work will continue as per the usual.
