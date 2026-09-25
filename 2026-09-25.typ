#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-25)])

#title()

= Summary
Today work has focused on two things; Starting to implement the Rust port for
the algorithm PoC I have been working on to extend `ctest` with module support,
and continuing ongoing work on the second revision of the algorithm.

The first thing that I started off doing was to continue work on the proof for
the next revision of the algorithm, which as commented in the last few days,
supports bidirectional imports (i.e. ```rust super```-prepended imports.)

I continued yesterday's efforts to implement the path comparison logic used in
an auxiliary function for single-reexport resolution function. This function
ensures we can find the parent module to some other module.

The details of that and the associated properties I could prove are included in
yesterday's report. This time I tried to finish the proof that if two vectors
have the same length, then surely they must be ```idris Eq```-comparable.

But this does not seem possible in the Idris type system, as ```idris Eq```
always forces comparison with a vector whose length is given by the same type
variable or otherwise the same overloaded natural literal.

So instead I went for a simpler approach that tackles the problem by performing
manual comparison of the vectors like one would do with lists. This turned out
pretty well, and TIL I should not look for proofs where they are not needed.

Then I found a flaw in the algorithm because the path comparison logic to find
the parent module was considering the tail of the path, which does not make up a
coherent path itself. The lefmost element of the list and the path are the same.

This means destructuring such head leaves a non-sensical path that would never
be found in the module tree. This I fixed quite easily through the same idea I
explained two days ago; Reverse-trim-reverse to get the right parent path.

Then I also refactored the type that I used for yielding resolved modules and
sets of items from reexports that I could resolve in a given pass. This I did
because yesterday I also changed the representation of modules.

Now they're indexed by a natural that gives their depth in the tree, and allows
nice proofs. But this causes some type inference issues when producing a virtual
module that contains only items and no path. It requires a depth but it needn't.

The solution was to refactor the resolution type into having a dedicated
container for modules that are resolved, such that we hold no dependency with
the dependent parameter of the module type constructor (its natural index.)

Then I moved on to the merging function, which also needed fixing after
yesterday's refactor. This function takes a module and a set of items or
modules, and merges the latter into the former.

With the natural indexing the modules to give their depth, this needs a
transformation of the modules to be merged, such that they have their indices
indicate that they are now children of the module to merge into.

And yet these modules (being the result of resolving a reexport) are sourced
from an unknown point in the module tree. We could track this, but I thought of
a simpler solution; Rewrite the modules with the new depth information.

The depth of the modules to merge cannot change as there is an associated proof
that ties the depth of its own child modules to be the successor natural to the
natural indexinxg the parent module.

But we can instead take the path of the module into which to merge, build up a
path that would correspond with its child module from each module to be merged,
and recurse doing the same thing for the children of the latter.

This basically rebuilds the whole subtree rooted at each module to be merged to
have a clearly defined parent in the module into which to merge.

On the Rust side of things, I have started working on the port of the initial
version of the algorithm. I decided against porting the current WIP revision
that supports ```rust super```-prepended imports because that is still
unfinished.

Today I got to implement parsing support for ```rust use``` statements, and the
normalization function for flattenning groups in ```rust use``` trees into
individual ```rust use``` trees. I also thought about some of the details of the
resolution algorithm.

The parsing part was a pre-requisite that I did not even plan for because I
assumed it would not be too hard to implement. That was true, though for a
moment I thought it would become a major challenge.

`syn`'s visitor interface has a hook for ```rust use``` statements, but this
hook gets called even when the ```rust use``` statement is inside a
non-module-level scope (e.g. a function scope.) This is no good, and I thought
all hope was lost for a few seconds.

But then I realized that we can just use the existing hook for modules, and
recurse through the list of items in an inlined module, filtering through
anything that is not a ```rust use``` statement.

This I then paired up with a normalization function that does exactly what I
implemented in the Idris PoC; Take the containing ```rust use``` tree, and
flatten the groups into individual ```rust use``` trees that get rebuilt into
separate ```rust use``` statements.

The normalization function was originally part of the resolution algorithm in my
Idris PoC, but I realized I could just get it out of the way during parsing. The
information is there, and the logic was just as simple to implement.

= Blockers
None.

= Plan for the week
I expect to have finished working through the Idris PoC revision by Sunday. This
is a strict deadline, so even if I have not, I will go back to reading through
the Idris tutorial by Monday. The Rust port I can allow some more time for.

From what I have devised thus far of the port, I do not think it will be too
hard to get everything moved over to the `ctest` codebase. I could even finish
by the soft-limit I set of Sunday; But I will allow two more days as hard cap.
