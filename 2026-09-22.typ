#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-22)])

#title()

= Summary
Today work has focused on a couple of things around the `ctest` extension;
Testing out the initial version of the algorithm, fixing a bug and moving on to
work on an improved version with support for bidirectional reexports.

Firstly, I started off by working my way through a few more tests that I thought
exercised some fairly good edge cases during module resolution. Of of these, one
of them surfaced a flaw in the current design of the pass system.

Until then, I had used two passes for all resolution matters, trusting that this
would be enough to resolve any unresolved reexport. This turned out not to be
the case, and I also inferred an observation on the required amount of passes.

Basically, a module that has a number $n$ of reexports for $n > 1$, out of which
we can only resolve 1 reexport, has a specific behavior. This holds if the
remaining reexports (i.e. the other $n - 1$ reexports) are resolvable.

We define resolvable reexports as those for which we need not have knowledge of
some third party crate to understand the source item to which the reexport
refers to. Unresolvable reexports are thus all imports from third-party crates.

For each of those reexports, if we can draw a non-associative dependency
relation between each of the remaining reexports, we can infer the number of
passes that will be required to fully resolve the module.

In other words, if a given reexport is seen as a boolean clause awaiting
satisfiability, and the resolution of a reexport can introduce sentences that
satisfy this clause, we can infer an order in which reexports will be resolved.

The inverse relation to this order forms the binary dependency relation between
reexports, and the sum of those relations, which can be seen as morphisms in a
category, yields the number of passes that are required for a full resolution.

I found a nice way to express this algorithmically, but realized that it would
require a lot of work to implement. I want to start working on the Rust port
before Friday, so an MVP has to be ready before then.

A simpler approach, which is the one I eventually followed, consisted solely of
the initial idea I had for the algorithm; Diff the result of each pass. If the
pre-pass module diffed equal to the post-pass module, then halt.

This allows ignoring unresolvable reexports that simply will not be satisfied by
any of the modules in the crate. The diffing I implemented minimally; Match the
number of reexports pre-pass with those post-pass, and compare for equality.

Now the pass system adapts to the needs of each particular module. With this
done, I decided I could gone one of two ways; Either report on the work done
thus far in the PR, or attempt to implement support for ```rust super```.

Thus far, my algorithm fared just fine under the assumption that a reexport
could only introduce items from descendant modules. If I added support for
```rust super```-relative reexports, I would have to rethink a few things.

So I got to it, and have since come up with a few ideas, out of which I decided
to start implementing one. I will explain only this one because I'm running out
of time for today's report.

The algorithm has been changed to now have a driver function takes the input
module tree, and calls the resolution function, which now takes a pair of a
module tree and the module it is currently resolving.

The module tree is now carried as state. We first recurse through each child
module until we bottom out on the leaf modules (those without children.) This is
where we do the same resolution as before, but update the state as well.

After merging and getting an updated module, we look up the module in the module
tree we use as state, so as to update that state. This is again returned to the
calling function, so as to allow prior call stacks to use an updated state.

This updated state is used as well in the reexport resolution function to looks
up any reexport paths that have an arbitrary number of ```rust super``` keywords
prepended to them. This keyword is not accepted as a raw identifier.

It thus needs no special handling in the demo, and likely will not in the final
Rust program. The whole thing works because the original algorithm (and this
revised version) perform resolution in a bottom-up manner.

= Blockers
None

= Plan for the week
I expect to continue working on this and ironing out holes in my understanding
of the revised algorithm tomorrow. Supporing bidirectional reexports is annoying
because a lot of the cleanliness of the original idea is gone.

Still, I think I have an idea to perform a stateful lookup of some $n$-number of
modules before the target module once I hit some ```rust super```-prepended
path. This would really be a sliding window algorithm, only on tree nodes.
