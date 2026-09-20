# CLAUDE.md — AI Assistant Guide for davidislip.github.io

This file provides guidance for AI assistants (and developers) working on this codebase.

## Overview

This is a **Franklin.jl** static site — a Julia-based static site generator optimized for scientific and mathematical content. It uses the **Celeste** theme and is deployed to **GitHub Pages** from the `main` branch. The site is an academic portfolio for David Islip (quantitative researcher / Ph.D., Operations Research, University of Toronto), containing a bio, research publications, blog posts, and presentations.

- **Live site**: https://davidislip.github.io/
- **Framework**: [Franklin.jl](https://franklinjl.org/)
- **Deploy target**: `gh-pages` branch (auto-managed by CI — never push there manually)
- **Julia version**: Latest stable (pinned in `Manifest.toml` at 1.12.1)

---

## Repository Structure

```
.github/workflows/      # GitHub Actions CI/CD (Deploy.yml)
_assets/                # Static files served under /assets/
  pdfs/                 # Presentation PDFs
  scripts/              # Julia scripts for content generation
  *.jpg, *.png, etc.    # Images and favicons
_css/                   # Compiled CSS output — DO NOT EDIT DIRECTLY
_layout/                # HTML templates (head, header, foot, page_foot, tag)
_libs/                  # Vendored third-party JS/CSS (highlight.js, KaTeX)
_rss/                   # RSS feed XML templates (head.xml, item.xml)
_sass/                  # SCSS source files — EDIT THESE for styling changes
  base/                 # Normalize, global reset, layout grid, typography
  components/           # Navigation, code blocks
  pages/                # Landing page styles
  utilities/            # Variables (design tokens), mixins, animations
  adjust.scss           # The franklin.css reclaim layer — see Styling below
blogs/                  # Blog post Markdown files (post1.md, post2.md, …)
config.md               # Franklin global config: metadata, RSS, LaTeX macros
index.md                # Home page
blog.md                 # Blog index/landing (hand-written; see note below)
research.md             # Publications, plus the Ph.D. thesis
presentations.md        # Conference talks and slides
404.md                  # Custom 404 error page
utils.jl                # Custom Franklin HTML/LaTeX extension functions
preview.html            # LOCAL style specimen — not published (in `ignore`)
plan.md                 # Improvement plan / audit record — not published
Project.toml            # Julia package dependencies (incl. Sass, for the CSS build)
Manifest.toml           # Locked Julia package versions
```

Build output (`__site/`) is git-ignored. The `google599763433934e4da.html` file is a Google Search Console verification file; it must be served at that exact URL, which only works because it is listed in `keep_path` in `config.md` — see [Franklin config](#franklin-config-configmd).

---

## Franklin config (`config.md`)

Everything Franklin reads must sit **inside the `+++` block**. Anything below the closing
`+++` is page body content and is silently ignored as configuration — this is a trap the repo
has already fallen into once (`keep_path` sat below it and did nothing for months).

| Setting | Why it is there |
| --- | --- |
| `ignore` | Files/directories Franklin must not copy or render. Currently: `node_modules/`, `package.json`, `package-lock.json`, `CLAUDE.md`, `plan.md`, `preview.html`, `Project.toml`, `Manifest.toml`, `.vscode/`, `_sass/`. Without these, Franklin publishes them — e.g. `CLAUDE.md` becomes a public page at `/CLAUDE/`, and all of `_sass/` is served under `/_sass/`. `README.md` and `LICENSE.md` are ignored by default; nothing else is. |
| `keep_path` | Paths served verbatim instead of being converted to `<name>/index.html`. Only `google599763433934e4da.html` needs this — Google Search Console requests that exact URL and GitHub Pages does not fall back from `/x.html` to `/x/index.html`. |
| `generate_rss` | On. Franklin writes `/feed.xml`. |

**Franklin owns `sitemap.xml` and `robots.txt`.** `generate_sitemap` and `generate_robots`
default to `true`, so Franklin deletes and rewrites both on every build. Do not add
hand-maintained copies at the repo root — they will not reach production. To take manual
control, set those two variables to `false` *and* add the files to `keep_path`.

`package.json` / `package-lock.json` do not exist in the repo; CI creates them in the root
when it runs `npm install highlight.js` just before `optimize()`, which is why they are in
`ignore`.

---

## Frontmatter Conventions

Franklin uses two frontmatter styles depending on context:

### Root pages (`@def` syntax)
Used for `index.md`, `research.md`, `presentations.md`, `blog.md`, `404.md`:

```
@def title = "Page Title"
@def tags = ["tag1", "tag2"]
@def date = Date(2024, 1, 1)
@def hascode = true
@def rss = "Single-line RSS description — no newlines allowed"
@def rss_title = "Optional RSS title override"
@def rss_pubdate = Date(2024, 1, 1)
```

### Blog posts (`+++` block)
Used for files under `blogs/`:

```
+++
title = "Post Title"
hasmath = true
date = Date(2025, 1, 28)
rss_pubdate = Date(2025, 1, 28)
+++
```

> **This block is evaluated as Julia, not parsed as TOML** — despite looking like
> TOML and being described as such for a long time. The difference bites on dates:
> `date = 2025-01-28` is not a date, it is the arithmetic expression `2025 - 1 - 28`,
> which silently evaluates to the integer `1996`. No error is raised; the RSS
> `pubDate` just quietly falls back to the build time. Always use the Julia
> constructor `Date(y, m, d)`.

**Key rules:**
- `rss` value must be a single line (no newlines)
- `hascode = true` enables syntax highlighting for that page
- `date` uses Julia `Date(year, month, day)` constructor syntax
- `mintoclevel` controls the minimum heading depth shown in the table of contents (global default: `2`)

---

## Content Authoring

### Math (KaTeX)
- Inline: `$...$`
- Block: `$$...$$`
- Global LaTeX commands defined in `config.md`:
  - `\R` → `\mathbb{R}` (real numbers)
  - `\scal{x}` → `\langle x \rangle` (inner product)
- Add new global commands to `config.md` under the `\newcommand` section

### Raw HTML
Embed raw HTML using `~~~` delimiters:

```
~~~
<div class="my-class">
  <p>Raw HTML here</p>
</div>
~~~
```

### Citations and Bibliography
- In-text citation: `\citet{key}` — renders as a hyperlink to the bibliography entry
- Bibliography entry: `\biblabel{key}{AuthorShort} **AuthorFull**, [Title](url), *Journal*, **vol**, pages, year.`

### Code Blocks
Standard Markdown fenced blocks; language is auto-detected by highlight.js:

````
```julia
x = 1 + 1
```
````

---

## Styling (SCSS)

**Always edit `_sass/` source files, never `_css/` directly.**

After modifying SCSS, recompile with Julia Sass from the `_sass/` directory:

```julia
using Pkg; Pkg.activate("..")
using Sass
Sass.compile_file("style.scss", "../_css/celeste.min.css"; output_style = Sass.compressed)
```

**Commit the regenerated `_css/celeste.min.css` in the same commit as the `_sass/` change.**
CI never runs Sass, so a `_sass/` edit without the recompiled artifact ships as a no-op.
No source map is generated or committed.

### The cascade problem, and `adjust.scss`

**This is the single most important thing to understand before editing any CSS here.**

`_layout/head_mixin.html` loads `/css/franklin.css` *before* `/css/celeste.min.css`. Franklin
wraps all page content in `<div class="franklin-content">`, so franklin.css's class-scoped
rules (specificity `0,1,1`) beat Celeste's bare element rules (`0,0,1`) **regardless of load
order**. A plain `h1 { … }` in `_sass/base/_typography.scss` will not reach the browser.

`_sass/adjust.scss` exists to reclaim those rules at `.franklin-content`-scoped specificity,
and it is where franklin.css overrides belong. Two rules for editing it:

1. Write selectors at `.franklin-content`-scope or higher, and name the franklin.css rule you
   are beating.
2. Where the two tie on specificity, adjust.scss wins **only** because celeste.min.css loads
   second and `@import "adjust"` is last in `style.scss`. **Do not reorder those two `<link>`
   tags** — the typography silently reverts.

Two traps worth knowing:

- `.katex { font-size: 1em !important }` in franklin.css. Any KaTeX sizing must be written at
  `.franklin-content .katex` with `!important` or it does nothing.
- `.franklin-content { max-width: … }` includes its padding, because `* { box-sizing:
  border-box }`. The gutters are added back explicitly in adjust.scss.

### Design tokens (`_sass/utilities/_variables.scss`)

Tokens are **CSS custom properties on `:root`**, so a future dark theme is an additive
`@media` block rather than a recompile. The SCSS variables are thin aliases kept so the older
partials still compile — never pass one to a SCSS colour function (`darken`, `mix`, …), which
cannot evaluate a `var()`.

| Token | Value | Usage |
| --- | --- | --- |
| `--color-heading` | `#16181d` | h1–h6, `<strong>`, `<b>` — 17.76:1 |
| `--color-text` | `#24272c` | Body copy; KaTeX inherits it — 14.98:1 |
| `--color-muted` | `#4e555e` | Dates, page footer — 7.54:1 |
| `--color-brand` | `#0a3b76` | Structure only: top border, nav "DI" chip, social icons |
| `--color-link` | `#0f4c8c` | Every interactive thing — 8.63:1 |
| `--color-mark` | `#7a1f2b` | Journal apparatus: `\citet`, `\biblabel`, `.eqref` |
| `--color-rule-strong` / `--color-rule` | `#7c8fa8` / `#c7d3e2` | Meaningful vs decorative rules |
| `--measure` / `--measure-wide` | `34rem` / `46rem` | Prose column; bleed track for display math |
| `--line-height` | `1.65` | Unitless — franklin.css's `1.35em` freezes to an absolute px |
| `--font-body` / `--font-mono` | Source Sans Pro / Source Code Pro | Mono is **metadata only**, never prose |
| `$bp-mobile` | `40em` | The one breakpoint; use the `mobile()` mixin |

> Link colour against body text is 1.74:1 and `--color-mark` is 1.47:1 — far below the 3:1 that
> would let colour alone mark a link. **The underline in adjust.scss is load-bearing for WCAG
> 1.4.1, not decoration.**

### Math typeface

KaTeX is remapped to `KaTeX_SansSerif` (Computer Modern Sans, the `sfmath` look) so formulas
match the sans body. Big delimiters, blackboard bold (`\mathbb`), Caligraphic, Fraktur and
Typewriter are deliberately left serif — distinct alphabets chosen for meaning, with no sans
equivalent in the shipped set.

### Additional stylesheets
- `_css/franklin.css` — Franklin.jl default styles; read before overriding
- Font Awesome 6.4.2 from cdnjs, loaded **only on pages that set `hasicons = true`**
  (currently just the home page). There is no local copy — the one that used to be here was
  v4.7.0, 404'd on every page, and predated the `fab`/`fas` classes the markup uses.

---

## Development Workflow

### Prerequisites
- Julia (latest stable)
- The project environment includes Franklin, NodeJS, and Sass packages

### Local preview with live reload
```julia
using Pkg; Pkg.activate(".")
using Franklin
serve()
# Visit http://localhost:8000
```

Franklin watches for file changes and reloads automatically.

### Full optimized build (mirrors CI)
```julia
using Pkg; Pkg.activate("."); Pkg.instantiate()
using NodeJS; run(`$(npm_cmd()) install highlight.js`)
using Franklin; optimize()
# Output: __site/
```

`optimize()` runs Markdown → HTML conversion, KaTeX pre-rendering, syntax highlighting, and CSS/HTML minification. The `__site/` directory is git-ignored.

---

## Adding Content

### New blog post
1. Create `blogs/postN.md`. The `+++` block is **Julia, not TOML** — use `Date(y, m, d)`:
   ```
   +++
   title = "Your Post Title"
   hasmath = true
   date = Date(2026, 5, 1)
   rss_pubdate = Date(2026, 5, 1)
   rss = "One-line summary. No newlines."
   description = "One-line summary. No newlines."
   +++
   # Your Post Title
   Content here...
   ```
   Without `date`, the RSS `pubDate` silently falls back to the CI build time.
2. Add a link and summary to `blog.md`. **That index is hand-written and will drift.** A
   generated `{{bloglist}}` was built and rejected: with one malformed post, `/blog/` is never
   written at all and `optimize()` still exits 0, so the page would 404 in production. The
   hand-written version degrades better — a broken post breaks only its own page. Revisit if
   the blog grows.

### New top-level page
1. Create `pagename.md` at the repository root with `@def title = "..."` frontmatter
2. Add a nav link in `_layout/header.html`
3. If the page is repo-internal and should *not* be published, add it to `ignore` in `config.md`

### New assets
- Images: place in `_assets/`, reference in Markdown as `/assets/filename.jpg`
- PDFs: place in `_assets/pdfs/`, reference as `/assets/pdfs/filename.pdf`
- Keep `_assets/` organized; do not place assets at the root

---

## CI/CD and Deployment

### GitHub Actions (`.github/workflows/Deploy.yml`)

**Builds on every branch; deploys only from `main`.** Push a feature branch and the build runs
in full — so a Julia error in `utils.jl`, a malformed `+++` block or a broken template is
caught before it can reach the live site. The deploy step is gated by
`if: github.ref == 'refs/heads/main'`.

1. Checkout (`actions/checkout@v7`)
2. Install Python 3.11 — **for minification only**, see below
3. Install latest stable Julia (`julia-actions/setup-julia@v3`)
4. `npm install highlight.js`, `Pkg.instantiate()`, then `optimize()`, teed to `build.log`
5. **Assert the build actually produced the site** — see below
6. Deploy `__site/` to `gh-pages` (`JamesIves/github-pages-deploy-action@v4`), main only

**Why step 5 exists.** `optimize()` returns 0 even when a page fails to convert — it emits a
`Franklin Warning` and simply writes no output for that page. A job that checks only the exit
code will happily deploy a site with a missing page. The assert step therefore fails the run
if the log contains `Franklin Warning`, if any expected page is missing or empty, or if
anything repo-internal leaked into `__site/`.

**Why Python is pinned to 3.11 and not latest.** It exists solely for minification. Franklin
shells out to `css_html_js_minify` and pip-installs it itself when the import fails
(`Franklin/src/build.jl`), which is why there is no explicit pip step. That package was last
released in **2018** and its classifiers stop at Python 3.6; 3.12 removed `distutils`. If
minification ever does break, Franklin does not fail — it warns `Will not minify` and ships a
larger site — so the assert step greps for that string too, because a plain `@warn` is not a
`Franklin Warning`.

**Never manually push to `gh-pages`** — it is fully managed by CI.

> Local builds use `minify=false`; production minifies and **strips attribute quotes**. If you
> grep the live HTML for `rel="canonical"` you will find nothing — it is served as
> `rel=canonical`. Match quote-agnostically when checking production.

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `config.md` | Global site metadata, RSS config, global LaTeX macros |
| `utils.jl` | Custom Franklin extension functions (`hfun_canonical`) |
| `_layout/head.html` | `<head>`: meta, canonical, Open Graph, JSON-LD; opens `<main>` |
| `_layout/head_mixin.html` | Stylesheet links — **load order is load-bearing** |
| `_layout/header.html` | Nav markup, `aria-current` via `{{ispage}}` |
| `_layout/foot.html` | Closes `<main>`; conditional KaTeX/highlight includes |
| `_layout/page_foot.html` | The footer Franklin injects into every page |
| `_sass/utilities/_variables.scss` | Design tokens as CSS custom properties |
| `_sass/adjust.scss` | **The franklin.css reclaim layer — read this first** |
| `.github/workflows/Deploy.yml` | CI: builds every branch, deploys `main`, asserts output |
| `plan.md` | Improvement plan and audit record; what is done and what is not |

---

## Custom Franklin Extensions (`utils.jl`)

Franklin allows custom Julia functions for HTML generation and LaTeX command handling:

- **`hfun_*(vname)`** — HTML functions callable in Markdown as `{{functionname arg}}`
- **`lx_*(com, _)`** — Custom LaTeX-style commands callable as `\commandname{arg}`

Current functions in `utils.jl`:

- `hfun_canonical()` — the current page's absolute URL, in the **directory** form the site's own
  links use (`/research/`, not `/research/index.html`), with the home page as the bare domain.
  Used from `_layout/head.html` as `{{canonical}}` for both `rel=canonical` and `og:url`.
  Derives from Franklin's per-page `fd_url`, which already honours `keep_path` — that is why
  `404.html` stays `404.html` rather than becoming `/404/`.

Franklin's three template examples (`hfun_bar`, `hfun_m1fill`, `lx_baz`) were removed; none was
called from any page.

Add new custom functions here when Franklin's built-in syntax is insufficient. A Julia error in
this file fails the build, so push to a branch first and let CI build it.

---

## Git Workflow

- **Feature branches**: develop changes on named branches (e.g., `claude/feature-name`).
  Pushing one runs a full build with no deploy — use it, especially for anything touching
  `utils.jl`, `_layout/`, `config.md` or CI.
- **Production**: merge to `main` — this triggers the deploy pipeline automatically
- **`gh-pages`**: auto-generated deploy target; never commit here directly
- There is no `master` branch; the CI trigger for it was removed.

### Commit and push
```bash
git add <specific files>
git commit -m "Descriptive commit message"
git push -u origin <branch-name>
```

---

## Verification Checklist

After making changes:
- [ ] Run `serve()` locally and confirm the page renders at `http://localhost:8000`
- [ ] Verify math (KaTeX) renders correctly
- [ ] Verify code blocks have syntax highlighting (requires `@def hascode = true`)
- [ ] Check all internal links resolve
- [ ] Confirm RSS frontmatter values are single-line strings
- [ ] Run a full `optimize()` and inspect `__site/` — `serve()` does **not** pre-render KaTeX,
      so math layout must be checked against an `optimize()` build
- [ ] Confirm nothing repo-internal leaked into `__site/` (see `ignore` in `config.md`)
- [ ] **Push to a feature branch and let CI build it before merging.** Every branch builds; only
      `main` deploys. A failed build cannot break the live site — the deploy step is separate and
      runs only on success, so `gh-pages` keeps serving the last good build.
- [ ] If you changed `_sass/`, recompile and commit `_css/celeste.min.css` **in the same commit**
