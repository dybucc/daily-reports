#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-16)])

#title()

= Summary
Today work has focused mostly on `ctest` stuff; I unexpectedly had to solve an
issue with my editor and that consumed a lot of time. I also worked some on
getting the diagnostic work on the Idris side of things.

The `ctest` extension progresses nicely. Today I have further simplified the
second core algorithm. This one ensured I collected a list of
```rust FfiItems``` wrapped in a sum type for resolved or unresolved reexports.

Until today, I had attempted to think harder about the case in which the import
statement is a grouped import. But I failed to realize that this is still a
fairly simple case that does not require much more thought.

Recursing anew in an auxiliary algorithm, while appending the lists resulting
from each element of the group gets the job done. Granted, I have yet to
implement it, but I believe the idea is not flawed, and is fairly simple.

Beyond that, I think the second core algorithm is finished. Its task was to scan
a given reexport, and yield a list of one of resolved or unresolved imports. The
former contain another ```rust FfiItems``` with the resolved items.

In terms of side-project work, I could not do much today. I tried to debug an
issue with my editor that seemed unrelated the the recent integrations I was
building for Idris diagnostics.

As it turns out, there is a bug in the way certain buffer-restoring events
triggered on a restart are handled. I tried to further diagnose the core issue
by cloning and looking into the codebase.

Unfortunately, I could not get too far. The build requirements are a bother to
meet without a package manager. I tried, but I decided it was not worth it to
look any further. I have a manual workaround, so that will have to do.

What little work I got done in the Idris diagnostics side had me further
refining the parsing logic for diagnostics. There is not much to say here. I
have not finished it, so I will put these efforts on halt.

= Blockers
None.

= Plan for the week
As planned yesterday, I finished the second core algorithm plan today. I will
now switch back to working on the first. I will probably have to design some
data structure to hold state for the former's result and the latter's passes.

In terms of side-project work, tomorrow I will go back to working my way through
the Idris crash course. I could not finish the editor integration work today, so
I will probably come back to that at some point in the coming weeks.
