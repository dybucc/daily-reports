#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-20)])

= Summary
Today work has focused again on completing the proof for the Idris demo to the
algorithms I designed for the purposes of extending the `ctest` test harness
with support for modules. I also worked on some `libc` PRs.

The bulk of today, though, was solving the typing holes that I had left
sprinkled across some of the functions. The point of the proof is to show to the
type checker that a normalized module contains no group imports.

This I had had a decent amount of success in proving yesterday. This time I
learnt that typed holes in dependent pairs do not get resolved automatically by
the type checker.

This meant that parts of the proof I thought were complete weren't actually. So
I got to work on getting the normalization function working, and on considerably
simplifying the building blocks reused across parts of the proof.

One of the things that I noticed as I went through this, was that I consistently
needed to extract the list of reexports of a module that was already proven to
be group-clean, into a list that was also proven to be group-clean.

The inverse operation, getting a list of group-clean reexports put back into a
module to yield a provably group-clean module was also something I found to
often need.

These two operations mostly piggy back on each other, as all they do is traverse
their corresponding arguments. The recursion additionally passes off the
deconstructed proof witness from the prior step to the next converging state.

While working through these, I also found that the type I used as proof witness
for a whole module to be provably group-clean was unnecessarily complex. I
repeated each of the possible ```rust use```-tree constructors in its variants.

This actually lead to very messy proof searches by the type checker for the
auto-implicit arguments to the witness' data constructors. The solution was
simple; Make it a two-case inductive type instead of a $k$-case inductive type.

Basically, the vacuously true case is that of the module with an empty list of
reexports. Then comes the case where we have an externally-sourced module with a
non-empty list. For this, I previously considered adding each case of the tree.

Now I simply consider adding _some_ case of the tree, itself already constrained
by another proof-searched witness type. This more fine-grained proof witness is
the same one I used yesterday for proving that a single tree is group-clean.

Solving this lead me to get a fairly simple way of going from having a module,
to a list of filtered trees, to a provably group-clean module. This is the whole
point of the normalization algorithm, so that was done after I finished this.

Then I also addressed the merge function, which handles getting a provably
group-clean module merged with a list of resolved trees. This also used a hole
to get the type checker to perform a proof search on the merged module.

Granted, proof search has its limits, and typed holes just don't cut it. So
instead I started working on doing the roundtrip from a provably group-clean
module to a list of provably group-clean trees, to then transform those.

Those get the reexports that were found to be in the resolved item to merge
removed from the merged module's reexports. Then they do the roundtrip transform
back from a list of provably group-clean trees and a module, to a proved module.

This last roundtrip I have yet to implement, but I do not think it will be too
hard. A challenge I did not yet get to solve today was one concerned with the
linearity of the input dependent pair to the single-module resolution function.

This function now takes a dependent pair to ensure I can prove that the module
contains no grouped imports. But for some reason, the type checker complains
about the linearity of an auxiliary type that temporarily holds modules in it.

This type I had since the initial draft implementation, as it served me to unify
under a single umbrella both modules and non-modules when looking them up upon
finding a name during reexport resolution.

I say "for some reason," because I intuited the dependent pair could be the
reason for the type checker to complain. Unlike other errors, there is no
backtrace, so tracking down why is it that this happens has been put on hold.

= Blockers
None

= Plan for the week
I expect to continue working on the `ctest` extension for the rest of the week.
That was the plan I set a few days ago, expecting the draft implementation to
take longer to complete. This has not been the case, so I the plan has changed.

The change is minimal; I will continue addressing matters concerning the Idris
proof tomorrow, and I hope to have gone back to more `ctest`-centric matters by
Wednesday. Then I will start work on the driver algorithm to finish it all.
