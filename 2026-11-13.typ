#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-11-13)])

#title()

= Summary
Today work has focused solely on one thing --- Tweaking my Neovim configuration.
This followed up from yesterday's efforts, this time finalizing an
implementation of an in-process language server for minor formatting tasks.

Beyond the above summary, there's nothing else to highlight. I tweaked a bunch
of other stuff, but there's nothing nice or really hard to it, so it's not worth
discussing. The in-process language server was also fairly simple to set up.

The thing that made me spend the entire day on it was the fact I had to read
through the whole LSP documentation for Neovim, and a large part of the upstream
LSP spec. The end result, though, is finally getting proper whitespace trimming.

See, until today, I had a simple autocommand set up in Neovim for getting
trailing whitespace removed (whether that be newlines or any other whitespace at
the end of a line.) This had one major flaw --- It garbled my editor marks.

I thought about having some way of subverting the mark tracking/record system,
but that didn't pan out so I went down the LSP path. In Neovim, you can spawn
language servers that are either or both controlled and handled by the client.

The idea is to have a bunch of functions be tied to a server table that is yield
back to Neovim in much the same way as "low-level" handling of JSON-RPC
communication with a server would. Except the whole thing is in-process.

And that's about it. One thing to note is that I decided to go down a simpler
route than traditional language servers. Generally, language servers have not
the slightest idea about the client-side of things.

But in this case, I know all too well I'm running Neovim as the client, and I've
got functions to convert back and forth between document URIs and buffer
numbers. This means I need not keep an in-memory representation of documents.

In other words, the code is far simpler than if I had truly replicated a
client-agnostic language server. I didn't have to announce document
synchronization capabilities during initialization, nor handle those requests.

This also means I get to reuse the buffer resources Neovim already allocates
instead of having another snapshot of the buffer contents as part of the
server's document state.

= Blockers
None.

= Plan for the week
The last two days have been a bit awkward with respect to the usual work plan.
To compensate for that, I will replace the time I spend on the Haskell course
this weekend with time spent on the `ctest` extension matters.

Still, I believe I will have to make more changes to the Neovim configuration so
as to also tweak other formatter integrations I built that suffered from much
the same flaw as the one described in today's summary.
