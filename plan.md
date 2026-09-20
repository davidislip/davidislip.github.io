# Site Improvement Plan — davidislip.github.io

**Date:** 2026-09-19, updated 2026-09-20
**Status: every phase is complete**, bar three things listed below. Both design decisions are settled —
the DI chip stays, and the body and the math are both sans. Everything was verified against a real
`optimize()` build in headless Chrome, then against the live site after deploying.

**The only thing still open is a CV page and a contact route** (Phase 4), parked at the author's
request. They remain the two largest gaps for a recruiter or for an academic peer arriving from a paper.

### Shipped

| Item | Result |
| --- | --- |
| `/CLAUDE/`, `/preview/`, `/plan/` published | Added to `ignore`; absent from a clean build |
| **`_sass/` published** (17 partials, found by clean rebuild) | Added to `ignore` |
| **`package.json` published** (CI generates it; live today) | Added to `ignore` |
| `Project.toml`, `Manifest.toml`, `.vscode/` published | Added to `ignore` |
| Google verification 404 | `keep_path` moved inside `+++`; now served at its exact URL |
| Hand-written `sitemap.xml` / `robots.txt` overwritten every build | Deleted; Franklin owns both. Sitemap down to 7 real URLs |
| Headshot 1857×2170 / 737 KB | Resampled to 600×701 / **76 KB** |
| og:image dropped below large-card threshold by that resample | Separate 1200×1402 `headshot-og.jpg` + `og:image:width/height/alt` |
| Malformed `<img>` (stray `,` and `;`), no `alt`, no dimensions | Fixed |
| `post1.md`: σ defined as the variance; `N(·,·)` convention flipped mid-post | Standardized on `N(mean, variance)`; convention stated; Ξ redefined per-observation; `→d` reserved for √T-scaled forms; added the `h(v)=√v` step Part 3's title promises |
| `post2.md`: 5 non-breaking spaces, 2 inside math, warning on every build | Replaced; build is now warning-free |
| `Sass` not a dependency, so README's compile command was unrunnable | Added to `Project.toml` |
| Orphaned `celeste.min.css.map` | Deleted, `sourceMappingURL` stripped |
| `README.md` / `CLAUDE.md` stale or contradictory | Both rewritten; `ignore`/`keep_path` now documented |

Two of these were found only by rebuilding from scratch and by adversarially re-checking the first
pass — `_sass/` and `package.json` were not in the original audit.

## How this was produced, and how much to trust it

