#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report: (2026-10-01)])

#title()

#quote[Today the style is different. More tacit expressions are used. Less
  verbose forms are used. This should make the reports clearer.]

= Summary
Today work has focused on two things. Work on the CI set up continues. This is
concerned with the uClibc PR. Work on the Idris proofs also continues. This is
concerned with the integer to natural casting proposition.

The CI work has progressed. It is not yet finished. It has been confirmed that
Buildroot does not have LFS options. The usual macros get set by default. This
means there is no need to have a custom toolchain.

The same toolchain as used by Mr. Petri will do. This has been used to run
tests. They run against the uClibc PR branch. That includes the patch for LFS
support in rust-lang/libc. It also contains fixes for some other records.

Multiple issues were found. CI has thus far never finished a run. There is
always something broken. Some of it was due to the patch. Those issues are now
solved. The first one was about an incorrect path to a type alias.

Another error was about a function pointer signedness mismatch. This was
trickier to solve. The patch in the PR picked the wrong definition. uClibc has
different definitions for some record fields.

One definition is exposed under X/Open 2008 compliance. Another is a legacy
version. uClibc also provides compatibility shims. rust-lang/libc is in a
delicate position. It has bindings for the compatibility shims.

Those were updated. The patch was intended to update rust-lang/libc's bindings.
But instead it replaced them with the full legacy bindings. There is an ABI
mismtach between them. The identifiers are the same.

Realizing this lead to solving the issue. Then came other errors. Those were
found to be concerned with a libc script. It runs on CI for all targets. It
checks that documentation generation works on all targets.

But it does not build std. This causes issues in some targets. Most tier 3
targets do not have a prebuilt std. It needs to be built alongside the crate.
This also applies to documentation generation.

A patch was devised to solve this. The fix is relatively simple. But currently
there is another issue. The CI workflow for the PR has a "template patch." It is
used to allow external patches on top of rust-lang/libc.

There is no need for that here. But the CI workflow fails to apply the
"template" patch. It reports the target file does not exist. This is not yet
solved.

Proof work has also progressed. Though it has been slow. Efforts have gone into
use of an integer view. This was commented yesterday. It provides structure to
the integer primitive. This makes it easier to reason about theorems.

The proof was about integer to natural conversion. This lead to another proof
about integer overload. This lead to the design of propositions. These set a
non-negative constraint on the integers.

Use of the view requires a refactor. The refactor has started. The proposition
for non-negatives is done. It has required some back and forth. This is due to
the expected shape of index terms. Term unification is not too smart.

So the type checker requires some care. That is done now. Sources are not
available. They will be once the proof is done.

= Blockers
None.

= Plan for the week
Work on CI has a hard cap. That limit was set to tomorrow. It is expected that
current issues will be sorted out by then. This weekend will be spent
differently. An NGINX forward proxy server will be set up.

It is unlikely that that will be finished by Sunday. It will continue next
weekend. Idris proof work continues. It goes at a slow pace. The hard cap for
the current proof is set on Sunday.

Current proof efforts are on "uninhabitedness." This is a bit hard. The
impossible non-negative proposition needs specific indices. These must
correspond with the topology of the integer view. Fresher eyes will tell better.
