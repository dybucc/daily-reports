#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-26)])

#title()

= Summary
Today work has focused on two things; Working some more on the implementation of
the module resolution algorithm in Rust, and continuing work on the second
revision of the algorithm in the Idris PoC.

A fairly large chunk of today was misspent just staring at the Idris code and
trying to make it more tacit. This is to say the bus factor has increased enough
that it is potentially harder to read now that Haskell with custom extensions.

Something eventful that was accomplished in the Idris PoC is that the
proposition for finding an item in a given module and implying a coproduct with
one of its injections being the found item, has now received a renewed proof.

The above and subsequent uses of the word "proof" are representative of the
Curry-Howard isomorphism between types as propositions, and implementations as
proofs. It thus follows that the proposition of a function is an implication.

Long-story short, the proposition (function) ended up getting the same proof
(definition) as before the refactor that made the module type indexed by a
natural giving its depth in the tree. More on that in the last three reports.

During this process, an issue was found in the way the Idris compiler performs
type inference of lambda-case expressions. These expressions are anonymous
functions that implicitly pattern match the function's parameter as scrutinee.

This is based off of a Haskell language extension, and allows multiple patterns
and subsequent bodies to match against the lambda's parameter. The Idris type
inference rules struggle to unify the return type with the returned expression.

This was found to already be reported as an issue in the Idris GitHub for a few
years now. This apparently volunteer-lead effort on the Idris compiler, which is
not maintained by the original researcher anymore, prompted a new inquiry.

Maybe it would be best to switch to Haskell, which seems to have more prevailing
use and thus better support to solve issues before they become stale. The only
problem here is that Haskell is not strictly dependently-typed.

On the Rust side of things, all of the function signatures and types involved in
the resolution algorithm have been sorted out. The resolution entry-point
function has also been completed.

There is not much to comment on here. The Rust port of the Idris program is
fairly straightforward. One thing that deviated was that recursion can not be
relied upon as being as unbounded as in Idris, where there's some guarantees.

This implied that to keep both the immutability and the unboundedness of the
logic handling the adaptive passes during resolution, the Rust implementation
had to use cyclic iterators and a short-circuiting fold.

This keeps the state immutable across iterations of the fold, while also
allowing there to be a potentially non-terminating computation. The
single-module resolution function was also implemented.

This function does not have much to highlight; It only maps the result of
resolving each ```rust use``` statement into a list of resolutions. The reexport
resolution function is the one that has only had some notes taken about it.

This is the function with the core logic; It handles a single reexport at a
time, and ensures it yields either one of a resolved item or set of items, or
otherwise an unresolved marker.

The Rust port needs to differ a bit more from the Idris implementation in this
instance. To really be thorough, the function must handle renames in
```rust use``` trees, which thus far had been ignored in the Idris PoC.

This is not anticipated to be too hard to implement, so it will be promptly
ready. Beyond that, another change has been made from the Idris PoC; The
returned type in this function is no longer a list, but a single resolution.

This change could also be done in the Idris program because the reason for
returning a list is only tied to the original implementation. This one did not
refine the type of ```rust use``` trees; A group import could yield multiple
resolutions.

= Blockers
None.

= Plan for the week
As outlined yesterday, the plan is to have the rest of the Idris proof finished
tomorrow, and go back to the tutorial by Monday. This is a hard cap. The Rust
port I had set a soft limit for tomorrow, and that may just be achievable.

It is unlikely that the Idris proof will be finished by tomorrow; Either way, it
is worth trying. The only unfortunate thing here is the `ctest` PR will have to
be updated to reflect only the initial revision of the algorithm.
