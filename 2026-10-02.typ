#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-02)])

#title()

= Summary
Today work has focused on three things. The CI matters have been resolved. New
matters concerned with the GNU/Hurd have been researched. Work on the Idris
proof has continued.

Yesterday's CI issues are solved. The patch failure was not reproducible. A
re-run did the trick. The documentation command patch was submitted as a
separate PR. The uClibc PR got feedback from a maintainer.

They preferred to close the PR. The target maintainer did not have immediate
need for LFS. The proposed solution was to keep it as a draft PR. Maybe somebody
in the future would need it. But the maintainer thinks otherwise. It's closed.

The `time_t` tracking issue also received comments. Last a comment there
provided a brief overview of the GNU/Hurd's support. The maintainer mentioned
the current bindings were probably not enough.

This was researched. The details can be found in the tracking issue. A brief
summary follows. The GNU/Hurd has no support for 64-bit overrides. Its default
`time_t` bitwidth is target-dependent. So `time_t` matches machine word size.

This means there is no need to change the Rust bindings. The current ones
reproduce that exact behavior. Glibc also has symbols name redirections. This
only applies to Linux targets. That means no work is needed for the GNU/Hurd.

The Idris proof has progressed nicely. The uninhabitedness proposition was
completed. This indicates the non-negative proposition cannot have positive
indexes. But the way there needed simplification. The initial idea changed.

Yesterday's attempts were at a general proposition. The Idris type checker needs
a full type in interface propositions. That requires proof-search in inductive
types. The proof space is infinite for the general case.

The structure alone of the non-negative's index is insufficient. There is no
proof for the non-negatives that uses a predecessor view. That implies data at
the type level is not matched. The type resulting from it is matched.

The data construction here refers to another type. This other type is implicit.
It is also inductive. It is codata over the infinite number line. This means big
trouble for totality. It also means the type checker will not halt.

But it halts. Only it halts with an error. That took a while to sink in. The
uninhabitedness proposition has to be over the inductive hypothesis. That means
the first negative. That means the predecessor of zero.

The inductive hypothesis here builds on a one-step induction. The inductive
hypothesis of the non-negatives is zero. The one-step negative induction is thus
impossible. No proof can be constructed for such a non-negative.

This meant a lack of generality in uninhabitedness. That means a need for
contraposition lemmas. But then a new idea came to mind. The non-negative
proposition does not capture all non-negatives.

The view over primitive integers was misunderstood. It is unlike Peano numbers.
It is a sum. One starts with zero. That happens to be the inductive hypothesis.
Then the predecessors are sums of negatives. The successors are sums.

The non-negative proposition was conceived wrongly. It assumed non-negatives
only exist when built without predecessors. But a sum containing some negative
term can also yield a non-negative.

Such a sum needs fewer or an equal number of negatives as positives. The analogy
translates well to the coproduct view. A given non-negative can be proofed with
multiple topologies. It can be solely the inductive hypothesis (zero.)

It can also add some number of successors. But it can also add some number of
predecessors. The number of predecessors must be smaller than or equal to the
successors. That is the essence of a non-negative.

So work started on a new proposition. This proposition only counts the
predecessors and successors. This is fairly simple to proof. The tricky part is
the compliemntary proposition.

It assumes an integer. Then it implies the above proposition. But it does so
with an ordering proof obligation. The successor counter ought be greater than
or equalto the predecessor counter.

= Blockers
None.

= Plan for the week
Work on the uClibc PR is officially done. The GNU/Hurd research seems solid. An
answer is awaited. The plan is to answer to the command fix PR next week. That
should happen on Thursday. The other days will be dedicated to ctest.

The Idris proof work will stop on Sunday. It is engaging. But the Idris
community tutorial must be finished. Two more weeks will be given.
