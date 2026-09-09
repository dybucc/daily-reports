#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-09)])

#title()

= Summary
Today work has focused on continuing to review GitHub notifications on
rust-lang/libc, and on working through some more of the _SML for the working
programmer_ book.

I started off by looking through a bunch of PRs and issues I was mentioned in.
I'm still not done with all of them, but the list has gone down to 4 pending
notifications.

Among those I did get to address today, I've finished revising the PR that
implemented support for the `exhaustive` attribute, commented with feedback of
my own on another contributor's PR, and rebased the uClibc PR for LFS support.

The latter I've done twice since last week even though there was no explicit
feedback. This is because the one target maintainer that did comment on the PR
thread mentioned they'd be looking into it this week, and there were conflicts.

The PR I provided feedback on was one concerned with removing `sighandler_t` as
an alias on platforms that do not use glibc as their environment. I commented on
two things; Moving stuff over to the `new` module and looking at Windows.

The patchset moved around a bunch of definitions and FFI symbol bindings, which
seemed to me like we could altogether move into `new`. Then I remembered that
there is one target using glibc that was not considered; MinGW.

In terms of compiler work, today I've only continued working through the SML
book I picked up yesterday. I am increasingly doubting whether I should continue
working with any ML language, as I have recently also looked into Idris.

I have also spent some time looking into another browser with a fairly strong
anti-AI stance, but had no chance of finding one. The closest thing is Waterfox,
which is sort of there; I've switched to it because Safari is too painful.

= Blockers
None.

= Plan for the week
The rust-lang/libc work on the ctest extension will resume once I have finished
looking through the PRs I got feedback on. Only the general `time64` `cfg`
patchset and the MCP implementation remain; I should be done tomorrow.

I was also pinged on a tracking issue for platforms where we may still want to
make changes concerning `time64`, just to check whether I think something is
missing. That I've yet to go through.

Another PR I've yet to open as follow-up for completing the `siginfo_t` type
definition across targets is to change the skips in the build script. This is
still pending.

Compiler work will likely be put on halt temporarily. I want to explore the
Idris documentation, and see into both using it for the compiler and properly
learning a proof assistant. It is pure and theorem-oriented, so that's a plus.
