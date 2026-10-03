#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-03)])

#title()

= Summary
Today work has focused on two things. One of these was completely unexpected. No
work has gone into the Idris proof. Neither has there been work on Rust matters.
The NGINX proxy server work has started. Some other useful work also got done.

This other work consisted of editor integrations. The day started with an
annoyance. The editor in use (Neovim) has poor default notifications. Use of
plugins is undesired. So notification utilities were devised.

That took up the first half of the day. The problem was simple. The interaction
with errors is bad. An error in formatting interrupts the editor. Existing
editor integrations used assertions. These are just crashes.

Neovim has notification support. It is exposed through a library function. But
it writes to some old Vim buffer. That is only the default behavior. One can
overwrite that notification function. That was what this work consisted of.

An override was devised. It uses floating windows. It displays the notification
for a certain amount of time. The interval is determined based off of the
notification text. The width is fixed. The number of lines sets the interval.

This provides a nice experience. But it was time-consuming. Neovim needs careful
event handling. Sometimes the editor restricts certain actions. This needs async
execution. It also needs correct scheduling. The latter is "automatic."

A few utilities around this were also implemented. These are now used in
error-reporting functions. A few tree-sitter parsers were also compiled. These
had been in the `TODO` list for a while.

The NGINX work is slow. It seems simple. The installation takes a while. Efforts
are currently focused there. All pre-requisite libraries were missing. Even
OpenSSL. This has been time-consuming. It took up the latter half of the day.

No package manager makes things harder. But principles come first.

= Blockers
None.

= Plan for the week
The weekend was planned to set up NGINX. Today that was only half of it.
Tomorrow it should be the whole thing. The plan seems clear. A forward proxy
server is needed. Specific URI patterns have to be redirected.

Potential issues may come from the client. A system's requests may consist of
non-HTTP payloads. This may not be handled correctly by NGINX. That remains to
be seen.
