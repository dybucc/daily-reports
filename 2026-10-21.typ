#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-21)])

#title()

= Summary
Today work has focused on the same two things as yesterday; The `ctest`
extension stuff, and working through the problems in the Lean book. The latter
has been fairly slow today because of one problem that took longer to solve.

The `ctest` extension work consisted of continuing the implementation efforts
started yesterday. These are currently targetting the subset of functionality I
know to to work rather than the codata pattern recognition.

There's been a few additions beyond what I originally planned for. Yesterday, I
had left it at the point where some of the refactoring was done, but there was
still need for more refactoring. Today, that is almost completely finished.

Implementation efforts have focused on having the renaming logic change from
being type-specific to being abstracted through an interface. The interface
ensures there's a single renaming entry point for all types.

This is because after adding the aggregate list of paths, I ended up having way
too many stuff to update alongside an item's path. There's the string caches for
the identifier and paths, the path itself, and the addressable paths now.

Of course, modules have special needs when it comes to renaming because they
ought have the subtrees rooted at them also be renamed. That we already had a
utility function for, so it's been mostly reused.

I say "mostly" here because, unlike the prior implementation, this one also
takes into account the path aggregate that all items now have. Recall that this
was used to keep track of all of the paths by which an item may be referred to.

This list of paths is an append-only store that I will eventually get to using
in the merging function. That's the one point where we can perform a form of
path synchronization, where all such paths are looked up and filled in.

If some item in the crate's module tree is found to have some such matching
path, then we know for sure that that item must have, by the end of a resolution
pass, the same set of aggregate paths as the item from which we sourced it.

That remains to be implemented because I also had to refactor the filtering
logic. This remains exactly as explained yesterday, but this time it's actually
implemented. Halfway through that, I also found a bug.

Both revisions of the algorithm had forgotten to take into consideration the
visibility of `use` declarations. Such visibility determines the imported
item(s)' visibility, and that's important to the global skip for private items.

In terms of Lean work, today has been a slow but rewarding day. The same problem
I had clocked out on yesterday has been my sole object of study today. It is a
fairly beautiful tacit solution to the list zipping problem.

The main roadblock wasn't that the problem itself was hard. The tacit solution
doesn't take that much longer to come up with than a regular recursive
traversal. The issue came from my lacking understanding of Lean's API.

Apparently, Lean's `foldr` and `foldl` do not have the same meaning as, say,
Haskell's or Idris'. In the latter languages, `foldr` means fold towards the
right rather than fold from the right. In Lean, it means fold from the right.

Then it crossed my mind that I had read something in the documentation that
spoke about the direction of the fold. I guess this taught me not to trust my
Idris knowledge too much when it comes to the subtleties of std.

= Blockers
None.

= Plan for the week
The `ctest` extension work will continue tomorrow. That is likely not to be
finished by Friday, and that also means the failing test case will not be
finished by then either. Still, all of the refactoring was actually necessary.

The Lean work will continue as it has until now. More point-free solutions will
be devised for as many end-of-chapter problems as the book proposes. Though I'm
aching for the theorem proving problems.
