#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-05)])

#title()

= Summary
Today work consisted of two things. A bit of a third thing also had to be done.
The first thing was the `ctest` extension. The next thing was the Idris
community tutorial. The latter continues from past weeks' efforts.

Last week an issue had been found in the `ctest` algorithm. A recap follows.
This algorithm is used to resolve reexports. It is part of the extension PR. It
is needed to consider all paths an item can be referred to by.

This is then used in the skips. These are small utility functions. They are
exposed to `ctest` consumers. They skip testing certain symbols. But those
symbols could exist in paths other than their source path.

Last week the first revision had been finished. This implementation was being
tested. The item container can end up with duplicate items. These come from
"different" reexports. But these reexports refer to the same items.

This always holds for non-malformed input. This stage in `ctest` always gets
correct input. So a deduplication proposition was proofed. This was finished
today. Only the proposition had been elaborated last Tuesday.

This was then tested. Another bug was then found. This time it was unrelated to
any `ctest` extension patch. It is a bug that currently lives in upstream. `syn`
```rust Visitor``` hooks run on all parsed items. This is sometimes a problem.

One such case are foreign blocks. These can exist within a function body. They
can also exist within a module. But only the latter can be tested. This is
because only the latter have a "global" path.

Nobody seems to have reported this issue. It is an odd usecase. It would pop up
if some downstream consumer had function-level ```rust extern``` blocks. This
has a simple fix. It is the same fix as used for imports. That was part of the
extension.

Parsed reexports can not always use the `syn` ```rust Visitor``` hooks. This is
because of the same reason as above. Function-level ```rust use``` statements
should not be considered for resolution. The solution for other items is the
same.

Idris work has started with the community tutorial. The first few chapters have
been finished. Extra time has been spent on the problems. This is to satisfy
stricter requirements than those in the statement.

Most of this has revolved around point-free style proofs. This is otherwise
known as tacit code. Duplication of parameters seems impossible. Tacit seems to
work only when no duplicate parameters are expected.

= Blockers
None.

= Plan for the week
The plan for the week follows as expected. The first three days will go to
`ctest`. More tests have been run. They seem to prove correctness of the
implementation. A write up to update the PR status is in the works.

The Idris work will continue. There is not much to comment here. Though there is
one thing to keep in mind. One must avoid the temptation of proofs of
correctness. They are one huge timesink. They will have their time and place.
