+++
title = "Probability of Constraint Satisfaction and Robust Optimization"
hasmath = true
rss = "An overview of the connection between probability of constraint satisfaction and robust optimization, with applications to chance-constrained programming."
description = "An overview of the connection between probability of constraint satisfaction and robust optimization, with applications to chance-constrained programming."
+++

# Probability of constraint satisfaction and Robust Optimization

This post explores some of the properties of robust mean-variance optimization. 

Consider the classic mean-variance optimization model to select a portfolio $\mathbf{x} \in \mathbb{R}^N$
$$
\min_{\mathbf{x}} \mathbf{x}^{\intercal} Q \mathbf{x} \quad \textit{s.t.}\quad  \mathbf{1}^{\intercal}\mathbf{x} = 1, \ \mathbf{x} \geq \mathbf{0},\  \boldsymbol{\mu}^{\intercal}\mathbf{x} \geq r_{\text{min}},
$$
where $r_{\text{min}}$ is the target return, $\mathbf{Q}$ is the covariance matrix of asset returns, and  $\boldsymbol{\mu}$ is the expected return. 

We do not know the true values of $\boldsymbol{\mu}$ and $\mathbf{Q}$. Instead, we only have data to estimate these quantities. We form the corresponding estimates $\hat{\boldsymbol{\mu}}$ and $\hat{\mathbf{Q}}$ from a dataset of returns $S = \{\mathbf{r}^{(i)}\}_{i=1}^T$ and solve the MVO model with $\boldsymbol{\mu}$ and $\mathbf{Q}$ replaced with $\hat{\boldsymbol{\mu}}$ and $\hat{\mathbf{Q}}$.  Let $\mathbf{x}_{\text{MVO}} \left(\hat{\boldsymbol{\mu}}, \hat{\mathbf{Q}} \right)$ denote an MVO solution obtained using estimates $\hat{\boldsymbol{\mu}}$ and $\hat{\mathbf{Q}}$.

What is random here? The estimates $\hat{\boldsymbol{\mu}}$ and $\hat{\mathbf{Q}}$ are random, since they depend on a random sample $S$. We can then ask, "What is the probability of meeting the constraints?"

$\mathbb{P}_S[\boldsymbol{\mu}^{\intercal} \mathbf{x}_{\text{MVO}} \left(\boldsymbol{\mu}, \mathbf{Q} \right) \geq r_{\text{min}}] = 1$ since $\mathbf{x}_{\text{MVO}}$ is a deterministic quantity and satisfies the return constraint by definition. 

Similarly, one can consider the probability of meeting the return constraint when using the estimates: $\mathbb{P}[\boldsymbol{\mu}^{\intercal} \mathbf{x}_{\text{MVO}} \left(\hat{\boldsymbol{\mu}}, \hat{\mathbf{Q}} \right) \geq r_{\text{min}}] = ? $. Unfortunately, this probability does not equal 1. This drawback motivates the use of robust optimization, where we replace the constraint
$$
\boldsymbol{\mu}^{\intercal}\mathbf{x} \geq r_{\text{min}}
$$
with
$$
\boldsymbol{\mu}^{\intercal}\mathbf{x} \geq r_{\text{min}} \ \forall \boldsymbol{\mu} \in \mathcal{U},
$$
where $\mathcal{U}$ is an uncertainty set for the mean. 
A popular uncertainty set is the ellipsoid centered at the estimate $\hat{\boldsymbol{\mu}}$ with shape parameter  
$$\Theta = \frac{1}{T}\begin{pmatrix}
\hat{Q}_{11} & 0 & \cdots & 0 \\
0 & \hat{Q}_{22} & \cdots & 0 \\
\vdots & \vdots & \ddots & \vdots \\
0 & 0 & \cdots & \hat{Q}_{NN}
\end{pmatrix}
$$
and radius $\delta$. In this setting, the robust optimization problem can be written as: 
$$
\begin{aligned}
\min_{\mathbf{x}} \quad & \mathbf{x}^{\intercal} \hat{\mathbf{Q}}\ \mathbf{x} \\
\mathrm{s.t.} \quad & \hat{\boldsymbol{\mu}}^{\intercal} \mathbf{x} - \delta \|\boldsymbol{\Theta}^{1/2} \mathbf{x}\|_2 \geq r_{\text{min}} \\
                    & \mathbf{1}^{\intercal} \mathbf{x} = 1 \\
                    & \mathbf{x} \geq \mathbf{0}
\end{aligned}
$$

Now let $\mathbf{x}_{\text{ROB}} \left(\hat{\boldsymbol{\mu}}, \hat{\mathbf{Q}} \right)$ denote a robust MVO solution obtained using estimates $\hat{\boldsymbol{\mu}}$ and $\hat{\mathbf{Q}}$ and consider the probability of constraint satisfaction $\mathbb{P}[\boldsymbol{\mu}^{\intercal} \mathbf{x}_{\text{ROB}} \left(\hat{\boldsymbol{\mu}}, \hat{\mathbf{Q}} \right) \geq r_{\text{min}}] = ? $. This probability should be higher than the estimated MVO case if the ellipsoid covers a large portion of the support of the distribution of $\hat{\boldsymbol{\mu}}$. However, in practice, we cannot easily evaluate these probabilities. 

## Google Colab Notebook

The notebook located [here](https://colab.research.google.com/drive/1miJ8VW_YhU3dDYCLTiv61soPiyNXGSG0?usp=sharing) explores these facts in a contrived setting where we have sampling access to the return distribution. Indeed, the robust model increases the probability of satisfying the return constraint. 