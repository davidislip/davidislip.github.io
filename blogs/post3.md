+++
title = "Frank–Wolfe Market Making: Notes"
date = Date(2026, 10, 19)
rss_pubdate = Date(2026, 10, 19)
rss = "Tutorial notes on combinatorial market making, Bregman projections, and Frank–Wolfe as column generation, with a worked triangle market example."
description = "Tutorial notes on combinatorial market making, Bregman projections, and Frank–Wolfe as column generation, with a worked triangle market example."
+++

# Frank–Wolfe Market Making: Notes

*19 October 2026*

These notes walk through *Arbitrage-Free Combinatorial Market Making via Integer Programming* by Christian Kroer, Miroslav Dudík, Sébastien Lahaie, and Sivaraman Balakrishnan (EC 2016). They develop the mathematics from trade costs and coherent prices through Bregman projections, Frank–Wolfe, and integer programming.

**[Read the full notes (PDF, 173 pages)](/assets/pdfs/frank-wolfe-market-making-notes.pdf)**

The central connection is to column generation: Frank–Wolfe builds a mixture of valid market outcomes, while an integer program supplies new outcomes through a linear optimization oracle. The notes work through the resulting profit certificates, including the distinction between a feasible solution and a solver bound when an integer solve is stopped early.

A six-security triangle market runs through the tutorial, connecting the derivations to a worked example and a Python program whose full listing appears in Appendix C. The notes assume familiarity with convex optimization, integer programming, and probability.

For a shorter reading path:

- **The main idea:** Chapter 1, followed by Chapters 6, 9, and 10 on projection, Frank–Wolfe, and safe updates.
- **The optimization connection:** Chapters 8–11 on integer outcome models, column generation, and certificates from time-limited solves.
- **The worked example:** Chapters 15–16, with the formula sheet in Appendix A.

This is the full draft edition, with 22 chapters and appendices. It distinguishes results from the original paper, tutorial derivations, implementation recommendations, and proposed experiments.

[Read the original paper (arXiv v2)](https://arxiv.org/abs/1606.02825v2).
