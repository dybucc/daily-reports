#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily report (2026-10-04)])

#title()

= Summary
Work today has focused on two things. The NGINX server work is not finished. But
progress has been made on that front. A computer upgrade has taken place. The
latter took up quite a bit of time.

Yesterday's NGINX work continued. It had been left at compilation. There had
been issues with OpenSSL. This got eventually sorted out. But new issues
awaited. FIPS providers are one huge rabbit hole.

Research into FIPS providers started then. This went through a number of package
installations. Some of them were faily unrelated. Some packages were needed to
OCR documents. These contained old information on FIPS providers.

This already took up a few hours. Time is at a premium. So a decision was made.
A full system clean up was in order. Then a system upgrade would follow. And
then package management utilities would be installed.

That took up a few more hours. Then came the NGINX work. It was fairly easy to
install with a package manager. But that was it. The configuration is still
tricky. More experience should make it easier to grok.

Current difficulties revolve around resolution. A certain URI pattern is easy to
match. NGINX is also capable of forwarding. The issue is not hostname
resolution. The issue is full request resolution.

The goal is to proxy requests against specific URIs. That should be possible
through HTTP tunneling. The problem then becomes the target URIs. The client
still requests a tunnel. But there's need to lie to the client.

The client should then trust the connection. But that is TLS-encrypted. That is
why the client can trust the tunnel. This will not become a project to break
TLS.

= Blockers
None for the main work. The proxy work is blocked on the above issue.

= Plan for the week
The week will be spent on the Idris community tutorial. It will also be spent on
the ctest extension. The latter will take up the first half of the week. Then
there are other Rust matters to address in rust-lang/libc.

The proxy work will need some alternative solution. NGINX will be researched
further. But it is potentially not suited for this task. One other possible
solution is to alter kernel routing tables. That will wait until next weekend.
