#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-24)])

#title()

= Summary
Today work has focused on one thing alone; Moving on with the implementation of
the new version of the algorithm for the `ctest` extension for modules. The goal
set for today has not been met; An MVP is not ready yet.

I started off by implementing a relatively simple version of the proof I had
thought up yesterday to make sure that the types of modules that get fed into
the ```rust super```-resolution function are, indeed, meant to contain
```rust super``` imports.

I did not want to go down this route, but the schedule for the MVP
implementaiton was due today, so I had to go for the simpler solution. This
really goes to say that the reexport resolution function is now overloaded.

On the one hand, the single-module resolution function continues to be generic
over a given module. But before mapping the list of reexports of the module to
be a list of resolution items, it first pattern matches on the module depth.

Let me elaborate. Prior to this, I spent some time thinking about making the
module type a dependent record that would constrain itself depending on whether
it was indexed to be a root module or a node module.

This lead to a ton of a attempts, out of which there were two that seemed viable
and lead to a correct-by-construction proof encoded in the type itself. One of
those approaches also extended to other functions, but I did not go with it.

The reason why is because it would have been one huge timesink to implement the
proof in whole and get it all to type-check. The other approach was simpler, and
makes some parts of the demo non-total, but it fitted the schedule better.

Basically, the module type is now indexed by a natural that makes it a type
constructor. The constructed type contains now a dependently-typed vector whose
number of elements (itself an indexing natural) is the module's index.

This allows us to correlate the module index to the depth of the module in the
module tree, and to the number of segments in the path of the module. This then
also extends to prove that the module contains a non-empty path if it's a node.

This is really the core of yesterday's attempts at providing a more complete
proof than what was required by the helper function of the ```rust super```
import case. The issue came when I started thinking some more about this
function.

The returned natural correlates to the number of ```rust super``` keywords that
have been trimmed from the path. This number is then also trimmed off of the
module path to determine the ancestor we are looking for.

To the type-checker, the relation between the natural yield by the first helper
function (the path-trimming one) and used in the second helper function (the
ancestor-seeking one) is non-existent.

We know that on well-formed input, a module will not contain imports with more
```rust super``` keywords prepended at the start than its depth in the module
tree. This would have been proved had I picked the other approach above.

Another property that I had to hold off from proving is that a module is known
to always have an ancestor in the module tree if it is not the root module. But
this is not encoded in the type nor the function yielding ancestors.

So that function would have had to return a bifunctor coproduct with two
injections corresponding with the const functor and the identity functor. This
is subpar for the whole proof set up I had so I scratched the idea.

Then I came up with another idea that happened to also be simpler. If instead of
munching on all ```rust super``` path segments, we munch on only one segment by
looking at the immediate ancestor to the running state module, we avoid some
complexity.

This comes at a fairly obvious cost in performance, but that was never the goal
to start with. So now the single-reexport resolution function does a
single-search upon finding a ```rust super``` import, and recurses with the
parent module.

If it finds more ```rust super``` imports, then it performs this search anew.
Granted, after the search, we must match on the natural indexing the module so
as to determine whether we should interleave recursion with the root module
function.

This is because the reexport resolution function for node modules needs to know
that the path is non-empty, which is guaranteed only for modules that have a
depth greater than or equal to 1. This is proved by the module index.

A few more things happened today, but either I don't remember them all, or I
have no time to recount in enough detail. The last thing to note is that
currently work is focused on the ancestor-seeking function.

This needed to prove a few properties about the decidability of equality between
vector lengths in the paths of modules we traversed in the search, and those we
know can only be the parent to the module are searching with respect to.

= Blockers
None.

= Plan for the week
I have no MVP yet and the deadline is already there. I will go back tomorrow to
splitting time between the Rust implementation of what I already have of the
algorithm, and continuing ongoing work on the Idris demo.

I do not think I will have finished implementing everything I already have
finished in Idris back to Rust in one day. That should give some extra leeway to
finish the PoC as I start porting stuff to Rust.
