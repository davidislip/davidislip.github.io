#
# Custom Franklin extension functions.
#
#   hfun_<name>(args)  -> callable from Markdown or a layout as {{name arg}}
#   lx_<name>(com, _)  -> callable from Markdown as \name{arg}
#
# This file previously held Franklin's three template examples (hfun_bar,
# hfun_m1fill, lx_baz). None was called from any page, so they were removed.
#

"""
    hfun_canonical()

Absolute URL of the page being rendered, in the directory form every internal
link on this site already uses (`/research/`, never `/research/index.html`),
with the home page as the bare domain.

Franklin sets `fd_url` once per page in `def_LOCAL_VARS!` (utils/vars.jl) from
`url_curpage` (utils/html.jl), before `head.html` is templated. `url_curpage`
already honours `keep_path`, so `404.md` stays `404.html` rather than becoming
`/404/`. This function only drops a trailing `index.html` and joins the result
to `website_url`.

The regex is anchored to `/index.html` rather than `index.html` on purpose: the
looser form would mangle a page legitimately named `myindex.html`.

Known limitation: a page using Franklin's `slug` page variable gets an
unnormalised Windows path from `form_custom_output_path`, which would leak a
backslash here. No page on this site uses `slug`; if one ever does, normalise
the separators before the `index.html` strip.

Used from `_layout/head.html` as `{{canonical}}`.
"""
function hfun_canonical()
    base = globvar(:website_url)
    base === nothing && return ""
    base = rstrip(String(base), '/')
    url = locvar(:fd_url)
    url === nothing && return base * "/"
    url = String(url)
    startswith(url, "/") || (url = "/" * url)
    url = replace(url, r"/index\.html$" => "/")
    return base * url
end
