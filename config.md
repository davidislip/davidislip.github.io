<!--
Add here global page variables to use throughout your website.
-->
+++
author = "David Islip"
mintoclevel = 2

# uncomment and adjust the following line if the expected base URL of your website is something like [www.thebase.com/yourproject/]
# please do read the docs on deployment to avoid common issues: https://franklinjl.org/workflow/deploy/#deploying_your_website
# prepath = "yourproject"

# Add here files or directories that should be ignored by Franklin, otherwise
# these files might be copied and, if markdown, processed by Franklin which
# you might not want. Indicate directories by ending the name with a `/`.
# Base files such as LICENSE.md and README.md are ignored by default.
# NOTE: CLAUDE.md and plan.md are repo-internal docs — without them listed here
# Franklin builds them into public pages at /CLAUDE/ and /plan/.
# `_sass/` is SCSS source, not served output — without it listed here Franklin
# copies all 17 partials to the live site under /_sass/.
# package.json / package-lock.json do not exist in the repo — CI creates them in
# the root when it runs `npm install highlight.js`, just before optimize().
ignore = ["node_modules/", "package.json", "package-lock.json",
          "CLAUDE.md", "plan.md", "preview.html",
          "Project.toml", "Manifest.toml", ".vscode/", "_sass/"]

# Serve these paths verbatim instead of converting them to <name>/index.html.
# The Google Search Console file MUST be served at its exact .html URL.
# This must stay inside the +++ block to be parsed as config at all.
keep_path = ["google599763433934e4da.html"]

# RSS (the website_{title, descr, url} must be defined to get RSS)
generate_rss = true
website_title = "David Islip Quant"
website_descr = "David Islip — Quantitative researcher specializing in financial optimization, machine learning, and operations research."
website_url   = "https://davidislip.github.io/"
description   = "David Islip — Quantitative researcher specializing in financial optimization, machine learning, and operations research."
+++

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}