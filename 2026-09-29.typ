#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-29)])

#title()

= Summary
Today work has focused on two things; Testing out edge cases and counterexamples
for the Rust port of the module resolution algorithm (as part of the ctest
extension,) and continuing ongoing work on the Idris proofs about vector splits.

In terms of Rust work, the day has been spent as planned yesterday; A bunch of
test cases were thought up to try and prove incorrect the algorithm. A few bugs
were found, and one lacking area was also found.

Before all of that, a refactor of the identifier used for the stringified cache
of the path to all parsed items was done. This really only meant that the one
field from each type was changed from the previously misleading ident.

During testing, the path normalization proposition proved to be correct under
all input samples. While testing out a basic example requiring path resolution,
it was found that each item's cache (the one mentioned above) was not updated.

Basically, during merging and in the rename case of the proposition handling
single-use-statement resolution, the paths to items ought be updated. This was
happenning as expected, but the stringified cache was not being updated.

This was fairly simple to fix; The initial proof of the path manipulation
proposition only ensured this happened with modules. Fixing this also lead to
refactoring the merging proposition to be more concise.

In essence, this meant that the proof previously performed a first manual pass
over the item container to be merged, and then handed off the same work for each
nested module to merge to the path manipulation proposition.

This was unnecessary because the operations performed on both the closure passed
to the latter and those used for each top-level item were equivalent. This was
refactored by using the path manipulation proposition from the get go.

This did need wrapping the item container in a module of its own, as path
manipulation recursively operates on modules. Then a more complex example of
use-statement resolution requiring multiple passes was devised.

This lead to finding yet another bug with path rewriting; This happened to be
related to the fact paths were having all of their segments removed from them
except the trailing segment, even when they should preserve some of them.

The behavior was correct with top-level items because those should really only
preserve their identifiers. But nested modules to be merged and the items rooted
on them need to keep the path starting on that nested module.

This almost meant that the conciseness gained by the above refactor of the
merging routine would be lost. Thankfully, a better idea was found; The
top-level items would be wrapped in a module without nested modules.

This then allows use of the path manipulation function without ever recursing
through nested modules, and while keeping the existing closure for modifying
paths. The modules then get separate treatment.

The solution for the paths of items under nested modules to be merged went
through keeping the identifier of the module cached outside the closure, and
looked up in the paths of the items passed through the closure.

Then these paths get trimmed of all leading components until hitting this module
identifier, and the rest is appended to the path of the module into which to
merge to produce the updated item path.

This is all possible without much error handling nor impossible cases that panic
thanks to the fact we're mostly throwing around vectors as monoids. Them having
a neutral element makes for assumptions that you can "trust."

In terms of Idris proof work, today there has been progress in the proof for
conversion between finite sets and naturals. It would seem the explanation given
yesterday about finite sets and the topology of the ADT is partly wrong.

Finite sets are not a one-to-one representation of a Peano number (naturals in
Idris.) A finite set with some bound $n$ may be built in multiple different
ways; The zeroth element alone already represents a non-zero-bounded finite set.

The nifty thing about finite sets as conceived in Idris is that the bounds they
impose act on construction of the possible values a finite set represents. A
bound gives a target natural; The construction will always hit that target.

Whether the construction itself represents one or another element of the set is
irrelevant and not part of the type but of its constructors. The constructors
do, indeed, act like naturals.

It can even be said that these constructors are the "naturals of finite sets."
Constructors that replicate naturals but represent finite sets (as GADTS.) The
finite set a given constructor represents depends not of the overarching index.

With that finally understood, conversion became trivial to prove, so efforts
were instead centered around a proof for integer to natural conversions. It
seems Idris only provides propositions with little to no guarantees about this.

For starters, it rounds negative integer literals to the zeroth natural. Then it
has not way of proving that the returned natural, indeed, maps to the integer
fed into the proposition.

The former proof for non-zero integers can be easily elaborated by adding an
auto-implcit (proof-searched) boolean predicate lifted to the type-level. The
latter is still a WIP, and will need more work. A summary follows.

Ensuring that an arbitrary integer maps to the "right" natural requries there
existing a map of integers to naturals. Providing proof of that requires a type
that understands the relations between each element of the map.

In other words, the proof for this is inductive, and considers as the inductive
hypothesis the vacuously true case that integer 0 maps to natural zero.

Then it builds upon that to say that the successor to those are also part of the
map so long as there exists some map for an arbitrary integer and natural. This
is then packed up as a dependent pair in the integer to natural proposition.

The issue at present is in finding a better proof that the input integer is
non-zero, such that one may confidently match on the integer with a literal or a
bound data variable, and know that it will always be greater than or equal to 0.

= Blockers
None.

= Plan for the week
The Rust port had a hard cap set for today. Testing has revealed a few bugs that
have already been fixed. There is yet another "bug" that even though less
serious, has not yet been fixed; Item deduplication between passes.

The Rust port work will temporarily halt tomorrow; Work will then focus on
setting up some CI for the uClibc PR. That one recently received feedback from
the target maintainer, and that was their long term recommendation.
