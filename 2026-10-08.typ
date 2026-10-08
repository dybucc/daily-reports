#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-08)])

#title()

= Summary
Today work has focused on two things. The first one was the Idris proof work.
The second one was the `ctest` extension work. There have been no news on other
matters `rust-lang/libc`.

The proof work has gone fairly well. One problem has stuck out the most today.
This did not need a proof. A proof was devised anyway. A far simpler solution
has recently been found. This was a fairly big timesink.

The `ctest` extension work followed up from yesterday's findings. The new idea
to support bidirectional reexports seems feasible. A few more tests were
simulated. Then implementation efforts started.

This has thus far gone well. The idea itself remains unchanged from what was
explained yesterday. Resolution of any item throughout the crate graph required
more thought. This is required with absolute paths.

The idea is the same as with the Idris proof. That was two weeks ago. A
refresher is in order. The state is now made up of a pair of module trees. This
state corresponds to the one used in the single-reexport resolution proposition.

The prior piece of state remains. This is the parent module to the segment of
the reexport's path being munched. The additional state corresponds with the
entire crate's module tree.

This is required when a path refers not to an item in the existing state. This
could be any other node in the module tree. This new state is "updated" each
time a pass over a module is finished.

A single-module pass now does no work to determine termination. That is left to
the global pass proposition. The whole-crate module tree integrates the changes
that come out of resolving a given module.

And that is about it. Almost everything has a draft implementation. The only
exception is the proposition that integrates a post-pass module subtree into the
whole-crate module tree. The ideas were already laid out in the Idris proof.

= Blockers
None.

= Plan for the week
The `ctest` extension work will continue tomorrow. It is likely that the
implementation may be complete by then. It is unlikely that it will be tested by
tomorrow. Idris work will continue as usual. The hard cap on Idris is next week.

The goal of this weekend is to follow up last weekend's work. This consists of
setting up a forward proxy server. Last weekend proved NGINX would potentially
be a bad fit. Maybe tweaking kernel routing tables will get it done.
