#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-28)])

#title()

= Summary
Today work has focused on finishing up the Rust port, and working out the brain
through some nice mental gymnastics by yours truly; Idris proofs.

The day started off by taking more notes on the need for renaming functionality.
Last this was mentioned, concerns had been raised about the need for a recursive
path manipulation utility that would rename all items in a module subtree.

Today it was observed that beyond the rename case of the single-reexport
resolution proposition, there was need for this from the merging function.
During merging, the paths of all items to be merged need to change.

These items start becoming children of the module into which to merge. The whole
point of use-statement resolution is to have items accessible from paths other
than those found in their regular source modules.

So a small algorithm for path manipulation was designed, such that the
proposition takes a closure or proposition, and the module representing the root
of the subtree from which all paths ought be modified.

Then a BFS on that tree is done, modifying all item paths found in the module by
running the closure and replacing the path of the item in question. This seemed
like the easiest and yet still flexible solution for both of the above usecases.

Afterwards, the proof for the single-reexport resolution proposition was
completed. The rename case only needed to do some path manipulation on each
item, so as to ensure the segment for the ancestor module got updated.

Then the merging proposition got its proof finished as well. This does exactly
the same thing as the Idris PoC; It filters through the list of resolutions
looking only for resolved items. Then it merges those into a module.

The module is the one where the reexports that resolved to those items live at.
Those reexports get removed, and the paths to the items to merge get almost a
complete overhaul. Only their identifiers remain; The rest is the module's path.

In terms of Idris proof work, today marked the start of the one to possibly two
week period for working through the Idris community tutorial. This has been
fairly simple thus far; The module resolution proofs were considerably harder.

But before progressing anymore, it was decided to instead finish up one problem
that had been left unfinished from two weeks ago. This consisted of a proof for
a vector splitting proposition.

The whole point of vectors in dependent type theory is that they are
length-indexed in their type. This can be exploited to prove properties such as
the length of the resulting vectors from the splitting operation.

Beyond that, stuff like finite sets of naturals are also useful to put an upper
bound with no runtime cost on the natural fed into the spitting propostion. This
has been the central part of today's problem-solving.

Finite sets themselves only serve as type-level wrappers around a data-level
natural that can be pattern-matched in type equations. But just this is enough
to make them indicate that a certain natural, if also indexed, is bounded.

The complicated part comes from overloading integer literals (which are
primitives in Idris and don't tend to have nice proofs) into naturals that
themselves are bounded and converted into finite sets.

This is necessary to allow taking in a natural in, say, the list splitting
function, while actually expecting a finite set. This literal overload can then
be paired up with proof-searched type constraints in its implementation.

To put it concisely; Literal overloading requires implementing an interface for
your type (finite sets,) and this overloading is just another proposition, so it
can have additional type constraints that themselves represent proofs.

These proofs would ensure that if the integer literal gets converted into a
natural, and then the natural is not within the bound indicated by the finite
set, the thing will not even compile.

Granted, this only works so long as the natural is downwards of 100. That is the
limit of proof-search, which even though extensible, is not a good idea to
change. It still works, but the user has to provide a manual proof at call site.

= Blockers
None. I ran out of ink on my pen today and had to finish up taking notes
digitally. This is subpar because writing on a keyboard is faster and allows for
less mental space while externalizing your ideas.

= Plan for the week
The expected timeplan for the Rust port seems to have gone on smoothly. The hard
cap had been set tomorrow. Having finished all proofs today, that means tomorrow
is likely to be a day of testing and potentially debugging.

The Idris proofs will probably continue tomorrow because it is not yet entirely
clear how does one convert a natural to a finite set without chainging the bound
on the finite set itself. Fresher eyes should hopefully yield the answer.
