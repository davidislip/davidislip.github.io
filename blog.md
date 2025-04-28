+++
title = "Blog"
+++

The following posts contain some lessons I have gathered along the way. 

# Bootstrapping and the Delta Method

Understanding the distribution of the sample standard deviation can be done using the delta method. By applying the multivariate central limit theorem and a Taylor series expansion, an asymptotic approximation is derived. While this first-order approach works under most conditions, it fails for edge cases like Bernoulli variables with $p = 0.5$, where zero gradients necessitate a second-order expansion, yielding a negative chi-squared distribution instead of a normal one.

<!-- How can we understand the distribution of the sample standard deviation? One way is to use a technique called the delta method. By applying the multivariate central limit theorem, it's possible to derive an asymptotic approximation of the standard deviation's distribution through a Taylor series expansion. This first-order approach works under typical conditions, but fails in edge cases like Bernoulli random variables with 
$p=0.5$, where a zero variance forces the use of a second-order expansion. In such scenarios, the resulting distribution is asymptotically negative chi-squared instead of normal. -->


[Read More](/blogs/post1)

# Robust Portfolio Selection

In portfolio optimization, Mean-Variance Optimization (MVO) relies on estimated inputs for expected returns $\boldsymbol{\mu}$ and covariance $\boldsymbol{Q}$, introducing uncertainty. While portfolios generated using true parameters meet return constraints, those based on estimates may not. Robust MVO addresses this risk by incorporating uncertainty into the model, improving reliability under estimation errors.


<!-- In portfolio optimization, Mean-Variance Optimization (MVO) relies on estimated inputs for expected returns $\boldsymbol{\mu}$
​and covariance $\boldsymbol{Q}$, which introduces uncertainty. While MVO portfolios generated using the true parameters are guaranteed satisfy expected return constraints. Unfortunately, portfolios produced by MVO using the estimates may not satisfy the expected return constraints according to the true parameters. The probability that an MVO or Robust MVO portfolio meets its return target depends on the accuracy of these estimates. Robust optimization methods aim to reduce this risk by incorporating uncertainty directly into the optimization model, potentially increasing reliability compared to standard MVO under uncertain estimates. -->

[Read More](/blogs/post2)


<!-- # Value Functions and Bi level Optimization


# Sklearn is amazing 

# Making documents blue

# 

-->
