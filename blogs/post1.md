+++
title = "Post 1"
+++
# Some Facts about Bootstrapping
This post documents some facts about bootstrapping that I encountered during my PhD. In particular, this post highlights some asymptotic results relating to
* The mean absolute deviation of normal variables
* The quantile of absolute deviations from the mean
* The distribution of standard deviations
Consider the setting where we sample $T$ observations and create $B$ samples of size $T$ by sampling with replacement. In other words, we have:
- The original sample $S := \{X_i\}_{i \in [T]}$
- $\bar{\mu}$ is the sample mean statistic computed over $S$  
- The samples from $S$ with replacement: $S_b := \{X^{(b)}_i\}_{i=1}^T, \ b \in [B] := \{1,2,...,B\}$
- $\bar{\mu}^{(b)}$ is the statistic computed over the $T$ observations associated with batch $b\in[B]$
## Part 1: Normality
### Mean Absolute Deviation and Standard Deviation
\citet{Geary} proved the following:
If $X \sim N(\mu, \sigma)$ then $\mathbb{E}[|X - \mu|] = \sqrt{\frac{2}{\pi}} \sigma$
\biblabel{Geary}{Geary, R. C. } **Geary**, [The Ratio of the Mean Deviation to the Standard Deviation as a Test of Normality.](https://www.jstor.org/stable/2332693), *Biometrika*, **27**(3), 310–32, 1935.
### Central limit theorem
The central limit theorem states that if $\{X_i \}_{i \in [T]}$ are $T$ samples drawn independently and identically distributed from a distribution with mean $\mu$ and variance $\sigma^2$, then $Z = \lim_{T \rightarrow \infty} \sqrt{T} (\frac{1}{T}\sum_{t \in [T]}{X_t} - \mu)/{\sigma}$ follows a standard normal distribution.
The sample estimate of the mean for batch $b \in [B]$ is given by $ \bar{\mu}^{(b)}
:= \frac{1}{T} \sum_{t \in [T]} X_t^{(b)}$, therefore, for large $T$:
$$
    \frac{1}{T} \sum_{t \in [T]} X_t^{(b)} \overset{d}{\rightarrow} N(\mu, \frac{\sigma}{\sqrt{T}})
$$
In our setting, the distribution is the empirical distribution defined by the sample $S$, implying that $\mu$ and $\sigma$ are given by
$$
\mu = \mathbb{E}_S[X] = \frac{1}{T}\sum_{x \in S} x
$$
and
$$
\sigma = \mathbb{E}_S[(X - \mu)^2] = \frac{1}{T}\sum_{x \in S} (x - \mu)^2
$$
Therefore $\bar{\mu}^{(b)} = \frac{1}{T} \sum_{t \in [T]} X^{(b)}_t$ can be thought of as a sample from $N(\mu, \frac{\sigma}{\sqrt{T}})$
## Part 2: Quantile of Absolute Deviations
In the work by \citet{HoSunXin2015}, the optimal portfolio solves:
$$
\begin{align}
\min_{x} \quad & x^{\intercal}\Sigma x + x^{\intercal} \text{diag}\{\alpha_i\} x + \beta^{\intercal} |x| \notag &\\
\textrm{s.t.} \ \quad & \mu^\intercal x  \geq \bar{R},\ x \in \Delta_N \notag \\
\end{align}
$$
where $\beta \in \mathbb{R}_+^N$ and $\alpha_i \in \mathbb{R}_+ \ \forall i \in [N]$ denote the penalty parameters.  \citet{HoSunXin2015} show that $\alpha_i$ and $\beta_i$ correspond to the sizes of box-uncertainty sets used in the robust counterpart of the mean-variance optimization problem. Specifically, $\alpha_i$ and $\beta_i$ correspond to uncertainty in the diagonal of the estimated covariance matrix $\Sigma_{ii}$ and expected return $\mu_i$ respectively for asset $i = 1,2,..., N$.
\citet{HoSunXin2015} use a bootstrapping approach to select the values of $\beta_i$ and $\alpha_i$; they proceed as follows: Let $\{\boldsymbol{r}^{(t)} \in \mathbb{R}^N\}_{t \in [T]}$ denote $T$ observations of the random variable $\boldsymbol{r}$ used to estimate $\boldsymbol{\Sigma}$ and $\boldsymbol{\mu}$. The estimation errors are computed by re-sampling $T$ observations with replacement from the original set of observations $B$ times. Each re-sampling yields estimates of the mean and covariance $\bar{\boldsymbol{\mu}}^{(b)}, \bar{\boldsymbol{\Sigma}}^{(b)} \ b \in [B]$. Let $p_1$ and $p_2$ denote the investor's aversion to estimation risk of the mean and variance, respectively. The values for $\beta_i$ and $\alpha_i$ are defined as the quantiles of the bootstrapped deviations
$$
    \alpha_i = \inf {\Big \{}t {\Big |} \frac{1}{B} \sum_{b=1}^{B} {\mathbf{1}}{\Big [}|\bar{\Sigma}^{(b)}_{ii} - \Sigma_{ii}| < t {\Big ] } > p_1 {\Big \}}
$$
and
$$
    \beta_i = \inf {\Big \{}t {\Big |} \frac{1}{B} \sum_{b=1}^{B} {\mathbf{1}}{\Big [}|\bar{\mu}^{(b)}_{i} - \mu_{i}| < t {\Big ] } > p_2 {\Big \}}
$$
### Quantile of absolute deviation for standard normal
One can express the quantile of absolute deviation of a normal variable in a closed-form equation. The results can be derived as follows: letting $Z \sim N(0,1)$ then the quantile of the absolute deviation satisfies $P(|Z| \leq x) = p$ which is the same as  $2\Phi(x) - 1 = p$ which implies
$$
x = \Phi^{-1}(\frac{p+1}{2})
$$
This is useful because we see that the sample means $\bar{\boldsymbol{\mu}}^{(b)}$ converge in distribution to a normal distribution.
\biblabel{HoSunXin2015}{Ho, M., Sun, Z., and Xin, J. } **Ho, Sun & Xin**, [Weighted elastic net penalized mean-variance portfolio design and computation.](https://doi.org/10.1137/15M1007872), *SIAM Journal on Financial Mathematics*, **6**(1), 1220–1244, 2015. 
## Part 3: Distribution of standard deviations can be obtained via the delta method 
The links below were useful in understanding the delta method and its application to the distribution of standard deviations. 
- [Question about standard deviation and central limit theorem](https://tinyurl.com/ybdupe9u)
- [Why does the second-order delta method approximation to the variance of Bernoulli r.v. result in a negative chi-square?](https://tinyurl.com/yz7sae3a)
- [Elements of Large-Sample Theory](https://tinyurl.com/42wwkbz7)
- [Standard Deviation Distribution](https://tinyurl.com/f9za5y4u)
The case of determining an approximation for the distribution of $\boldsymbol{\Sigma}$ is more complex. For simplicity, we consider the case where $\boldsymbol{\Sigma}$ is a scalar denoted by $\sigma$.
An approach referred to as the delta method can be used to obtain the asymptotic distribution of $\Sigma =  \frac{1}{T}\sum_{i \in [T]} X_i^2 - (\frac{1}{T} \sum_{i \in [T]} X_i)^2$.

Let $W^{(2)}$ and $W^{(1)}$ denote $\frac{1}{T} \sum_{i \in [T]} X_i^2$ and $\frac{1}{T} \sum_t X_t$ respectively. $W^{(1)}$ and $W^{(2)}$ converge to a joint normal distribution by the multivariate central limit theorem with covariance $\Xi_{W^{(j)}, W^{(k)}} = \mathbb{E}[W^{(j)} W^{(k)}] - \mathbb{E}[W^{(j)}]\mathbb{E}[W^{(k)}]$ and expected value $\boldsymbol{\mu}_{\mathbf{W}}$ i.e $\sqrt{T}(\mathbf{W} - \boldsymbol{\mu}_{\mathbf{W}} ) \overset{d}{\rightarrow} N(\mathbf{0}, \Xi)$.

In general, for any differentiable $g(\mathbf{W})$ one can write the following first-order Taylor expansion $g({\mathbf{W}}) \approx {g(\boldsymbol{\mu}_{\mathbf{W}}) + } \nabla g(\boldsymbol{\mu}_{\mathbf{W}})({\mathbf{W}} - \boldsymbol{\mu}_{\mathbf{W}})$.
One can approximate the covariance of $g(\mathbf{W})$ by $\mathbb{V}[g({\mathbf{W}})] \approx \nabla g({\mathbf{W}})^{\intercal} {\mathbf \Xi} \nabla g({\mathbf{W}})$, and as such $\sqrt{T}(g({\mathbf{W}}) - g({\boldsymbol{\mu}_{\mathbf{W}}}) )\overset{d}{\rightarrow} N(0,\nabla g({\mathbf{W}})^{\intercal} {\mathbf \Xi} \nabla g({\mathbf{W}}))$.

One can set $g(W_1,W_2) = W^{(2)} - (W^{(1)})^2$ and use the first-order delta method as described above to obtain asymptotic convergence condition.
The first-order delta method does not always work. Convergence to normality does not hold for Bernoulli variables with $p = 0.5$ because the variance of $g$ ends up being zero.

To circumvent this, the second-order Taylor approximation must be used. In the case of Bernoulli random variables $g$ can be expressed as a function of a single random parameter: $$\hat{p} := \frac{1}{T} \sum_t X_t,$$ since $\frac{1}{T} \sum_t X_t = \frac{1}{T} \sum_t X_t^2$. In this case,
$$\begin{align*}
g(\hat{p}) &= \frac{1}{T} \sum_t X_t^2 - \left(\frac{1}{T} \sum_t X_t\right)^2\\
&= \hat{p}(1-\hat{p}).
\end{align*}$$
If the mean is $p=1/2$, then taking the second-order taylor expansion around the mean implies $\hat{p}(1-\hat{p}) = 1/4 + 0*(\hat{p}-0.5) + 1/2 (-2) (\hat{p} - 1/2)^2$. It is then true that $\hat{p}(1-\hat{p})$ is asymptotically negative $\chi^2$ and is not normal because $\hat{p} = \frac{1}{T} \sum_t X_t$ is asymptotically normal by the central limit theorem and $\hat{p}(1-\hat{p})$ is a constant minus an asymptotically normal variable squared (as shown in the above Taylor series. In the case that the first-order delta method is applicable and the first-order Taylor series introduces uncertainty in $g$, it follows:
$$
    \frac{1}{T}\sum X_i^2 - (\frac{1}{T} \sum_t X_t)^2 \overset{d}{\rightarrow} N {\big(}\sigma^2, \frac{1}{\sqrt{T}}\sqrt{\text{CM}_4(X) - \sigma^4 + O(T^{-2})}{\big)},
$$
where $\text{CM}_4(X)$ denotes the 4th-order central moment of $X$.
## Google Colab Notebook
The notebook located [here](https://drive.google.com/file/d/1EQ1f5KXrCXojDyLLVKmG7hgUyIcv7xT6/view?usp=sharing) demonstrates the facts highlighted above. 

