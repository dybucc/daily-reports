#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-25)])

#title()

= Summary
Today work has focused on two things and tad bit of a third thing. I have worked
a bit on the Lean side of things, but quickly started working on something
different also related to Lean. Then I also took notes on a Haskell white paper.

As per the usual, I started off continuing where I left off with the Lean book
I'm working through. Yesterday, I got to the chapter on type classes and
instance search, and today I continued the second section's problems.

Halfway through that, I started looking into the Lean language reference for
more information on type classes. This ended up with me going down a rabbit hole
to attempt to recover structural recursion in the type of a rose tree.

Basically, at one point I found there was an example on the recursive use of
type classes in Lean, which is not really possible. The language reference
explained a bunch of workarounds, and one of those used rose trees.

Without getting too deep into the weeds, a rose tree is essentially a generic
tree. It consists of a node, and an arbitrary-length list of child nodes which
themselves are the roots of a new rose tree.

Well, one of the first implementations that comes to mind and the one used in
the language reference's example, uses an array of child nodes. Yes, an array
even in a functional language is possible with some mutation escape hatch.

The shape of this algebraic data type thus consists of some piece of polymorphic
anciliary data, and the list of of child nodes. To the compiler, this looks like
a data type that, even though recursive in nature, has no recursive structure.

If you decide to define a function that computes the boolean equality of the
above type, you find that there's no straightforward way of communicating
termination. This is because the inner array is a whole other data type.

To better understand this, consider the case of a canonical list inductive type.
It consists of a nil and cons case, where the former serves as induction
hypothesis, and the latter builds on it as the induction proper.

If you then recurse through a list by repeatedly destructuring the non-recursive
polymorphic type in the cons data constructor, termination is possible because
the structure of the tail end of the list is syntactically smaller.

The key idea here is that it is immediately obvious from unfolding the data
constructors of the type repeatedly that the next argument with which the
function is called recursively is structurally smaller than the current one.

The concept around this is known as structural recursion. With our rose tree
data type, unfolding its one data constructor does not yield some nested
instance of itself, for that would also require unfolding the inner array.

For some arbitrary inner type (an array or a sum type) that is polymorphic over
some type (like our rose tree,) it is not in general possible to perform such
unfolding and analysis automatically.

So the Lean language reference just focused on the type class aspect of the
example, and decided to make the function definition partial. This was a
downright "eww, disgusting" moment for me.

So I started thinking about two alternatives. I could either inline the list of
child trees (forgetting about impure arrays,) or I could go down the path of
defining a well-founded relation between the parent and child nodes.

I first tried out the inlining and it ended up working just fine all while
keeping the function total. This did require thinking a bit more about the
revised type, though.

For starters, the type had to stop being a single-constructor inductive type,
and it also had to start being indexed by some term at the type level. Consider
the following code snippet, where the type definition is showcased.

```lean
inductive RoseTreeConstraint : Type where
  | child : RoseTreeConstraint
  | node  : RoseTreeConstraint

open RoseTreeConstraint in
inductive RoseTree (α : Type) : RoseTreeConstraint → Type where
  | node : α → RoseTree α child → RoseTree α node
  | nil  : RoseTree α child
  | cons : RoseTree α node → RoseTree α child → RoseTree α child
```

Notice how our previous data constructor, here `node`, considers the anciliary
data, followed by another rose tree. This other rose tree has to specifically
denote the rose trees formed from the list data constructor.

To this extent, the other two data constructors, which denote the inlined list
constructors, represent a rose tree indexed by the child node constraint. The
`cons` case considers as well a node in the inline list of "child rose trees."

Granted, this is an unfortunate type detail that a consumer of a rose trees
library should not be aware of. That is why I also considered a wrapper, which I
showcase following, alongside the boolean equality type class definition.

```lean
namespace RoseT
inductive RoseTreeConstraint : Type where
  | child : RoseTreeConstraint
  | node  : RoseTreeConstraint

open RoseTreeConstraint in
inductive RoseTree (α : Type) : RoseTreeConstraint → Type where
  | node : α → RoseTree α child → RoseTree α node
  | nil  : RoseTree α child
  | cons : RoseTree α node → RoseTree α child → RoseTree α child

def RoseTree.beq [BEq α] : RoseTree α β → RoseTree α γ → Bool
  | node v1 t1, node v2 t2 => v1 == v2 && beq t1 t2
  | nil       , nil        => true
  | cons t1 c1, cons t2 c2 => beq t1 t2 && beq c1 c2
  | _         , _          => false
end RoseT

abbrev RoseT : Type → Type :=
open RoseT RoseTreeConstraint in flip RoseTree node

instance RoseT.BEq [BEq α] : BEq (RoseT α) := open RoseTree in ⟨beq⟩
```

Today I also worked some on the Hasochism paper about dependent typing in
Haskell, where I took a bunch of notes. I've ran out of time for today's report,
so I won't comment on it just yet.

= Blockers
None.

= Plan for the week
Tomorrow work on the `ctest` extension will resume. The Lean work will continue
as per the usual, though I'll have to find a better way of handling what the
"public API" of the rose tree would like with this alternative solution.

I expect to continue taking notes on the Haskell paper next weekend.