A seven-dimension audit (visual design, responsive, accessibility, content correctness, SEO/metadata,
UX/IA, build/tooling) ran over the source. Every finding was then attacked by two independent adversarial
verifiers — one checking that the quoted code really exists where claimed, one arguing that it isn't
actually a problem on *this* site. A finding is listed below only if it survived both. 5 findings were
killed and are recorded in [Appendix B](#appendix-b--claims-that-did-not-survive) so nobody re-raises them.

Three tiers of confidence are used:

| Tier | Meaning |
| --- | --- |
| **Verified live** | Checked against the deployed site or a local `optimize()` build. Not a prediction. |
| **Verified in source** | The exact rule/line was read and the cascade or parse behaviour confirmed. |
| **Judgement** | A design or editorial opinion. Argued, but a matter of taste. |

---

## 1. The headline: what was broken in production — now fixed

These were **verified live** against `https://davidislip.github.io/` and a local `Franklin.optimize()`
run. All are now fixed in the working tree; the descriptions below are kept because they explain *why*
each `ignore`/`keep_path` entry exists. The live site still shows the old behaviour until you deploy.

### 1.1 `CLAUDE.md` is published as a public page

`https://davidislip.github.io/CLAUDE/` serves the full AI-assistant guide — repo layout, workflow,
deployment notes — and it is listed in the generated sitemap, so it is indexable.

**Cause:** Franklin ignores `README.md` and `LICENSE.md` by default. `CLAUDE.md` is not on that list, and
`config.md:16` is only `ignore = ["node_modules/"]`.

**Fix:** add `"CLAUDE.md"` to `ignore` in `config.md`.

### 1.2 `/preview/` is published — and it advertises papers that don't exist

`preview.html` is a tracked, stale mock-up at the repo root. Franklin builds it to
`https://davidislip.github.io/preview/`, where it is live now: a second copy of the home page with dead
`#` nav links, listing two publications that aren't real. It is also in the sitemap.

**Fixed:** kept as a local style specimen rather than deleted — it exercises blockquote, `pre`/`code`,
`hr`, tables and footer, which no real page does, and the Phase 3 refit needs exactly that. It is now in
`ignore`, its fabricated entries were replaced with real ones, and it was corrected to load `franklin.css`
before `celeste.min.css` and wrap content in `.franklin-content` — without which it renders a 34/25.5/21.25px
heading scale the live site does not have, and would have validated the CSS work against the wrong cascade.

### 1.3 Google Search Console file verification is 404ing

`https://davidislip.github.io/google599763433934e4da.html` → **404**. Franklin processed the file into a
page directory, so it is served at `/google599763433934e4da/` instead.

**Cause:** `keep_path` sits at `config.md:32`, but the `+++` block closes at `config.md:24`. It is parsed
as page body content, not as a config variable, so it has never taken effect.

**Not urgent:** the `google-site-verification` *meta tag* in `_layout/head.html:4` is an independent,
working verification method, so Search Console is presumably still verified. Fix it anyway.

**Fix:** move `keep_path` inside the `+++` block. Reduce it to the one entry that needs it —
see 1.4 for why the other two are pointless.

### 1.4 The hand-maintained `sitemap.xml` and `robots.txt` are deleted on every build

`generate_sitemap` and `generate_robots` default to `true`, so Franklin overwrites both. Editing the
root copies accomplished nothing. The generated sitemap listed nine URLs including `/CLAUDE/` and
`/preview/`, uses `.../index.html` form, and stamps every entry with the same build date.

**Fixed:** the two root files were deleted and **Franklin now owns both outright** — `generate_sitemap`
and `generate_robots` were deliberately left at their `true` defaults. Fixing 1.1/1.2 removed the junk
URLs automatically; the generated sitemap is now 7 real pages. The remaining wart is the `.../index.html`
URL form, which a `rel=canonical` (Phase 4) resolves properly.

> A local build on Windows writes backslashes into the sitemap's `<loc>` values. That is a Franklin
> path-separator artifact of the local OS only — the Linux CI output on `gh-pages` uses forward slashes.
> Don't try to "fix" it.

### 1.5 The build publishes dev files

A build emits `Manifest.toml`, `Project.toml`, `_sass/` and `.vscode/settings.json` into `__site/`
alongside the site. Harmless but untidy; `.vscode/settings.json` is also an empty `{}` and probably
shouldn't be tracked at all.

**Fix:** extend `ignore` in `config.md`.

### 1.6 The headshot is a 737 KB, 1857×2170 image served at 150×180

It is the LCP element on the home page and the `og:image` for every page, with no `width`/`height`
attributes (so it also causes layout shift). The `<img>` tag itself is malformed and has no `alt`:

```html
<img class="right" src="/assets/headshot.jpg", style="width: 150px; height: 180px";>
```

Note the stray `,` after `src` and the `;` before `>` — both become bogus attributes. The fixed 150×180
also squashes the source's 0.856 aspect ratio slightly, since nothing sets `object-fit`.

**Fix:** resample to ~600px wide (<80 KB), add `alt`, remove the inline style and the stray punctuation,
move sizing to `_sass/pages/_landing.scss`. Add a separate 1200×630 `og:image`.

---

## 2. The root cause of the look-and-feel problem

**This is the single most important finding in the audit, and it reframes everything else.**

Most of the designed stylesheet never reaches the browser.

`_layout/head_mixin.html` loads two stylesheets: `franklin.css` (line 1) then `celeste.min.css` (line 4).
Franklin wraps all page content in `.franklin-content`, so `franklin.css`'s class-scoped rules
(specificity `0,1,1`) beat Celeste's element rules (`0,0,1`) — **regardless of load order**.

Verified in source, comparing the two compiled files:

| What `_sass/` specifies | What actually renders | Why |
| --- | --- | --- |
| `h1 2rem / h2 1.5rem / h3 1.25rem` → 34/25.5/21.25px | **24 / 22 / 20px** | `.franklin-content h1 {font-size:24px}` — `_css/franklin.css:128-130` |
| `html {line-height: 1.5}` | **1.35em, frozen at 22.95px** | `.franklin-content {line-height:1.35em}` — `franklin.css:86` |
| `$link-color: #4a7ab5` | **`#004de6`** (electric blue) | `.franklin-content a` — `franklin.css:207` |
| — | **`green`** citation links | `.eqref a`, `.bibref a` — `franklin.css:220-221` |

The h2→h3 ratio as rendered is 22:20 — a ratio of 1.09. That is not a hierarchy; it is why the pages read
flat. And because the SCSS appears to say otherwise, past fixes have landed as inline `style="..."` in
`index.md` and `404.md` instead of in the stylesheet.

Two more consequences of the same fight:

- **The entire mobile CSS block is dead.** `franklin.css:99-122` — the only deliberate mobile work in the
  repo, including a nav fix whose own comment says it makes five items fit at 320px — ties Celeste on
  specificity and loses on load order. It has never once applied.
- **A large fraction of `_sass/` targets classes Franklin never emits**: `.post-title`, `.post-date`,
  `.landing-title`, `.pagination`, `.message`, `.lead`, `.ftr-links`, plus a 69-line Rouge syntax theme
  (Franklin uses highlight.js). This is why the blog index has no dates.

`_sass/adjust.scss` exists precisely to resolve this. It is currently 8 lines.

> **Two unit traps to know before touching this.** `.franklin-content {max-width: 38rem}` is 646px at a
> 17px root, but `@media (max-width: 38em)` resolves against the browser's 16px default = 608px. They look
> identical and are 38px apart. Separately, `.katex {font-size: 1em !important}` at `franklin.css:279`
> means any KaTeX sizing must be written at `.franklin-content .katex` with `!important` or it silently
> does nothing.

---

## 3. Design direction

Three directions were developed independently and scored by a judge panel on credibility, legibility,
distinctiveness and feasibility.

| Direction | Cred | Leg | Dist | Feas | Total |
| --- | --- | --- | --- | --- | --- |
| **Quiet Rigour** — Celeste refit on real tokens | 8 | 9 | 6 | **9** | **32** |
| The Quant's Instrument Panel | 8 | 7 | 8 | 6 | 29 |
| Offprint — the site set as a journal | 9 | 6 | **9** | 4 | 28 |

**Winner: Quiet Rigour**, with grafts. It was the only direction whose mechanism is buildable end to end
from `_sass/` and `_layout/` alone, and the only one that makes the display math in `post1.md` *easier*
to read rather than harder — Offprint narrows the measure to 63ch and Instrument Panel to 68ch, while
Quiet Rigour gives `.katex-display` a `width: min(46rem, 92vw)` bleed track that is wider than the prose
column. Its weakness is distinctiveness, which is the one criterion that grafts cleanly.

### The thesis

Restore the design that `_sass/` already describes but cannot deliver, on a token system that makes dark
mode additive rather than a rewrite. The reader should never notice a redesign — only that the page got
easier to read.

### Grafts adopted

1. **The hanging year gutter** (from Instrument Panel). A 4.5rem monospace tabular column left of the
   measure on `research.md` and `presentations.md`, so papers and talks share one vertical axis. This is
   the single best distinctiveness idea available and it lands on the winner's weakest area.
2. **"Mono is metadata, never prose."** Reserve the already-loaded Source Code Pro for years, volumes,
   page ranges, DOIs and post dates. Buys the instrument-panel signal at zero added network weight.
3. **A second, restrained apparatus accent** (from Offprint). Don't collapse `\citet` keys, `\biblabel`
   anchors and equation numbers into the same blue as prose links — three `\citet` calls appear within
   eight lines in `post1.md`. Use `$mark-700` for journal apparatus only, never navigation.
4. **`font-variant-numeric: tabular-nums`** scoped to the bibliography and equation counters — *not*
   applied globally. Tabular figures in running prose are a typographic demerit.
5. **Delete rather than restyle** the dead partials: `_sass/components/_pagination.scss` (56 lines) and
   `_sass/components/_message.scss` (12 lines), plus their `@import`s.

### Token set

The full 32-token set (light + dark, with computed WCAG ratios for every pair) is in the audit output.
The shape of it:

| Token | Value | Role |
| --- | --- | --- |
| `$ink-900` | `#16181D` | Headings. 17.76:1 on white |
| `$ink-700` | `#24272C` | Body copy, and all KaTeX via `currentColor`. 14.98:1 |
| `$ink-500` | `#4E555E` | Dates, equation numbers, footer. Replaces `#9a9a9a` |
| `$blue-900` | `#0A3B76` | Kept verbatim. Structure only — top border, nav mark |
| `$blue-700` | `#0F4C8C` | Every interactive thing. Retires `#4a7ab5` and `#004de6` |
| `$mark-700` | `#7A1F2B` | Journal apparatus: `\citet`, `\biblabel`, `.eqref` |
| `$measure` | `68ch` | Prose column |
| `$measure-wide` | `46rem` | Bleed track for `pre`, `table`, `img`, `.katex-display` |
| `$line-height` | `1.65` | Unitless — fixes the frozen `1.35em` |
| `$scale-ratio` | `1.2` | Minor third → h1 1.728rem / h2 1.44rem / h3 1.2rem |

Ratios were recomputed independently during judging; all 17 light/dark pairs matched to 0.01.

### Two decisions — both settled 2026-09-20

**The "DI" chip: KEEP IT.** `_layout/header.html:6` puts a filled navy disc with a 0.5s hover.css ripple
between RESEARCH and PRESENTATIONS.

The audit and design panel argued for removing it, calling it "the strongest surviving signal that this
is a 2015 blog theme." On review that claim is **not supported** — a circular monogram linking home is a
normal pattern, not a defect, and there is no correctness issue here at all. The supporting arguments
were weak too: "a third link to `/`" is true and harmless (logo-plus-Home is standard), and "the only
saturated colour above the fold" is what an identity mark is *for*. Recorded here because the removal
case was overstated and should not be re-raised on the same grounds.

What *is* real, and is in scope for Phase 3:

- The nav wraps to two ragged lines below ~505px and the chip lands stranded as the trailing item of
  row one. Cause: five items not fitting a phone width. Fix it in the nav layout — which Phase 3 must do
  regardless, since the only mobile nav CSS in the repo has never applied.
- `hvr-ripple-out` is a 0.5s animation and nothing in `_sass/` honours `prefers-reduced-motion`. Gate it.
- Screen readers announce the link as "DI", which is opaque. Add an `aria-label`.

The only honest reason to revisit would be preferring the nav to lead with your name rather than a
monogram. That is a preference, not a fix.

**Body face: SANS — settled 2026-09-20.** The site keeps Source Sans Pro for prose. The Source Serif 4
variant was built in `preview.html` against real content, compared, and rejected; the toggle has been
removed rather than left as stale cruft.

**Math typeface: SANS TOO.** The argument that pushed toward serif was that KaTeX renders in Computer
Modern, so the math-heavy posts set serif formulas inside sans prose. With the body settled as sans,
that mismatch was resolved from the other end — the math moved to sans instead of the prose moving to
serif. KaTeX already ships a Computer Modern Sans family (the `sfmath` look) that was going unused.

Checked first, because two things could have made this a bad idea:

- **Greek.** These posts run on μ σ Σ α β Θ Ξ χ π Φ Δ δ. All of it is present in the sans family —
  measured across both posts, **1361 glyphs now render in `KaTeX_SansSerif` and zero fall back** to
  Times or a generic face. Greek falling back would have been worse than the original mismatch.
- **Metrics.** Franklin pre-renders the math, so glyph positions are baked using the serif metrics.
  Sans glyphs are 0–7% narrower, so display equations came out 0–22px narrower across the twelve in
  `post1` and spacing loosened slightly. Nothing collided, and accents (`\bar{\mu}`), subscripts and
  superscripts all still land correctly.

Deliberately left serif: `KaTeX_Size1–4` (big delimiters, sums, integrals), `KaTeX_AMS` (blackboard
bold, e.g. `\mathbb{R}`), Caligraphic (`\mathcal{U}`), Fraktur, Script and Typewriter. Those are
distinct alphabets chosen for meaning, they have no sans equivalent in the shipped set, and `sfmath`
leaves them serif as well.

Variables remain italic. That is semantic rather than decorative — upright vs italic distinguishes an
operator from a variable — but the sans italic is a far lighter slant than the calligraphic Computer
Modern math italic it replaces, which is what read as over-italicised.

---

## 4. Phased plan

The ordering is forced by three hard constraints:

1. `_css/celeste.min.css` is compiled from `_sass/` **by hand**. CI never runs Sass. Any `_sass` edit
   ships as a no-op until the compiled file is regenerated and committed.
2. Several key overrides tie `franklin.css` on specificity and win **only** on load order. Reordering the
   two `<link>` tags in `head_mixin.html` silently reverts the typography.
3. `config.md` and CI changes govern whether anything deploys at all.

### Phase 0 — Make the work verifiable

Nothing else should merge until a branch push produces a green build, because from here every merge to
`main` publishes.

- [x] Added a build-only CI job: duplicate the Julia step under `on: pull_request` and
      `push: branches: ['**']`, with the deploy step gated to `if: github.ref == 'refs/heads/main'`.
- [x] Add `Sass` to `Project.toml` / `Manifest.toml` — it is **not currently a dependency**, so the
      compile command documented in `README.md` cannot run in a clean checkout.
- [x] Settle `_css/celeste.min.css.map`: it is tracked and deployed, but the documented compile command
      passes no `source_map_file`, so the next recompile either orphans it or leaves it describing the
      *old* sources — on the project whose central difficulty is tracing cascade fights. Either pass
      `source_map_file` on every compile, or delete the map, strip the trailing `sourceMappingURL`
      comment, and add `_css/*.map` to `ignore`.
- [x] Fix `CLAUDE.md:275`, which tells you to confirm the Actions build on a feature branch — something
      the repo currently cannot do.

### Phase 1 — Stop publishing what shouldn't be published

All of §1. Keep this isolated from content and CSS commits: these are the edits that can stop the site
publishing, so you want them cleanly revertible.

- [x] `config.md`: move `keep_path` inside the `+++` block; extend `ignore` with `CLAUDE.md`,
      `Manifest.toml`, `Project.toml`, `.vscode/`.
- [x] Delete `preview.html`.
- [x] Decide sitemap/robots ownership; delete the root copies if Franklin keeps generating them.
- [x] Resample `headshot.jpg`; add a 1200×630 `og:image`.

Do this before any canonical-URL work, since canonical URLs depend on which paths exist.

### Phase 2 — Content correctness (Markdown and frontmatter only, no CSS)

- [x] **`post1.md` defines σ as `E[(X-μ)²]` and then uses it as a standard deviation**, and flips the
      `N(·,·)` second-argument convention between sd and variance across the post. This is the one class
      of error a quant reader will certainly notice. *(Rated high; it is the most damaging content defect
      on the site.)*
- [ ] **`post2.md` was never content-reviewed by the audit.** Reading it: covariance is plain `Q` at :14
      but `\mathbf{Q}` at :16 and `\hat{\mathbf{Q}}` at :44; the shape parameter is `\Theta` at :34 and
      `\boldsymbol{\Theta}` at :45; and the uncertainty set `$\mathcal{U}$` introduced at :30 is never
      formally defined, so the robust counterpart at :45 arrives with no derivable link to it. Add one
      display line defining the set. Also fix the title/h1 casing mismatch (:2 vs :8).
- [ ] Add real `date` to both posts' frontmatter. **Nothing on the site carries a date** except an
      auto file-mtime that moves on every rebuild. This must land before any generated blog index.
- [ ] `research.md`: `###` → `##` (currently h1→h3 with no h2). Each `-\biblabel` entry renders as its
      own single-item `<ul>` — seven separate lists, not one. Fix the markdown so they form one list.
- [ ] `blog.md`: the hand-copied teaser headings have already drifted from the posts' own titles.
- [x] `index.md`: remove the nested `<div class="container">` at :9/:20 and the malformed `<img>` at :10;
      add `alt`. **The container removal must land in the same commit as neutralising
      `.franklin-content img {width:70%; padding-left:10%}` at `franklin.css:261-265`** — that nested
      container is the only thing currently activating the `width:auto` override, so removing one without
      the other inflates the headshot to 70% width.
- [ ] Add `aria-label` to the four social anchors — they currently have **no accessible name at all**
      (icon-only links; a Level A failure).
- [ ] Remove boilerplate `tags = ["syntax","code","image"]` (they generate three meaningless `/tag/`
      pages) and `hascode = true` from `research.md:3` / `presentations.md:3` (loads highlight.js for
      pages with no code — there is not one fenced code block on the entire site).
- [ ] Fix link text: seven links labelled "here", two labelled "Read More".
- [ ] Remove the stale `date = Date(2019,3,22)` stamping the publications page.

### Phase 3 — The CSS refit — **APPLIED**

Compiled once with Sass.jl and verified in headless Chrome against the `optimize()` build, not by
reasoning about specificity. Measured results below are computed styles from a real browser.

- [x] Token set in `_sass/utilities/_variables.scss` as CSS custom properties on `:root`, with the SCSS
      variables kept as thin aliases so existing partials compile unchanged. Safe because nothing in
      `_sass/` passes a token to a SCSS colour function — verified before the switch.
- [x] Reclaim layer in `_sass/adjust.scss`, every rule naming what it beats.
- [x] **Type scale restored.** Measured: h1/h2/h3 now **29.4 / 24.5 / 20.4px**, was a flat 24/22/20
      (an h2:h3 ratio of 1.09 — no hierarchy at all).
- [x] **Leading restored.** Measured **28.05px** (unitless 1.65), was `1.35em` frozen at 22.95px.
- [x] **Measure.** Content column 629px = 34rem text + two 1.5rem gutters. `max-width` includes padding
      under `border-box`, so the padding is added back explicitly — otherwise the real measure would
      have been ~62 characters, not ~68.
- [x] **Display math fixed — but not the bug the audit described.** The equations were not being clipped;
      `franklin.css:284` sets `white-space: normal`, so KaTeX was **breaking equations mid-expression**
      to fit. Measured at 320px: three equations were being forced to exactly the 268px container width.
      With `white-space: nowrap` restored they keep their natural width (post2's MVO one-liner is 300px)
      and scroll. No fade mask — a four-layer scroll shadow for three equations was judged overbuilt.
- [x] **Equation numbering suppressed.** Every display equation was auto-numbered and nothing referenced
      a number; 12 of them in post1 alone. One rule, reversible by deleting it.
- [x] **Footer fixed at source.** `text-transform: lowercase` removed from `_sass/base/_global.scss` —
      it was rendering the author's own name as "cc by-sa 4.0 david islip". Contrast **2.32:1 → 7.54:1**
      for text and **2.53:1 → 7.54:1** for links.
- [x] **Focus styles added.** There were none anywhere in `_sass/`. Also fixed the cause: the reveal
      animation's `overflow: hidden` sat on the `<li>` and clipped the focus ring of the `<a>` inside, and
      its `:focus` was on the non-focusable `<li>` so it never fired. Now opacity-based with
      `:focus-within`, which clips nothing.
- [x] **Link underlines restored.** Measured: link vs body text is **1.74:1** and citations **1.47:1** —
      far below the 3:1 that would let colour alone mark a link. The underline is load-bearing for
      WCAG 1.4.1, not decoration.
- [x] **Citations get their own accent.** `\citet` / `\biblabel` / `.eqref` render in `--color-mark`
      rather than the CSS keyword `green`, and are distinct from prose links.
- [x] **Nav wrap fixed.** Measured **one row at every width from 1280px down to 320px**, no nav overflow
      and no horizontal page scroll on any page. The DI chip stays, and gains a 44px touch target via a
      transparent border that does not enlarge the visible disc.
- [x] `prefers-reduced-motion` honoured — nothing in `_sass/` did before.
- [x] Dead partials deleted: `_pagination.scss`, `_message.scss`, `_syntax-highlighting.scss` (a Rouge
      theme; Franklin uses highlight.js), and the `.highlight`/`.lineno` block in `_code.scss`. All
      confirmed to match zero elements in the build before removal.
- [x] Breakpoints consolidated to one `$bp-mobile: 40em` and a `mobile()` mixin.
- [x] Load-order dependency recorded at the top of `_sass/adjust.scss`.
- [x] `_css/celeste.min.css` recompiled — 9,673 → 11,157 bytes.

**Deliberately not written:** styling for `<pre>`, `<code>`, `<table>`, `<blockquote>` and `<hr>`. A
full build emits **zero** of all five across all ten pages, so roughly a third of the proposed refit
would have been rules for elements that do not exist. Add them when content needs them.

**Caught by the adversarial review of the refit, and fixed:**

- **`.social-icons a` was clobbered** — the new `.franklin-content a` rule ties it at (0,1,1) and wins on
  source order, so the four home-page icons rendered underlined and in link blue instead of brand navy.
  A real regression introduced by the refit. Now explicitly exempted, next to the TOC and heading-anchor
  guards.
- The page footer was still rendering in **Arial** — the `@extend` reclaims colour and spacing but never
  declared `font-family`, so `franklin.css:64` survived untouched on every page.
- The tabular-numerals rule was **inert twice over**: `lining` is not a CSS keyword (it is `lining-nums`,
  and the whole declaration is dropped if you get it wrong), and the selector was nested inside its own
  parent, compiling to `.franklin-content .franklin-content .page-foot`.
- `<strong>` was `#303030`, **lighter than the body text around it** (luminance 0.0273 vs 0.0208) — most
  visible on every author name in `research.md`. `<b>` on the home page rendered a different colour again.
  Both now point at `--color-heading`.
- The **nav focus ring was clipped by the viewport**: nav links sit at y=3 under the 3px body top border,
  so a 2px ring at a 2px offset drew at y=−1. 4px of headroom on the nav list.
- The **chip's focus outline was invisible**: at `outline-offset: -0.45rem` against a `0.55rem`
  transparent border, the white ring landed on white paper outside the disc. The offset must equal the
  border width exactly.
- The **150px floated headshot stranded 4px-wide lines** below 375px. Unfloated and centred on mobile.
- The global `a:hover { color: #2d5a8e }` became **unreachable** — every anchor is inside `.nav-main` or
  `.franklin-content`, both of which now win. Removed rather than left as a lie.
- `_sass/pages/_posts.scss` deleted too: `.page`, `.post`, `.page-title`, `.post-title` and `.post-date`
  match zero elements (the 10 `class="page-foot"` hits are a different class).

**Known and accepted:** the DI chip's touch target is 41px on desktop and 34px on phones, because it is
sized in `em` and tracks the nav type scale. That clears WCAG 2.2 AA (SC 2.5.8, 24×24) but not AAA
(SC 2.5.5, 44×44). The code comment now states the measured figures rather than an aspirational 44px.

> **Dark mode is deliberately not in this phase.** It is priced in the token table as a variable swap,
> but the colours that actually paint content live in `franklin.css`: 15 distinct hardcoded literals
> across 37 declarations (`lightgrey` ×3, `green` ×2, `#a6a2a0` ×2, `#004de6`, `black` table borders,
> `hsl(0,0%,94%)`, …), none of them custom properties, all at `.franklin-content` specificity. Swapping
> tokens alone produces a near-black page with lightgrey heading rules, a near-white blockquote and green
> citation links — worse than no dark mode. Ship the light refit first; treat dark mode as its own phase
> with a full franklin.css reclaim inventory, `color-scheme: dark light` on `:root`, and a swap to the
> already-vendored `github-dark.min.css`.

### Phase 4 — Additive structure and content — **APPLIED except the CV and contact page**

- [x] `rel=canonical` + per-page `og:url` via `hfun_canonical` in `utils.jl`. `og:url` was hard-coded to
      the homepage on all seven pages and there was no canonical anywhere. Emits the **directory** form
      (`/research/`), matching every internal link on the site, with the home page as the bare domain
      and `404.html` left alone because `url_curpage` honours `keep_path`.
- [x] RSS autodiscovery fixed: `head.html` advertised `/feed`, Franklin writes `/feed.xml` — every page
      linked a 404 feed.
- [x] `<main>` landmark and skip-to-content link. Franklin's content `<div>` is not ours to change, so
      `<main>` wraps it from `head.html` and closes in `foot.html`.
- [x] `aria-label` on the nav, an accessible name on the DI chip, and `aria-current="page"` via
      `{{ispage}}` — verified exactly one per page, with blog posts marking Blog as current. Styled with
      a persistent underline, not colour alone.
- [x] Font Awesome. Worse than recorded: the local copy was **v4.7.0**, its `@font-face` pointed at a
      `fonts/` directory that does not exist, *and* the markup uses `fab`/`fas`, which are v5+ classes
      v4.7 does not define. It 404'd on every page while doing nothing. Deleted; the working v6.4.2 CDN
      copy moved out of the page body into `<head>` behind a `hasicons` gate so it loads only where used.
      Added `preconnect` and `display=swap` for Google Fonts.
- [x] JSON-LD: `affiliation` and `alumniOf` are now Organization / CollegeOrUniversity objects, plus
      `worksFor` and `knowsAbout`.
- [x] `404.md` rewritten — it was a stack of styled `<div>`s with no heading, so a screen reader
      announced an empty document, and its only exit was a link labelled "Click here".
- [x] Home page first screen: it opened by presenting him as a Toronto Ph.D. student, with the actual
      role at Balyasny buried in the last sentence of paragraph two.
- [x] **`research.md`: the Ph.D. thesis added, and two citation errors corrected.** See below.

- [ ] **A CV page** — parked at the author's request.
- [ ] **A contact route** — parked at the author's request.

**The thesis.** Found and verified three times independently (the researcher, an adversarial verifier,
and a direct fetch of the repository API):

> **New Applications of Optimization Oracles with a Lens Towards Finance**
> Islip, David Ryan · Ph.D. · Mechanical and Industrial Engineering, University of Toronto · June 2025
> Advisor: Kwon, Roy H · <https://hdl.handle.net/1807/145156> · free PDF, CC BY 4.0

Link the `hdl.handle.net` handle, not a `tspace.library.utoronto.ca` URL — TSpace has migrated and now
302-redirects to `utoronto.scholaris.ca`. The handle is the stable identifier.

**Two citation errors on the publications page, both confirmed against Crossref directly:**

- The EJOR paper has **three** authors — David Islip, Roy H. Kwon and **Seongmoon Kim**. The page
  credited only "Islip and Kwon", dropping a co-author.
- The JOGO paper was published as "**Stochastic** red-blue set covering: a decomposition approach". The
  page had "**Two-Stage** Stochastic Red-Blue Set Covering" — those words are not in the published title.

**Open-access preprints: none exist.** All six published papers are closed, confirmed independently by
OpenAlex (`oa_status: closed`) and Semantic Scholar (`CLOSED`). An exhaustive arXiv author search
returns exactly one paper — 2502.05349, already linked. A web search claimed arXiv 2605.07089 was the
JOTA preprint; it is **not** — different authors entirely (Mori, Ikeda, Tamura, Takano). Do not link it.
The thesis is the free route to chapters 1, 2 and 4.

**Publication years — resolved, both moved to the issue year.** The EJOR paper is now 2025 (Crossref
`published-print` 2025-05, volume 322 issue 3) and the Engineering Economist paper is 2021
(`published-print` 2021-04-03, volume 66 issue 2). Both previously carried the online-first year, which
contradicted the volume and issue printed beside it — `322(3), 1045–1058, 2024` cannot be right when
that issue belongs to 2025. Reverse-chronological ordering of the Published list is unaffected.

The `\biblabel` keys (`islip24`, `islip20`) were deliberately left as they are: they are opaque anchor
ids, nothing on the site cites them, and renaming would change URL fragments for no benefit.

**Generated blog index — attempted, tested, and rejected.** A working `{{bloglist}}` was built and run.
It was dropped because of a failure mode found only by testing it: with one malformed post, `/blog/`
**is never written at all** — the deployed page would 404 — and `optimize()` still exits 0. Today's
hand-written index degrades far better: a broken post breaks only its own page. Drift between the index
and the posts is the lesser problem with two posts, and it is now corrected. Revisit if the blog grows.
(This is also what prompted the CI build assertions — see Phase 0.)

### Phase 5 — Housekeeping — **APPLIED** (except the CI pins)

- [x] Deleted the dead `- master` trigger from `Deploy.yml` — no `master` branch exists on the remote,
      and two branches deploying to one `gh-pages` is a race waiting to happen.
- [x] Deleted `.gitlab-ci.yml`. It pinned `image: julia:1.6` against a Manifest that requires 1.12.1,
      so it could not have run.
- [x] Deleted 164 KB of unreferenced assets: `website_headshot.jfif`, `rndimg.jpg`, `hamburger.svg`
      (there is no mobile nav for it to belong to) and all of `_assets/scripts/`. Verified referenced by
      nothing outside the docs that describe them, and verified after the build that every
      `/assets/...` path still appearing in a built page resolves.
- [x] Emptied `utils.jl` of Franklin's three template examples (`hfun_bar`, `hfun_m1fill`, `lx_baz`),
      none of which was called from any page. Kept as a documented stub — Phase 4 adds a real
      `hfun_` for canonical URLs.
- [x] Replaced the template `README.md`, which was still titled "Celeste Template" and presented the
      repo as someone else's theme.
- [x] Added `[compat]` to `Project.toml` and re-resolved. No dependency version moved; the only
      Manifest change is the project hash.

- [x] **CI action pins — done.** `checkout@v2`→`v4`, `setup-python@v2`→`v5`, `setup-julia@v1`→`v2`,
      `github-pages-deploy-action@releases/v3`→`v4`. Every step had been emitting a Node 20 deprecation
      notice and running forced on Node 24.

      Two things made this more than a version bump:

      **The deploy action renamed all its inputs in v4** — lower case, and `GITHUB_TOKEN` became
      `token`. v4 silently ignores the v3 spellings, so the inputs had to change in the same commit as
      the version or the deploy would have failed with no useful message.

      **Python is pinned to 3.11, not latest, on purpose.** It exists solely for minification: Franklin
      shells out to `css_html_js_minify` and pip-installs it itself if the import fails
      (`Franklin/src/build.jl`), which is why there is no explicit pip step in the workflow. That
      package was last released in **2018** and its classifiers stop at Python 3.6. It ships a
      pure-Python wheel so pip runs no build step, but 3.12 removed `distutils` and the package predates
      that by six years. 3.11 is supported until Oct 2027. If it ever does break, Franklin does not
      fail — it warns `Will not minify` and produces a larger site — so the assert step now greps for
      exactly that string and fails the run, because a plain `@warn` is not a "Franklin Warning" and the
      other check would miss it.

**Not done, deliberately — the "vendored libs are deployed but never requested" item.**

Re-measured rather than taken on trust, and the picture is different from what the audit described:

| | size | requested by |
| --- | --- | --- |
| `_libs/highlight/` | **1.2 MB** | **0 pages** |
| `_libs/katex/katex.min.js` | 268 KB | 0 pages in production |
| `_libs/katex/fonts/` | 1.2 MB | every page with math — **required** |

highlight.js is now orphaned outright: removing `hascode` in Phase 2 means no page inserts
`head_highlight.html` in *either* `serve()` or `optimize()` mode. That is larger than the item the plan
originally flagged.

Both were left in place anyway. Neither costs a visitor anything — no browser ever requests them — so
this is branch weight, not page weight. Against that, `ignore`-ing them creates a real footgun: the
first time anyone adds a fenced code block and sets `hascode = true`, or runs `serve()` on a page with
math, they get silent 404s on assets that are sitting right there in the repo. Deleting working
infrastructure to save bytes nobody downloads is the wrong trade.

---

## Appendix A — The one workflow trap

**`serve()` and `optimize()` render math differently.** `FD_ENV[:PRERENDER]` is set only by `optimize()`.
Locally, `serve()` leaves `\(...\)` in the HTML and KaTeX renders it client-side after first paint. In
production, `optimize()` renders it server-side and strips the scripts entirely.

Any change to `.katex-display` geometry, the `::after` equation counter, or the bleed track **must be
verified against `optimize()` output in `__site/`, not against `serve()`.**

---

## Appendix B — Claims that did not survive

Recorded so they don't get re-raised. Each was killed by a verifier that checked the actual artifact.

| Claim | Why it's wrong |
| --- | --- |
| *"`blog.md` serves raw TeX because it declares no `hasmath`"* — proposed as the highest-value fix in the audit | **False.** Franklin auto-sets `hasmath` (`automath` defaults true). Verified: `__site/blog/index.html` loads `katex.min.css`, `katex.min.js` and `auto-render.min.js`; `__site/research/index.html` (no math) loads none. The live page renders correctly. The frontmatter edit is a no-op. |
| *"KaTeX renders after first paint, so equation numbers will reflow"* | **False in production.** `optimize()` prerenders and strips the scripts — the deployed `post1` page has 97 `katex` class hits and zero `renderMathInElement`. |
| *"`post2.md` ends on an empty 'Google Colab Notebook' heading"* | **False.** `wc -l` reports 54 because the last line has no trailing newline. Line 55 is a real paragraph with the notebook link. |
| *"Deprecated CI actions mean deploys will stop"* | **False.** Every run is green on `ubuntu-24.04`; `python-3.8.18-linux-24.04-x64` resolves fine; `gh-pages` matches `main` HEAD. Warning-only. Kept in Phase 5 at correct priority. |
| *"No PR CI means a broken build reaches production"* | **Backwards.** Build and deploy are separate steps with default `if: success()`, so a failed `optimize()` blocks the deploy and `gh-pages` keeps serving the last good build. Commit `a8bacfc` is this exact scenario, caught. A build-only job is still worth adding (Phase 0) — for *feedback latency*, not correctness. The proposed `lychee` link-check gate would be actively harmful: every DOI in `research.md` resolves to Springer/Elsevier/T&F, which routinely 403 automated checkers. |
| *"404.md pushes the recovery link below the fold"* | **Mis-derived.** The arithmetic assumed 60px per `<br>`; the inherited line-height is a fixed ~20px, so the link lands around y=400px. The real defect is different and smaller: the 40px text renders in 20px line boxes, so wrapped lines collide. |

---

## Appendix C — What was checked and found correct

Worth recording, since these look like problems and aren't:

- All internal nav targets and all five PDF asset links resolve, with matching case.
- The reference-style `[here]` link on `presentations.md:39` works — Franklin's `find_and_fix_md_links`
  handles what Julia's Markdown parser does not. It's a working link with a poor label, not a broken one.
- Every `\citet` key in `post1.md` has a matching `\biblabel`.
- KaTeX output is fully accessible: the deployed `post1` page carries 95 `katex-mathml` spans against 95
  `aria-hidden="true"` `katex-html` spans, so formulas are announced exactly once from MathML.
- Contrast is mostly better than `_variables.scss` suggests, because the variables are dead: body text
  renders at 10.86:1, nav at 11.73:1, and the link colour that actually renders (`#004de6`) is 6.55:1.
  The designed `$link-color: #4a7ab5` would have been 4.43:1 — a fail — had it ever applied.
- The `<div>` structure in `index.md` is balanced across the two `~~~` blocks.
- `_css/celeste.min.css` is genuinely in sync with `_sass/` — verified by recompiling and diffing, not
  just by comparing commit dates. **But it was produced by a different minifier than Sass.jl v0.2.0
  emits**: the committed file has `#0a3b76`/`red`/`rgba(0,0,0,0)`/`@media(max-width`, a fresh Sass.jl
  compile has `#0A3b76`/`#f00`/`transparent`/`@media (max-width`. Semantically identical. Expect the
  Phase 3 recompile to show a large, meaningless diff on top of the real changes — don't read it as
  breakage, and don't try to preserve the old formatting.
