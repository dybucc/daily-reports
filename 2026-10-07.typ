#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-07)])

#title()

= Summary
Today work has focused on four things. The first one was the write up for the
status update in the `ctest` extension PR. Then came work on the revised
algorithm. Then came Idris work. And then came tomorrow's work.

The write up was almost ready from yesterday. More time than expected was spent
here. The editor integration for the Markdown formatter did not quite work. It
is custom built. So that needed some work done.

The PR now reflects the latest state of the patchset. It currently has a working
implementation of the first algorithm revision. This is the one that does not
support bidirectional `use` statements.

Then came work on the revised algorithm. This had been put off for a bit over a
week now. The deadline for the Idris proof had not been met. But now discussion
has started anew. A new strategy has been devised.

A brief summary follows. Nothing has been implemented yet. The current algorithm
relies on the fact no resolvable modules will be found in leaf modules. This is
not the case anymore in the presence of backward `use` statements.

These can refer to any one item in the crate. This could be an ancestor. So the
whole depth-first approach to resolution is not feasible anymore. The
single-module pass system does not work anymore.

A module now requires its resolution passes not to be strictly consecutive. So
the entire approach to resolution should change. Resolution should take place in
seemingly "infinite" tree-wide passes.

This means one pass per module at most. But it means any number of passes per
crate module tree. The termination condition on `use` statements is removed.
This is replaced by a comparison of the entire module tree between global
passes.

This exploits deduplication. A use statement that has yield a resolution is
immediately resolved. It matters not whether the target contains other `use`
statements. These will not be merged.

A module gets a single pass per global pass. The global passes compare the
pre-global state with the post-global state. Global here refers to the crate's
module tree. No actual global state is involved. It is all pure computations.

The key is that `use` statements are not removed. This allows a subsequent
global pass to resolve the same `use` statement anew. This may bring over new
items. But it will definitely bring over duplicates. Those are removed during
merging.

Idris work has progressed nicely. More problem sections have been completed. All
problems thus far still do not require proofs. But temptation has been mostly
resisted. Some proofs have been crammed in for convenience's sake.

The last thing today was miscellaneous `rust-lang/libc` work. This was scheduled
for tomorrow. But it was done today. It was fairly simple. The newlib PR from a
few weeks ago broke an out-of-tree Rust target.

The support policy for out-of-tree targets is basically non-existent. So
"support" excludes the fact they got a PR merged for their target a few years
ago. Though maybe maintainers would not mind it. They've been pinged.

The other one was a quick little fix to the documentation generation patch. A
reviewer asked to move some stuff around. It makes it look more cohesive. That's
done now.

= Blockers
None.

= Plan for the week
The `ctest` extension work will continue tomorrow. The `rust-lang/libc` matters
may have also gotten an answer. That will take up some of the open source
intervals of tomorrow's work. But the priority remains the revised resolution
algorithm.

Idris work will continue as planned.
