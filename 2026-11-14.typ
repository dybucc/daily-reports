#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-11-14)])

#title()

= Summary
Today work has, again, focused solely on tweaking my Neovim configuration. I
expected that a few more tweaks would be necessary for me to leave it off for a
few more weeks, and, indeed, this turned out to be the case.

Still, I started off with the usual proxy server maintenance. I tweaked some
files I serve locally, and ensured the thing still intercepted my network
traffic without reporting it to any running process.

Beyond that, I continued where I left off yesterday. I debugged the in-process
language server I had built for simple formatting requests, and then started
working on other language server integrations I was missing.

Thus far, I had been working in VSCode for the purposes of having a good Lean
experience, as their Lean extension is really good. I don't use plugins I've not
implemented myself in Neovim, so that was a no-go for now.

I instead decided to improve my Lua, Rust, Typst and Markdown language server
integrations. Out of those, I've only set up the Lua one. Though it still
doesn't count as success because the `stylua` formatting integration is pending.

= Blockers
None.

= Plan for the week
I expect to continue working on the integration for the language servers
tomorrow. I sure hope things start moving faster after all of today's reading
through the Neovim documentation.

The goal would be to also set up the Haskell language server integration, but
we'll see how far we get. I would also like to tweak a few more things of the
proxy server.
