# davidislip.github.io

Source for [davidislip.github.io](https://davidislip.github.io/) — the personal site of
David Islip, built with [Franklin.jl](https://franklinjl.org/) and deployed to GitHub
Pages from `main` by `.github/workflows/Deploy.yml`.

The theme began as [Celeste](https://github.com/nicoelayda/celeste) by @nicoelayda and has
since been substantially reworked; see `_sass/adjust.scss` for the layer that reconciles it
with Franklin's own stylesheet.

See `CLAUDE.md` for the full guide to the repository, and `plan.md` for outstanding work.

## Development

Local preview with live reload:

```julia
using Pkg; Pkg.activate("."); using Franklin; serve()
```

Full build, the way CI does it (this is the one that pre-renders KaTeX):

```julia
using Pkg; Pkg.activate("."); Pkg.instantiate()
using NodeJS; run(`$(npm_cmd()) install highlight.js`)
using Franklin; optimize()
```

The `npm install highlight.js` step is what CI runs and is required for server-side
code highlighting. Skipping it still builds, but code blocks fall back to the browser.

> `serve()` does **not** pre-render math — KaTeX runs client-side and the scripts are present.
> `optimize()` renders math server-side and strips the scripts. Verify any change to equation
> layout against `__site/` from `optimize()`, not against `serve()`.

### CSS

Changes to the CSS must be made to the SCSS files in `_sass/`, never to `_css/celeste.min.css`
directly. Recompile from inside `_sass/`:

```julia
using Pkg; Pkg.activate(".."); using Sass
Sass.compile_file("style.scss", "../_css/celeste.min.css"; output_style = Sass.compressed)
```

Commit the regenerated `_css/celeste.min.css` in the **same commit** as the `_sass/` change — CI
never runs Sass, so a `_sass/` edit without the recompiled artifact ships as a no-op.

No source map is generated or committed. `Sass.compile_file` emits none unless passed
`source_map_file`, so a tracked `.map` only goes stale; `_css/*.map` is deliberately absent.

All the `Franklin.jl` related changes are in `_sass/adjust.scss`.

> **Load-order dependency:** `_layout/head_mixin.html` loads `/css/franklin.css` *before*
> `/css/celeste.min.css`. Several Celeste rules tie franklin.css on specificity and win on source
> order alone. Do not reorder those two `<link>` tags.
