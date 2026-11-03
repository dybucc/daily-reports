#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-11-03)])

#title()

= Summary
Today work has focused on two things; The `ctest` extension matters and the Lean
book. The former has seen a refactor of the code to clean it up for an external
reader, though the issue found yesterday persists.

I started off by reading through the whole resolution strategy again, ensuring
there was no legacy code for old logic that would not work out well with the new
path aggregate synchronization strategy.

This lead to a fairly large clean-up, a few bugfixes I realized I wouldn't have
come up with my current test cases, and something that is overall a tad bit more
readable to an outsider's eyes.

By the end of the refactor I also found a strange compile-time issue when using
references to closures in recursive call-sites. I looked them up in the
`rust-lang/rust` issue tracker, and it seems that's a known issue in
diagnostics.

Apparently, when monomorphizing and ensuring automatic dereferencing takes
place, the compiler fails to report that a closure should not be passed with an
explicit level of indirection. This had me setting a `Clone` trait bound on it.

Still, my original issue remains unsolved, and it seems the refactor of the
merging function causes resolution to altogether have no effects. This is fairly
strange because I've yet to find out what am I missing in that one bit.

Lean-wise, things have gone fairly well. I've learnt about the way monads are
used in Lean, and thus far it seems fairly similar to Haskell and others.
Notably, I also tried implementing a type class for representable functors.

Suffice to say, lazy-evaluation in Haskell gets a lot of stuff out of the way
when you're thinking about indexing into some potentially non-finite functor. I
specifically tried to define an instance for an infinite stream of data.

This I stopped focusing on to go back to the book when I realized it wasn't
enough to just wrap the natural transformation from the hom-functor to the
functor in a lazy thunk.

Termination analysis would have required quite a bit of time for me to figure
out, but the thing that made me decide to quit for now was that types are forced
into having some indication that they are not uninhabited (i.e. the void.)

Getting a stream to yield a "default" value that indicates such property without
proof is not really possible lest I use the natural transformation defined for
representable functors. This typeclass method itself checks for inhabitedness.

Overall, it seemed, to a first approximation and without giving it too much
thought, that streams need something else to encode the fact they're infinite
but are not expected to be wholly computable within some finite amount of time.

= Blockers
None.

= Plan for the week
I will continue hammering at the `ctest` issue tomorrow. I still wonder what
exactly is going on that I missed quite terribly. I expect Lean work to continue
the same way it has thus far.
