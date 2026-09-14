#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-14)])

#title()

= Summary
Today work has focused solely one thing; Working my way through more of the
implementation plan for the `ctest` extension. I have not spent any time doing
anything else because I did not have an Internet connection available.

I have gone through multiple revisions of the draft I briefly explained
yesterday. I will explain the current version. At present, the algorithm is
divided in two core algorithms, and two ancilliary algorithms.

The first two core algorithms are in charge of resolving the final set of items
present in each module after resolving reexports, and of resolving to a specific
list of ```rust FfiItems``` given a glob reexport.

The first core algorithm is the meat of it all. It is a fairly simple iterative
muncher that goes through all modules in a given ```rust FfiItems```. It
individually resolves each set of reexports in a given module.

To that extent, it does not allow modification of nested modules as a
side-effect of its recursive traversal of descendant modules. Each module gets
considered individually at a time, and reexports are resolved iff present.

Upon the first core algorithm finding a reexport in the current module, it
proceeds to call into the first ancilliary algorithm. This algorithm is another
recursive muncher that determines the type of reexport.

The first ancilliary algorithm munches on a given path in a ```rust use```
statement, and determines whether it refers to a glob import or a fine-grained
import. This algorithm uses the second ancilliary algorithm.

The second ancilliary algorithm is used to disambiguate a list folding operation
we perform in the first ancilliary algorithm. In the case of a path with a
group, the former needs to determine whether any one element is a glob.

The decision to divide functionality between reexports that are glob reexports
and reexports that refer to a specific set of items is due to the potentially
recursive and more expensive nature of the former. This needs more thought.

Back in the first core algorithm, we proceed to run the second core algorithm if
the type of the reexport is a glob reexport. I have yet to think through the
fine-grained case.

The second core algorithm performs a similar operation to the first ancilliary
algorithm. It also matches against the type of import statement. I have yet to
think through the specifics, but it should run with two pieces of state.

It should recursively match against the leftmost component of the input import.
Then it should determine whether it should run anew with the rest of the import.
In such case, it should run with the ```rust FfiItems``` of the parent module.

That ```rust FfiItems``` is sourced from the children modules of the current
```rust FfiItems``` we have as state. If it does not contain a child module
matching that rhs of the import, it should return an _unresolved_ reexport.

If it can eventually resolve the whole reexport, it should return a _resolved_
reexport. Back at the first core algorithm, we continue moving through all
modules until we are done with all of them (recursively.)

Then another algorithm should diff the state of the ```rust FfiItems``` the
former produced with the prior ```rust FfiItems```. If this pass has added more
information, but _unresolved_ reexports remain, we should run the former again.

Then the algorithm would terminate once the diffing yields no differences among
the prior and newer ```rust FfiItems```. The idea is a bit like the Bellman-Ford
algorithm for graphs.

= Blockers
None.

= Plan for the week
I expect tomorrow to also be dedicated to solving newer issues I come up with as
I think through more of the implementation plan. I believe the current approach
is decent, but I could very well find something wrong in it.

I expect to start working on an actual code implementation by the end of the
week.

In terms of side-project work, I have done nothing. This is because I have not
had an Internet connection available to me today. The only thing I could do
locally was to continue the `ctest` work. I hope to resolve that soon.
