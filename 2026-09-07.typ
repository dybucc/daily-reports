#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-09-07)])

#title()

= Summary
Today work has focused on a few things, most notably a transition from using
software that may have potentially been coded with AI-assistance to no such
projects.

Allow me to explain myself. I do not use AI for anything, and I feel downright
xenophobic hate against AI itself (but quite definitely not against the backing
research.) Of course, this makes me hate a lot of the software I use daily.

#let open-slopware-link = {
  let body = [`ethical-foss/open-slopware`]
  link("https://codeberg.org/ethical-foss/open-slopware")[#body]
}

So after thinking it about for a few weeks, and deciding that I prefer struggle,
I went down the #open-slopware-link route, and started looking for replacements
to most software I use that may have had LLM involved in its maintenance.

This has so far been met with success on the side of getting rid of a crap ton
stuff on my system. Thankfully, I can say both my shell and typesetting system
of choice are both anti-AI. Unfortunately, Rust isn't.

I plan on continuing my involvement with the Rust community, though. On the side
of getting replacements for those tools, I've had moderate success in going back
to using Vim instead of VSCode, and looking into SML/NJ instead of OCaml.

Yes, Vim is slop these days, but I'm temporarily using the Vim that comes
pre-compiled in my system, which seems like a raw enough experience. Most
software alternatives require GNU autotools, and those I've yet to compile.

I also got rid of my package manager, as it was riddled with AI stuff, and of my
command launcher, which literally shipped an AI feature. The latter I can live
with just fine, but the former is going to take a while getting used to.

Now, this was something I spent only half of today on, and may potentially spend
some more time tomorrow. It is a tough transition, because a lot of nice stuff
like `ripgrep` or `lazygit` are now slop to me. But I need it.

In terms of actual work (in the other half of the day,) today I worked on a
bunch of stuff mostly concerned with PR reviews in rust-lang/libc. This required
changing some stuff from old-time PRs like the AIX PR.

I also worked some on the compiler, which has finally seen the parser finished,
and I've started working on resolving reduce/reduce conflicts from productions I
can't quite inline, but that I can quite definitely priority (through `%prec`.)

= Blockers
The no-AI in the software I use is going to potentially consume a bunch of hours
in the next few weeks. I hope tomorrow to have the usual GNU tools for
compilation set up, so that I may first install `got`, and then Vim Classic.

= Plan for the week
The rust-lang/libc work I expect to continue working tomorrow first thing in the
morning, so as to take up the first half of the day. This is the same as what
I've done today, because I can dedicate the best of myself to actual work.

In terms of compiler work, I don't expect to continue working on the compiler in
its current form tomorrow. I first would want to set up a working SML/NJ
compiler, with which to start rethinking how I should address this project.
