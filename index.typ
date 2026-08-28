#import "@local/scratchpad:0.1.4": *

#show: template.with(title: [Daily reports])

#title()

This page compiles all of my daily reports, which contain information on what
I've done throughout the day. The contents focus solely on coding/research. They
contain news on my work in rust-lang/libc and rust-lang/rust, as well as
discussion on personal projects.

#let reports = ([2026-08-25], [2026-08-26], [2026-08-27], [2026-08-28])
#let report-list = for report in reports {
  [- #link("./" + report.text + ".html", report)]
}

#blist(report-list)
