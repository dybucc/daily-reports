#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-10)])

#title()

= Summary
Today work has focused on two things; Working through the last few PRs I had
pending feedback on in `rust-lang/libc`, and looking into the Idris programming
language.

I started off by looking into the last two PRs and issue I had to comment on.
The patchset introducing the `time64` `cfg` I had almost finished working
through yesterday, and today I rounded it off with a quick fix to CI.

The `rust-lang/rust` PR implementing the MCP for embedding the `-current`
release supported by OpenBSD targets has also been addressed. This one only
needed a quick little fix in new documentation.

The reviewer for that PR also mentioned that we could temporarily add to the set
of expected `cfg`s for diagnostics in the compiler the new value introduced by
the `target_env` in OpenBSD. I previously noted this was a subpar solution.

A good implementation goes through extending the whole `cfg` system for this
type of ranged "version" values. There is an RFC for this, but it is still a
long way off; Hardcoding values i something I would prefer to avoid.

I also commented on the tracking issue a `rust-lang/libc` maintainer recently
opened up for `time_t` matters. I was pinged because of my work on this area,
and added commentary on how Qualcomm's Hexagon and Haiku handle this.

In terms of side-project work, yesterday I mentioned I would be looking into
Idris as a replacement for my choice of ML languages. The project I had
attempted tackling in the last few weeks was fine; I just wanted purity.

Idris offered this and dependent typing on top of that. From what I have read of
the documentation, the direct manipulation of types in what ML languages would
consider type equations is beautiful. It feels even better than using GADTs.

I have thus far only been going through the installation of Idris' most popular
package and toolchain manager. I gave up on system package management through
`homebrew` a few days ago, so I have had to build a few libraries from source.

For now, I have had great success in compiling GMP and Chez Scheme. Prior
requirements for GNU coreutils seemed unnecessary on my system, so I hope to
avoid installing those.

I also decided to profit this chance and install some other libraries and tools
I needed for recovering some speed in my workflow ever since I stopped using a
number of tools.

= Blockers
None.

= Plan for the week
The `rust-lang/libc` work is done. I can now choose to either follow up on the
`siginfo_t` PR with another patchset that removes the skips in the build script,
or continue working on the `ctest` extension for modules. We shall see.

In terms of side-project work, I expect to have a fully functioning Idris
compiler by early tomorrow. With that, I should be capable of working through
the documentation's crash course and the community tutorial.
