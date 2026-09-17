#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-17)])

#title()

= Summary
Today work has centered around two things, though most notably only one; I have
further worked my way through the Idris crash course, and have started a draft
implementation of the `ctest` module resolution (in Idris.)

Beyond the above, there is not much else to comment. I will further explain my
current perspective on the module resolution algorith, and will couple that with
my experience attempting to implement it in Idris.

The data structure that I already added to the list of parsed items will need
extending. This one gathered information about modules, and the containing items
within those modules. This is to allow keeping track of imports.

This data structure represents a module, and makes up both the input and output
of the algorithm. The input to the resolution algorithm is a single
```rust FfiItems``` instance, and the output is another such instance.

The function updates each inner module (itself an ```rust FfiItems``` instance
by mapping each over the resolution algorithm anew. Then it composes this field
projection with a merging operation and fine-grained resolution algorithm.

The fine-grained resolution algorithm takes a single ```rust FfiItems``` and
yields a list of resolved items. This list is composed of either one of a
resolved data constructor or an unresolved data constructor.

The resolved constructor takes an ```rust FfiItems```, resulting from resolving
a single reexport. The unresolved data constructor takes itself an import
statement that we could not resolve because context is lacking.

The fine-grained resolution algorithm thus returns a list comprising the result
of appending the lists resulting from resolving each reexport of its input
```rust FfiItems```. This delegates to a function to resolve a single reexport.

The function to resolve a single reexport is implemented in terms of a closure
within the prior algorithm. This is to avoid carrying stateful information on
the path to the original reexport, which is returned when resolution fails.

Reexport resolution remains as explained yesterday; We walk the path of the
import and ensure we can find the tail item in the running state. If found, we
yield a resolved ```rust FffItems``` that gets merged later on.

The case of a single identifier yields a new ```rust FfiItems``` wrapping it.
The case of a glob yields the running state's ```rust FfiItems```. The case of a
grouped import yields the appended lists resulting from each element.

Once merged, the resulting top-level ```rust FfiItems``` carries a differing
number of reexports if there were more than 0. This is because those that
resolve to a concrete item do not get added to the ouptut ```rust FfiItems```.

The merging algorithm I have yet to think through, but I do not expect it to be
too hard to implement. The above infrastructure is not enough to resolve the
whole crate module tree when considering reexports. It needs a driver.

The driver algorithm I have thought some about. As mentioned a few days ago,
this algorithm is a bit like Bellman-Ford's on graphs. That algorithm performs
multiple passes on a graph to gradually find the APSP.

My algorithm needs to perform multiple passes to resolve whichever reexports
were left unresolved. Unlike Bellman-Ford, I do not have a proof of correctness,
so I plan on basing it off of a heuristic.

If after a given pass, the driver finds that the pre-pass ```rust FfiItems``` is
left unmodified from the post-pass instance, we bail out. This also solves the
problem of trying to resolve imports from external crates.

In Idris, this is all quite simple to express. I have avoided attempting to
prove the correctness of any of the algorithms involved, so as to first get a
grasp over how would a solution look like once finished.

One huge help today was to think through the whole thing with pen and paper. In
Rust, doing this is quite hard because there is a lot of noise stemming from
syntax. In Idris, it feels like finally having a unified syntax for thought.

= Blockers
None.

= Plan for the week
I expect the work on the `ctest` module resolution algorithm to continue
throughout next week. I do not think I will have a Rust implementation ready by
then, but I hope to have a working Idris demo done.

In terms of side-project work, today I decided to mix my main two endeavors so
as to get more hands-on practice with Idris. I believe I will continue doing so
until I finish the demo. Then I will go on to work through the Idris tutorial.
