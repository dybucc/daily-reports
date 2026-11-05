#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-11-04)])

#title()

= Summary
Today work has focused on two things; The `ctest` extension matters and the Lean
book. The issue that had been bugging me for the last two days has been fixed,
as well as a bunch of other bugs in the path aggregate synchronization logic.

The `ctest` extension matters have progressed nicely but there are still new
issues I've found as I was printf-debugging the code. The details I will leave
to the PR to explain itself because I barely remember them as I write this.

At present, I'm trying to solve another bug that duplicates the paths of a given
item in its aggregate after some yet undetermined number of times of it having
been imported into another module.

This I am reluctant to continue solving because it crossed my mind towards the
end of the day that I could potentially replace the path aggregate system with
something considerably simpler, at a potential cost in time complexity.

See, the idea I had with path aggregates is that they would serve as a quick way
of testing the same item against a given skip set up by downstream users. If one
occurrence of an item is meant to be skipped, all occurrences are skipped.

To this extent, I implemented and have been debugging the synchronization
mechanism for getting all occurrences of a given item to keep the same path
aggregate across resolution passes.

But what if I simply assigned to each item a unique ID at parse-time and called
it until filter-time? Then, with access to the whole-crate module tree, I would
perform one sweeping traversal to fetch all items with the same UID.

Of course, this comes with both potential savings in space complexity, for it
doesn't grow as more imports cause items to have more occurrences, and a
potential cost in time complexity from repeated whole-crate tree traversals.

Still, I have already thought up a plan to replace all of the path aggregate
machinery. My aim is far from being that of performance, and this alternative
solution seems far simpler than the one I was going for.

I will likely end up implementing a state monad that carries state and hides the
mutable bits of `syn`'s visitor interface. This will then let me keep track, in
a pure way, of the unique IDs that are assigned to each item.

Lean-wise, things have gone fairly well. I've gotten through a lenghty but
really interesting use of monads for sequencing pure, but verbose, computations.
I've also started the problems in that section, though I'm yet to finish them.

= Blockers
None.

= Plan for the week
I expect to start working on the alternative solution to the path aggregate idea
tomorrow. I am most likely to throw out of the window a crap ton code, but that
is the best feeling ever when the alternative is simpler than what you had.

The state monad should also allow me to get rid of some additional state that I
had added to the item container type but that was only used at parse-time.

Lean-wise, work will continue on solving the problems. This time they're not
quite challenging, but they do require a fair bit of equational reasoning to
prove laws of monad examples presented in the chapter.
