#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-20)])

#title()

= Summary
Today work has focused on two things; Chief among them has been the `ctest`
extension work on the module resolution algorithm. I've also sinked deeper into
Lean programming and have almost finished all sections of the current chapter.

The `ctest` extension work started with me working through some of the details
of the new strategies I had come up to solve the shortcomings of the second
revision. A few notes later, I ended up with two things I could implement.

The first one of them is the expansion of all parsed types' fields to support
keeping track of a list of "addressable" paths. This was already commented on
last week's last report, where I mentioned this was fairly criticial.

Thus far, all parsed items had kept track only of their source path. This then
changed in each copy of the item that got imported to another module. But the
skipping system would only end up skipping one appearance of the item.

There was need to "connect" the same item across different subtrees of the
module tree. The solution I ended up going for uses a list of possible paths,
which is always at least of length 1, and expands on each import.

This way, if an item appears in some module $a$, and then gets imported to some
module $b$, we don't just rename it. The item in module $a$ and its copy in
module $b$ keep their paths and add the "dual" path to their list of addressable
paths.

Then the skipping logic needs some modification. Instead of running each closure
the users have set up on the parsed items, we have to run each closure on each
"variation" of the parsed item (the variation really only being the path.)

The goal is to know for sure whether the closure used any one of the paths with
which an item may be referred to by to set up a skip for it. Granted, this is a
bit of a combinatorial explosion with enough reexports, but it works for now.

The second thing I concluded could be implemented is a modification in the way
we process `super`-relative `use` declarations. Thus far, we had munched on a
single `super` segment of the path by fetching the parent module.

This is not quite enough. See, by the time all leading `super` segments are
removed, we are left with some ancestor module that still contains the module
where the `use` declaration was sourced at within its subtree.

If the `use` declaration then doesn't descend into some other branch or deeper
into the branch of that source module, we end up with the same module nested
within the subtree rooted at that same module.

This I had thought about for a bit yesterday and decided it would be best
avoided rather than solved. The solution is to eagerly munch through all leading
`super` segments, and cleanse the ancestor of occurrences of the source module.

I've started implementing the path list expansion and refactoring both the
parsing logic and the filtering logic, but that is not yet finished.

In terms of Lean work, I've had great success in solving a bunch more problems.
Of course, I always go for tacit solutions, but sometimes that just doesn't seem
possible; Chief among these is a Functor's map implementation on some sum type.

Still, it seems like given at least a Foldable's type class implementation, you
are pretty much set up for continuous tacit solutions. In product types, these
are always possible, but sum types seem to require some base infrastructure.

There are a few things that seem downright strange in Lean, though. For some
reason, they diverge from the more traditional approach of using explicit type
classes for stuff like semigroups and monoids.

= Blockers
None.

= Plan for the week
The `ctest` extension work will continue tomorrow. The algorithm is unlikely to
be finished by the end of the week, but I do strive to at least have fixed the
failing test case I discovered last week and have been working on ever since.

The Lean work will continue as today. I've also discovered some niceties in
their standard library that are often named as combinators (from "To Mock a
Mockingbird",) but Lean's API docs are honestly hard to grok.
