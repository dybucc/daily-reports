#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-08-26)])

#title()

= Summary
Today work has focused again on continuing the set up I've been preparing for
this repository's site, as well as on further improving the parser specification
for the Typst compiler I'm building. Today I have neither worked on any
rust-lang sutff.

At present, I can say I have deployed the site at least twice, but have had no
success in displaying the compiled HTML files. The strategy I ended up going for
didn't use Git submodules for the template's repository.

After making the template public, I set up a quick workflow to easily copy over
the contents of the template's repo to a bumped package version in my local
Typst package paths. This also tags the current tip-of-tree commit as the next
non-breaking SemVer release.

Then back in the `daily-reports` repository, I clone the repo while keeping the
version of the repo I want to access in a just variable. This then uses some
string interpolation and lazy expression evaluation to only clone the template
repo when the recipe for building is run.

It's also set up to automatically use the returning string from the script that
sets up the template as the last component of a path constructed from the
`justfile`'s working directory. This makes all Typst commands work as expected.

I also decided to leave out some more stuff off of the actual command that
drives compilation, so as to make refactorings simpler. This really only went
through setting up some more environment overrides for variables Typst reads
(for both my monospaced font of choice and the experimental features required to
compile HTML at the time of writing.)

I ended up not using a `.env` file because I thought I could more easily handle
it all within the `justfile`. Then I set up a workflow file, which was quite
simple because the GitHub folks make the Pages actions a breeze to configure.

The issues during deployment came from a fairly idiotic mistake I made while
writing the command that drives compilation; Instead of recursing through the
glob-expanded list of `*.typ` files, I simply spread them in a single command.

This meant only one file would get compiled, and because thus far there are only
two Typst files (prior to this daily report) in the repository, Typst would
silently fail. This would leave me a compiled HTML file with the name of one of
my Typst files (and its extension.)

In terms of the parser, things have gone great today; I've finished up defining
(an initial draft for) operator associativity and have improved the way I handle
some syntactic sugar for function definitions.

Menhir (the OCaml grammar generator) uses three declarations to establish both
associativity and precedence of any set of tokens. I believe to have striked a
relatively correct priority tree, but testing will likely reveals issues.

The reason why I went with this first was to potentially reduce the number of
severe shift/reduce conflicts once the grammar analyzer starts running. This is
likely to take some more time because I've yet to define the `ocamllex` lexical
analyzer.

In terms of other refactorings, things are going quite well; Other than the
afore-mentioned sugared lambda definitions, I've also implemented proper support
for patterns and fixed some old code that still mixed strings with identifiers,
and allowed patterns when expecting a derivation tree of informal parameters.

= Blockers
None.

= Plan for the week
I expect the site to be up and running by tomorrow. The two things that I was
worried about yesterday have already been resolved, and now I'm solving issues
related to my own skill issues when using script recipes in just.

I've also thought of setting up GitHub Actions caches for the Typst binary that
I compile on every run, just so I can speed up the workflow runs from taking a
bit over 7 minutes to (possibly) less than 5 minutes.

The parser is bound to continue improving as I notice areas I initially missed
while specifying the grammar. As mentioned yesterday, most of the nonterminal
symbols the official Typst supports are already there, and the rest will have to
wait until I have a fully-featured compiler.

One particular area I will be first working on tomorrow is a recursive analyzer
to run as a semantic action for the production group that yields `let` bindings.
I don't think I can yield full definitions for each destructured item of the
binding at parse time, as I would require further context from a compilation
session like the return values of a function for potentially interpreting the
right hand side as an implicitly expanded array or dictionary from using the
spread operator. Still, I can probably detect some more obvious error
conditions.
