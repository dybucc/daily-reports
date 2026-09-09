#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-08])

#title()

= Summary
Today work has focused on two things; Getting more used to the life without a
lot of comfortable tools that I got rid of for OSS work, and working my way
through the _SML for the working programmer_ book.

Yesterday's report was considerably shorter than it should have been. That was
due to the recent switch in tools and workflows I've undergone. As mentioned
yesterday, I have stopped using software with AI involved in its maintenance.

This has meant no `lazygit`, no `ripgrep`, no VSCode, no `homebrew`, no browser
but the one shipped with my system, etc. My work has seriously slowed down, but
as also mentioned yesterday, I believe it worth it.

`lazygit` especially, was a tool that I used a lot and on which I depended for
all my Git needs. I've now read through a bunch of manpages for the Git command
line, which even though also tainted by AI, serves as a temporary tool.

Because I didn't yet know how to quickly run rebases and commits with my editor
without using `lazygit`, I hesitated to write more. I hope to make that up
today.

Yesterday I didn't mention anything notable about what progress I made on the
compiler. I solved the confusing issue I had stumbled upon with the Menhir
grammar, where a certain semantic action was reporting type checking errors.

Apparently, the code in Menhir that handles the types returned from each
production for a given rule uses existential types. This is the default in OCaml
wherever polymorphism is involved.

This made it so that once a given rule yield a value of a certain type that was
expected to be constrained as the polymorphic parameter to a GADT, every other
rule that also used that nonterminal would get the same (constrained) type.

For set and show rules, which were the rules involved in my particular case, I
expected a constrained set rule type in the optional expansion of show rules.
But then I also expected an unconstrained set _or_ show rule in set rules.

The first Menhir production determined that the matching of the polymorphic
variant I used for constraining whether I expected set or show rules was closed.
The production for set rules only expected an open matching of those variants.

The solution went through manually inlining each rule as another production
group of the rule that needed it. This is a verbose solution, but one that
allows the semantic actions to avoid messing with subtyping coercions.

I also solved a bunch more issues with the grammar, and noticed that I could
potentially abandon the use of an automatic grammar generator. Some
reduce/reduce conflicts I realized would be best solved with more lookahead.

Artifical manipulation of the grammar is also an option, but I decided against
that. Either way, I abandoned altogether use of OCaml for SML/NJ, which I have
been studying today. More on that later.

In terms of rust-lang/libc work, I have seen moderate success in continuing work
on some of my open PRs. Yesterday I didn't mention anything about the `ctest`
extension work, because I intended on first addressing recent PR feedback.

The feedback continues to be only partially addressed. The reason for that is,
as commented initially on today's summary, my lacking knowledge of the Git
command line. I am still getting used to rebases without `lazygit`.

I can say I have fixed some of the comments in the PR that added support for the
`exhaustive` attribute to our new macros. Feedback was mostly centered around
starting to use the attribute in some records, and some cosmetic aspects.

There is more feedback on that PR that I have yet to go through.

Lastly, I would want to comment on today's study of both the SML'97 definition
reference, and an SML book I have started reading. It seems SML is very much
similar to OCaml. I have been largely successful in solving problems with it.

I have quickly skimmed through the grammar in the reference, and have studied
examples and the first two chapters of the book. I have attempted solving
problems from the OCaml repository in SML; It feels just as nice.

One notable highlight is that I can finally rid myself of any and all
OOP-related functionality; One notable drawback is that SML is neither purely
functional.

= Blockers
None.

= Plan for the week
In terms of rust-lang/libc work, I will continue addressing PR feedback until
I'm completely done with it. Today I have learn most of the nice tricks
`lazygit` just solved for me, so I hope to speed things up in the next few days.

In terms of compiler work, I believe I will be starting the parser anew with a
handwritten LL(k) parser, with which I expect to have access to more lookahead.
Before that, I would want to finish reading the first 8 chapters of the book.
