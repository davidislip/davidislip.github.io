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
_layout/                # HTML templates (head, foot, nav, page, post wrappers)
_libs/                  # Vendored third-party JS (highlight.js, KaTeX)
_rss/                   # RSS feed XML templates (head.xml, item.xml)
_sass/                  # SCSS source files — EDIT THESE for styling changes
  base/                 # Normalize, global reset, layout grid, typography
  components/           # Navigation, pagination, code blocks, message boxes
  pages/                # Landing page and blog post page styles
  utilities/            # Variables, mixins, syntax highlighting, animations
blogs/                  # Blog post Markdown files (post1.md, post2.md, …)
config.md               # Franklin global config: metadata, RSS, LaTeX macros
index.md                # Home page
blog.md                 # Blog index/landing
research.md             # Publications list (published, submitted, in progress)
presentations.md        # Conference talks and slides
404.md                  # Custom 404 error page
utils.jl                # Custom Franklin HTML/LaTeX extension functions
Project.toml            # Julia package dependencies
Manifest.toml           # Locked Julia package versions
.gitlab-ci.yml          # GitLab Pages CI (fallback deployment config)
```

Build output (`__site/`) is git-ignored. The `google599763433934e4da.html` file is a Google Search Console verification file and must be kept at the root.

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

### Blog posts (TOML `+++` syntax)
Used for files under `blogs/`:

```
+++
title = "Post Title"
+++
```

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
using Sass
Sass.compile_file("style.scss", "../_css/celeste.min.css"; output_style = Sass.compressed)
```

### Key design tokens (`_sass/utilities/_variables.scss`)
| Variable | Value | Usage |
|----------|-------|-------|
| Primary blue | `#0A3b76` | Body top border, nav icons, social links |
| Link color | `#5a81b0` | Anchor tags |
| Nav hover | `#2098d1` | Underline on hover |
| Body text | `#515151` | Main copy |
| Heading text | `#313131` | h1–h6 |
| Font (body) | Source Sans Pro | Via Google Fonts CDN |
| Font (code) | Source Code Pro | Via Google Fonts CDN |
| Font size | 17px desktop / 15px mobile | |

### Additional stylesheets
- `_css/franklin.css` — Franklin.jl default styles (do not override without care)
- Font Awesome 6.4.2 loaded via CDN for social icons

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
1. Create `blogs/postN.md` with TOML frontmatter:
   ```
   +++
   title = "Your Post Title"
   +++
   # Your Post Title
   Content here...
   ```
2. Add a link to the new post in `blog.md`

### New top-level page
1. Create `pagename.md` at the repository root with `@def title = "..."` frontmatter
2. Add a nav link in `_layout/nav.html`

### New assets
- Images: place in `_assets/`, reference in Markdown as `/assets/filename.jpg`
- PDFs: place in `_assets/pdfs/`, reference as `/assets/pdfs/filename.pdf`
- Keep `_assets/` organized; do not place assets at the root

---

## CI/CD and Deployment

### GitHub Actions (`.github/workflows/Deploy.yml`)
Triggers on push to `main` or `master`:

1. Checkout code
2. Install Python 3.8 (for minification via `css-html-js-minify`)
3. Install latest stable Julia
4. Install NodeJS packages (`highlight.js`) and instantiate Julia environment
5. Run `optimize()` to build the site into `__site/`
6. Deploy `__site/` to the `gh-pages` branch using `JamesIves/github-pages-deploy-action`

**Never manually push to `gh-pages`** — it is fully managed by CI.

### GitLab CI (`.gitlab-ci.yml`)
A parallel configuration for GitLab Pages exists as a fallback. Deploys to `public/` directory.

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `config.md` | Global site metadata, RSS config, global LaTeX macros |
| `utils.jl` | Custom Franklin extension functions (`hfun_*`, `lx_*`) |
| `_layout/head.html` | HTML `<head>`: meta tags, CSS/font CDN links |
| `_layout/nav.html` | Site navigation bar markup |
| `_layout/foot.html` | Page footer markup |
| `_sass/utilities/_variables.scss` | Design tokens: colors, fonts, breakpoints |
| `_sass/adjust.scss` | Franklin.jl-specific CSS adjustments |
| `.github/workflows/Deploy.yml` | CI/CD pipeline definition |

---

## Custom Franklin Extensions (`utils.jl`)

Franklin allows custom Julia functions for HTML generation and LaTeX command handling:

- **`hfun_*(vname)`** — HTML functions callable in Markdown as `{{functionname arg}}`
- **`lx_*(com, _)`** — Custom LaTeX-style commands callable as `\commandname{arg}`

Current functions in `utils.jl`:
- `hfun_bar(vname)` — Computes `round(sqrt(val), digits=2)` for a given number
- `hfun_m1fill(vname)` — Reads a page variable from `index.md`
- `lx_baz(com, _)` — Uppercases brace content (example/template function)

Add new custom functions here when Franklin's built-in syntax is insufficient.

---

## Git Workflow

- **Feature branches**: develop changes on named branches (e.g., `claude/feature-name`)
- **Production**: merge to `main` — this triggers the deploy pipeline automatically
- **`gh-pages`**: auto-generated deploy target; never commit here directly
- **`master`**: legacy branch, still tracked by CI but `main` is the primary branch

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
- [ ] Push to feature branch and confirm GitHub Actions build passes before merging to `main`
