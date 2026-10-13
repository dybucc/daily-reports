#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-13)])

#title()

= Summary
Today work has focused on a bunch of things, chief among them the Idris
community tutorial and some tweaking of my editor configuration. Some work has
also gone into the `ctest` extension by means of tests for the new algorithm.

Work actually started off with Rust. The part of the `ctest` extension concerned
with module resolution has been recently revamped. The new algorithm I already
spoke about in the last few reports, and today it was all about testing.

I also wrote up some more of my thoughts on it, reviewing each part of the
algorithm. This revealed a few areas in which, even though not incorrect, there
was some needless work being performed. This lead to a number of refactors.

Today the report is getting ready a bit sooner than usual because there's some
IRL stuff to deal with in the evening. That also lead to a change of plans in
the usual schedule. That gave me some spare time here and there.

This time I spent working on my Neovim configuration. More specifically, the
proposition I always use for reporting errors through my custom notification
handler neded a bit of a refactor.

The proposition, much like an assertion, accepts both a condition and an error
message. The latter is always evaluated, which is unforunate because there's
some call-sites where the error message depends on a falsy condition.

This is a consequence of the dynamic typing nature of Lua. If some error message
is going to report the stderr output of a given command, it must first know that
the given command's logic failed, and thus there really is something in stderr.

That can be easily handled at call-site, but repeating it over and over again
gets messy and overly verbose. It would be best if the message the
assertion-like proposition accepted could also be a lazily-evaluated closure.

That was finished, and a few call sites were cleaned up afterwards. Then I also
set up Neovide as a GUI for Neovim, and started working on a lazygit integration
in the editor. The end goal is to stop having to switch back to the terminal.

Idris work continued as usual, which means there is not much to highlight.
Admittedly, my skill to come up with tacit expressions is genuinely better than
a few days ago. I don't struggle to understand the composition flow anymore.

One beautiful tacit expression I immediately came up with is a `Show` interface
implementation. This is basically an equivalent to Rust's `Debug` trait. It is
used to provide a source-equivalent string representation of a value (proof.)

```idris
public export
Show a => Show (Last a) where
  showPrec = (. ("MkLast" ,) . showArg . value) . uncurry . showCon
```

In Idris, one may implement one of show or `showPrec` as propositions associated
with the `Show` interface. `show` seemed like too easy for a tacit challenge.
`showPrec` requires more thought.

It assumes two proofs. The first one is a precedence level dictating the
nestedness of the string in some other wrapping `Show` interface implementation.
This can be mostly ignored as it is just passed on to an anciliary proposition.

The second one is a value of the type. A traditional proof would use the
`showCon` proposition to get a string representation of the data constructor,
and the `showArg` proposition to get a string representation of its arguments.

The tacit expression also does that. It is best to read from right to left
instead of from left to right, as that is also the order of application. it
first partially applies `showCon` with the precedence assumption.

Then it uncurries the yet-to-be-applied assumptions of `showCon`; The value and
the arguments. Then the next proof passed to `showPrec` is a value of type
`Last a`. That gets its inner coproduct extracted through the value projection.

Then that gets fed into the `showArg` proposition, and applied as the remaining
(right) element of the canonical product (an unlabeled pair.) This then gets fed
back into the partially applied `showCon` to obtain the desired string.

= Blockers
None.

= Plan for the week
Work will continue on testing the new algorith, and potentially trying to reason
some more through why I think it is correct. It would be ideal to eventually
come up with a formal proof so that I am reassured of its correctness.

Idris work will continue as per the usual. I am starting to doubt yesterday's
statement about point-free style not beign possible when matching against a
custom coproduct with more than one injection.
