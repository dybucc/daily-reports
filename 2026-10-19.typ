#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-19)])

#title()

= Summary
Today work has focused on two things; The `ctest` extension work has resumed
with renewed energies and new ideas. The Lean study work has started and the
same problem as proposed in Idris the last few days has been solved.

The `ctest` extension work started with me going through the notes I took last
week. That turned out to be a fairly good idea, because jumping straight on to
the implementation would have turned out badly.

I started taking more notes and this time illustrating those with example graphs
of the crate module trees and the associated reexports. This helped me out in
realizing where the main flaws were in my reasoning from last week.

All in all, the logic is the same, but there are a few things I had to tweak.
Chiefly, the strategy was a bit too complex when it came to handling codata.
Recall this consisted of potentially non-terminating cyclic `use` declarations.

This turned out to be simpler to solve than I had originally thought. Any `use`
declaration that is super-relative can be safely assumed to require removal of
the module where it is sourced from once the ancestor module is fetched.

In other words, once we go through all `super` segments in the `use`
declaration's path, we can safely search the module where the `use` declaration
appeared at in the resulting subtree, remove it, and then yield the subtree.

This way, we avoid the whole business with some module living nested within
itself but containig a potentially less up-to-date copy of the module tree. This
new solution seemed to me to be a bit too simple, so I've been testing it out.

Work on the Lean stuff has gone quite smoothly. I've already got a hold of
enough stuff to solve the same problem as I was writing a blog post for Idris.
It's also been great to know that Lean also supports tacit programming.

I have not yet gone through the entire book I was reading, but that's fine. I
started it yesterday, and until now it's been fairly good. Most stuff I expected
to find in the Prelude is actually in the CSLib and MathLib libraries.

It's also been great fun to discover that Lean supports operator sections, akin
to those of Haskell or Idris. The unfortunate difference is that you need to be
explicit about the missing argument with a Unicode dot.

= Blockers
None.

= Plan for the week
I expect the `ctest` work to continue some more without any implementation
efforts. I would really like to finish up reasoning through it, because I don't
want to go through a fourth revision too soon.

The Lean work will continue as today. I have heard of this publishing platform
coded in Lean for producing something that could be considered literate Lean,
called Verso. It seems like a good choice to rewrite the Idris blog post in.
