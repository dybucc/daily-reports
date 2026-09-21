#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-21)])

#title()

= Summary
Today work has focused on one thing again; Working through the rest of the demo
for the algorithm to resolve modules, as part of the `ctest` extension work. The
initial version of the algorithm is officially complete; Testing has started.

I started off by setting up some timelines for the rest of the week. I wanted to
finish up working on the Idris demo before the weekend, so that I could port it
over to Rust throughout the weekend.

With this in mind, and knowing I said yesterday that I would switch to working
on the driver algorithm by Wednesday, I continued solving some last
type-checking issues. These I got over with quite easily.

The only remaining type-checking issue from yesterday turned out to be quite
easily solved, though I didn't quite grasp the reason why the type checker
complained in the first place.

Basically, the single-module resolution algorithm takes a dependent pair of a
module and proof that the module's ```rust use```-trees are group-clean. This
proof is produced by the normalization function that I finished yesterday.

Apparently, though, there are some funny details to the use of elements of a
dependent pair in a canonical coproduct with two injections. I had a type that
wrapped either one of a module or an item (repesented as a string in the demo.)

This type I used to easily unify the result of performing a lookup on a module
when I found a name as the tail end of a ```rust use```-tree's path. But for
reasons I do not yet comprehend, a straightforward coproduct is not enough.

A coproduct is a sum type; A "canonical" coproduct is a sum type with only two
variants (its injections.) The type I used was only a utility type, but the type
checker complained about its multiplicity when interacting with the input pair.

The multiplicity of values in an Idris program is related to the quantity that
is assigned to a given type or type variable. This quantity determines whether
it can be used at compile-time, only once at run-time, or is unrestricted.

I recall Rust's borrow-checker being a more convenient skin over this same
concept of linear types. But the Idris compiler didn't provide more information
beyond the type-checking error. So I tried to get rid of my custom type.

Instead, I used the canonical type all Haskellers know to be the coproduct of
the category of types; `Either`. This type is generic over two injections, but
most importantly, it is not part of my code.

Not being part of my code, and knowing that the Idris compiler surely would not
complain about a type in its standard library, I replaced my coproduct with
`Either`. Lo and behold; The type checking issues went away.

I tried to read through the `Either` source in the Idris prelude library, but
found that none of the differences with my type should have lead the compiler to
complain about my coproduct.

`Either` has no special meaning to the Idris compiler (in Rust lingo, it's not a
`lang` item.) It does use explicit universal quantification in both of its type
variables, but there's nothing special in that.

Being explicit about such quantification in a type expression that uses the
applicative operator is the same as being implicit. Maybe the issue is that my
type was not generic; But I do not think concrete injections cause these issues.

After deciding against going down this rabbit hole and letting experience with
the Idris compiler do its magic, I moved on to the next thing. Having solved all
type-checking issues, the only thing that remained was the driver.

The algorithm as I conceived it until this moment needed another function that
would manually trigger the passes until the result of some pass diffed
equivalent to the result of the pre-pass module tree.

To avoid trying to go head on and potentially finding out I was wrong in my
reasoning, I decided to take some notes first on this. I first inspected my
curerent single-pass algorithm and noticed something odd.

The pass is performed on the entire module tree at once; It does not attempt to
resolve the reexports in one module, to then move on to another module. This
meant that the pass could potentially lose the chance to seize new information.

Let me elaborate. The pass system goes bottom-up from leaf modules back up to
the root module comprising the crate root. Node modules are those that have at
least one child module, and leaf modules are those that don't have any.

Now, when I started out thinking about the whole module resolution algorith, I
decided to ignore the possibility for reexports to include items from parent
modules (by prepending ```rust super``` to the ```rust use``` statement.)

This I continue to assume, but even with this, there is a pathological case when
a node module refers to a reexport introduced by one of its grandchildren, and
this reexport appears before the reexport introducing its children's items.

If on top of that you stack that the first reexport uses directly the item
reexported from two levels below, you find that resolving at the grandparent
level the reexport for the child loses the future chance to resolve the former.

If you keep a snapshot of the child after the child itself has not yet resolved
its own child's items as reexports, the top-level module will never get the
items from its grandchild (going through its child.)

I first had an idea to delay the export resolution if the module a name or glob
referred itself still had an unresolved reexport left. This would allow
subsequent passes on the children to resolve before reaching the parent.

The issue with this is that I conceived the algorithm as accepting a module
post-resolution if it was unchanged from its pre-resolution state. This was so I
could allow reexports from third party crates that I have no info to resolve.

The problem with the above idea is that it changes the requirements of the
algorithm to only start resolving once the a child module is free of unresolved
reexports. This conflicts with the idea of third-party crates and their imports.

So I went back to my original idea, but decided to make the pass system work on
a single module at a time instead of on the whole module tree. A full resolution
step (i.e. multi-passes and merging) would now be made one module at a time.

This turned out to do the trick. I've already run out of time for today's
report-writing time, so I will not explain further. The code is available in the
PR. Then I started testing and found everything to work.

= Blockers
None.

= Plan for the week
The tests I ran today seemed to work just fine. I will continue running tests
tomorrow, but base them off of existing tests in `ctest`. The painful part here
is that I have to build the parse trees by hand.

I have considered building a small parser for tests, but I don't think it's
worth it just yet. I would like to prepare a write-up to serve as an update to
the PR status, and possibly ask for feedback.
