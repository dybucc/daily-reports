#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-19)])

= Summary
Today work has focused solely on one thing; Proving a property of the demo
program for the `ctest` module extension. This has melded both of my current
endeavors, though today I have focused on the Idris side of things.

The algorithm as explained yesterday has been left unmodified, for the most
part. I first solves a few minor issues with the totality checker in Idris. This
is a system to ensure types are terminating and defined for all their domain.

The one issue to highlight here was asserting the totality of the normalization
function. As commented yesterday, this new auxilliary function ensures we only
ever handle reexports that do not contain grouped reexports nested within them.

The totality checker was complaining about there being no clear termination path
when type-checking the function. Indeed, ```rust use```-trees containing grouped
imports are structured as lists of ```rust use```-trees.

To the totality checker, this implies there is no known shape to the data
structure of ```rust use```-trees that contain groups. Each of the containing
groups could exist on its own and potentially be assumed to be "longer."

This idea of there being shapes in data that lead to a notion of larger and
smaller data structures is what trips up totality. I know that parsing a set of
reexports contained in a group will not yield a tail path that is longer.

It would be a contradiction to say that the tail of a reexport is larger than
the sum of the tail and the head of the path in the reexport. This is the idea
that I intended on encoding in the type, but I decided against.

To keep things simple to port to Rust, I decided it would be best to instead set
up concerted calls to totality asserting functinos. These are a bit like
```rust unsafe``` in Rust, but allow more fine-grained control.

The next big challenge that took the rest of the day was related to proving that
the set of imports post-normalization truly cannot find a match against a group
import. This I had decided against doing in the initial implementation.

With the algorithm complete before time, I thought it would be best to try and
get rid of the partially-defined functions and at least make them covering. I
first started off by designing a type that would serve as proof witness.

The witness type here is one that takes a ```rust use```-tree and considers in
its constructors only a limited set of the tree's constructors. In Idris, you
can match at the data level in certain type expressions.

This type has constructors for the other three variants of the tree that do not
make up a group import. Then each constructor is said to yield this witness by
specifying that the tree ought have been constructed with a specific variant.

For the case of glob and name imports, this is trivial. For the case of path
imports, some more thought is required. Firstly, paths consist of a head and
tail, where the tail is itself another ```rust use```-tree.

This tree must also be held against the witness type, so we need to constrain it
by making the witness type inductive. I read some through the Idris reference,
and found that they have some nice utilities to do just this.

Basically, a path witness first takes an implicit, proof-searched parameter that
indexes anew the witness and is used in the type that this constructor
represents when refining the way the tree is expected to be constructed.

An implicit parameter is one that need not appear at call site. It is
proof-searched because you delegate the responsibility of ensuring the path's
tail neither contains groups to the type-checker.

The type-checker then performs a limited recursive traversal through the shape
of the implicit argument serving as nested witness, and ensures at compile-time
that the top-level path witness has a tail that the witness can also validate.

After finishing this, I then went on to slightly change the implementation of
the normalization function. I now need to also produce another witness type that
depends on the resulting module (without reexports.)

This means that the normalization function now returns a sigma type (or
dependent pair) that consists of the now group-reexport-clean module, and of a
witness that this module is, indeed, clean of group imports.

This other witness type is basically a wrapper for the previoulsy explained
witness for a single ```rust use```-tree. It generalizes the proof to apply to a
list of trees instead of just a single tree, contained in the module.

Then we just sprinkle that dependent pair in most call sites post-normalization,
so as to ensure the type-checker knows for sure that there is no way to match
against a group import, and call it a day.

= Blockers
None.

= Plan for the week
The algorithm is mostly done. Granted, the driver algorithm I have not even
spent a second of today thinking about. Because I am mixing Idris and `ctest`
stuff, I wanted to not only just discard stuff for the sake of porting to Rust.

This prompted to today's work, and I think I will continue solving some
remaining holes in my understanding of the problem tomorrow. The proof is not
complete, but I think about 80% of it is actually correct.
