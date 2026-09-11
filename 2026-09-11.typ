#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-11)])

#title()

= Summary
Today work has focused on a couple of things; Working through a new issue that's
popped up recently in `nix-rust/nix`, reviewing the implementation plan for the
`ctest` extension patchset, and looking some more into Idris.

I started off by looking into a new ping I had gotten on the `nix-rust/nix`
repo. This is a crate that provides safe bindings around `rust-lang/libc`
symbols. They were experimenting with changes we are yet to release.

Their tests were failing on a certain set of `signal.h`-related wrappers, so I
looked through the commit history in the `libc-0.2` branch. I found there that
my recent patch completing the `siginfo_t` definition introduced a regression.

In the PR that I opened, I replaced two untagged unions for regular records.
This, of course, is fatal for `siginfo_t`'s `sifields`. Reading from it after
crossing an FFI boundary gets you garbage, if not immediate UB.

Luckily, those changes, even though backported from the 1.0-tracking `main`
branch, have not yet been released. I opened a new PR fixing this, and reported
on this as well back in the `nix-rust/nix` thread.

They cherry-picked the commit from my branch and it seems the tests run just
fine now.

The next thing I did was to submit the follow-up PR to the afore-mentioned
`siginfo_t` patchset, which the reviewer requested to remove skips in the build
script. Unfortunately, we could only remove the Linux skip.

Then I looked through the `ctest` extension patchset. I have not touched that
since last week, though I recall that I had reached the point where I needed to
implement item resolution at the module level from parsed `use` statements.

The plan back then was to perform one more pass after all items had been
recursively parsed (including modules.) This pass would use the parsed
`FfiItems`, and clone parsed items throughout modules by detecting reexports.

I still think this is the easiest way out, though once I started looking into
it, I realized I was missing LSP assistance. After my recent workflow switch,
the editor I am using is not LSP-enabled.

This prompted me to also spend some time today looking into setting that up.
That is still not done, but I expect it to at least get me go-to-definition and
other "basic" goodies by tomorrow.

Then I also looked into the Idris documentation, and worked through the first
few sections of the crash course. I also finished up compiling `pack`, the
toolchain and package manager for Idris.

I have yet to actually write some code in it, but I would like to first finish
setting up LSP on my editor. Apparently, the `idris2-lsp` is pretty nice.

= Blockers
None.

= Plan for the week
I expect to resume work on the `ctest` extension stuff by tomorrow, once I get
LSP working on my editor. The afore mentioned implementation plan continues to
be the way I'm envisioning it.

In terms of side-project work, I believe I'll be working through the rest of the
crash course and the community tutorial until the end of the week. It may very
well take longer, though. Then I will work through problems in the OCaml repo.
