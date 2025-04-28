+++
title = "Post 2"
+++

# Probability of constraint satisfaction and Robust Optimization

This post explores some of the properties of robust mean-variance optimization. 

Consider the classic mean-variance optimization model to select a portfolio $\bf{x} \in \mathbb{R}^N$
$$
\min_{\bf{x}} \bf{x}^{\intercal} Q \bf{x} \quad \textit{s.t.}\quad  \bf{1}^{\intercal}\bf{x} = 1, \ \bf{x} \geq \bf{0},\  \boldsymbol{\mu}^{\intercal}\bf{x} \geq r_{\text{min}},
$$
where $r_{\text{min}}$ is the target return, $\bf{Q}$ is the covariance matrix of asset returns, and  $\mathbf{\mu}$ is the expected return. 

We do not know the true values of $\boldsymbol{\mu}$ and $\bf{Q}$. Instead, we only have data to estimate these quantities. We form the corresponding estimates $\hat{\boldsymbol{\mu}}$ and $\hat{\bf{Q}}$ from a dataset of returns $S = \{\mathbf{r}^{(i)}\}_{i=1}^T$ and solve the MVO model with $\boldsymbol{\mu}$ and $\bf{Q}$ replaced with $\hat{\boldsymbol{\mu}}$ and $\hat{\bf{Q}}$.  Let ${\bf x}_{\text{MVO}} \left(\boldsymbol{\hat{\mu}}, \hat{\bf{Q}} \right)$ denote an MVO solution obtained using estimates $\boldsymbol{\hat{\mu}}$ and $\hat{\bf{Q}}$.

What is random here? The estimates $\boldsymbol{\hat{\mu}}$ and $\hat{\bf{Q}}$ are random, since they depend on a random sample $S$. We can then ask, "What is the probability of meeting the constraints?"

$\mathbb{P}_S[\mu^{\intercal} {\bf x}_{\text{MVO}} \left(\boldsymbol{\mu}, \bf{Q} \right) \geq r_{\text{min}}] = 1$ since ${\bf x}_{\text{MVO}}$ is a deterministic quantity and satisfies the return constraint by definition. 

Similarly, one can consider the probability of meeting the return constraint when using the estimates: $\mathbb{P}[\mu^{\intercal} {\bf x}_{\text{MVO}} \left(\boldsymbol{\hat{\mu}}, \hat{\bf{Q}} \right) \geq r_{\text{min}}] = ? $. Unfortunately, this probability does not equal 1. This drawback motivates the use of robust optimization, where we replace the constraint
$$
\boldsymbol{\mu}^{\intercal}\bf{x} \geq r_{\text{min}}
$$
with
$$
\boldsymbol{\mu}^{\intercal}\bf{x} \geq r_{\text{min}} \ \forall \boldsymbol{\mu} \in \mathcal{U},
$$
where $\mathcal{U}$ is an uncertainty set for the mean. 
A popular uncertainty set is the ellipsoid centered at the estimate $\hat\boldsymbol{\mu}$ with shape parameter  
$$\Theta = \frac{1}{T}\begin{pmatrix}
\hat{Q}_{11} & 0 & \cdots & 0 \\
0 & \hat{Q}_{22} & \cdots & 0 \\
\vdots & \vdots & \ddots & \vdots \\
0 & 0 & \cdots & \hat{Q}_{nn}
\end{pmatrix}
$$
and radius $\delta$. In this setting, the robust optimization problem can be written as: 
$$
\begin{align*}
&\begin{align*}
 & \min_{\bf{x}}     & \bf{x}^{\intercal} \hat{\bf{Q}}\ \bf{x}
\end{align*}\\
&\begin{align*}
 &\ \mathrm{s.t.}    & \hat{\boldsymbol{\mu}}^T \bf{x} - \delta \|\bf{\Theta}^{1/2} \bf{x}\|_2 &\geq r_{\text{min}} \\
 &                   & \bf{1}^T \bf{x} &= 1
\end{align*}
\end{align*}
$$

Now let ${\bf x}_{\text{ROB}} \left(\boldsymbol{\hat{\mu}}, \hat{\bf{Q}} \right)$ denote a robust MVO solution obtained using estimates $\boldsymbol{\hat{\mu}}$ and $\hat{\bf{Q}}$ and consider the probability of constraint satisfaction $\mathbb{P}[\mu^{\intercal} {\bf x}_{\text{ROB}} \left(\boldsymbol{\hat{\mu}}, \hat{\bf{Q}} \right) \geq r_{\text{min}}] = ? $. This probability should be higher than the estimated MVO case if the ellipsoid covers a large portion of the support of the distribution of $\hat{\boldsymbol{\mu}}$. However, in practice, we cannot easily evaluate these probabilities. 

## Google Colab Notebook

The notebook located [here](https://colab.research.google.com/drive/1miJ8VW_YhU3dDYCLTiv61soPiyNXGSG0?usp=sharing) explores these facts in a contrived setting where we have sampling access to the return distribution. Indeed, the robust model increases the probability of satisfying the return constraint. 