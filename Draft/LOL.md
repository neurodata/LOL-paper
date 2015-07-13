---
bibliography: biblol.bib
style: nature
title: Supervised Manifold Learning for Wide Data
author: "Joshua T.\_Vogelstein, Mauro Maggioni"
---

Supervised learning—the art and science of discovering, from data, statistical
relationships between multiple different measurement types—is one of the most
useful tools in the scientific toolbox. SL has been enabled a wide variety of
basic and applied findings, ranging from discovering biomarkers in omics data,
to object recognition from images. A special case of SL is classification; a
classifier can predict the ’class’ of a novel observation via training on a set
of paired observations and class labels (for example, predicting male vs. female
from MRI scans). In such problems, the goal is to find the optimal discriminant
boundary, which partitions the space of observations into the different classes.
In the data age, the ambient (or observed) dimensionality of the observations is
quickly ballooning, and with it, the dimensionality of the discriminant
boundary. While historical data may have consisted of only a few dimensions
(e.g., height and weight), modern scientific datasets often consist of hundreds,
thousands, or even millions of dimensions (e.g. genetics, neuroscience, omics).
Regardless of the dimensionality, when a scientist or analyst obtains a new
dataset consisting of some observations and labels, she must decide which of the
myriad available tools to use. Reference algorithms for datasets with low
dimensionality include linear and quadratic discriminant analysis, support
vector machines, and random forests @TBF01.

Classical methods, however, often rely on very restrictive assumptions. In
particular, the theoretical guarantees upon which many classical methods rest
require that the number of samples is much larger than the dimensionality of the
problem ($n \gg p)$. In scientific contexts, while the dimensionality of
datasets is booming, the sample is not witnessing a concomitant increase (see,
for example, Table 2 of @piMartino2014 in connectomics). When the number of
dimensions is orders of magnitude larger than the sample size, as is now
typical, this $n \gg p$ assumption is woefully inadequate. This inadequacy is
not a mere theoretical footnote; rather, the implementation of the algorithm
itself sometimes fails or crashes if this assumption is not met. Worse, often
times the algorithm will run to completion, but the answer will be essentially
random, with little or no predictive power or accuracy (e.g., @Eklund2012a).

To combat these issues, the fields of statistics and machine learning have
developed a large collection of new methods that relax these assumptions, and
exhibit significantly improved performance characteristics. Each such approach
makes some “structural” assumptions about the data (sometimes in the form of
priors), therefore potentially adding some bias, while reducing variance. The
best approach, for a given problem, is the approach that wins this bias/variance
trade-off; that is, the approach whose assumptions best correspond to the
properties of the data (minimizing bias), and yields estimates have that low
error under those assumptions (minimizing variance). These approaches complement
“feature engineering” approaches, where the practitioner designs new features
based on prior domain specific knowledge.

One of the earliest approaches for discovering low-dimensional representations
in supervised learning problems is regularization or shrinkage
@Friedman1989[@Bickel2004; @Bouveyron07a]. Many shrinkage methods mitigate the
dimensionality problem by smoothing @Witten09a, for example, by regressing
parameters to the mean. More recently, a special case of regularization has
risen to prominence, called *sparsity* @Olshausen1997, in which it is assumed
that a small number of dimensions can encode the discriminant boundary @Tibs96.
This assumption, when accurate, can lead to substantial improvements in accuracy
with relatively moderate increase in computational cost @Buhlmann2011. This
framework includes methods such as  @Tibs96, higher criticism thresholding
@ponoho08a, and sparse variants of linear discriminant analysis
@Tibshirani2002[@Fan2008; @Witten09a; @Clemmensen2011; @Mai2013; @Fan2012].

However, for a wide class of problems, such as image classification, sparisty in
the ambient space is an overly restrictive, and therefore, bias-inducing
assumption (see Figure [fig:mnist] for an example on the classic MNIST dataset).
A generalization of sparsity is “low-rank”, in which a small number of linear
combinations of the ambient dimensions characterize the data. Unsupervised
low-rank methods date back over a century, including multidimensional scaling
@Young1938[@Borg2010] and principal components analysis
@Pearson1901[@Jolliffe2002]. More recent nonlinear versions of unsupervised
dimensionality reduction, or manifold learning, include developments from neural
network theory such as self-organizing maps @Kohonen1982, generative topographic
mapping @Bishop1998. In this century, manifold learning became more popular,
including isomap @Tenenbaum2000, local linear embedding @Roweis2000, Laplacian
eigenmaps @Belkin2003, local tangent space alignment @Zhang2004b, diffusion maps
@Coifman2006, and geometric multi-resolution analysis @Allard12a. All these
approaches can be used as pre-processing steps, to reduce the dimensionality of
the data prior to solving the supervised learning problem @Belhumeur1997.

However, such manifold learning methods, while exhibiting both strong
theoretical @Eckart1936[@deSilva2003; @Allard12a] and empirical performance, are
fully unsupervised. Thus, in classification problems, they discover a
low-dimensional representation of the data, ignoring the labels. This can be
highly problematic when the discriminant dimensions and the directions of
maximal variance are not aligned (see Figure [fig:mnist] for an example).
Supervised dimensionality reduction techniques, therefore, combine the best of
both worlds, search for low-dimensional discriminant boundaries. A set of
methods from the statistics community is collectively referred to as “sufficient
dimensionality reduction” (SIR) or “first two moments” (F2M) methods
@Li1991[@TB99; @Globerson2003; @Cook2005; @Fukumizu2004]. These methods are
theoretically elegant, but typically require the sample size to be larger than
the number of observed dimensions (although see @Cook13a for some promising
work). Other approaches formulate an optimization problem, such as projection
pursuit @Huber1985, empirical risk minimization @Belkin2006, or supervised
dictionary learning @Mairal2008. These methods are limited because they are
prone to fall into local minima, they require costly iterative algorithms, and
lack any theoretical guarantees @Belkin2006. Thus, there remains a gap in the
literature: a supervised learning method with theoretical convergence guarantees
appropriate when the dimensionality is orders of magnitude larger than the
sample size.

The challenge lies is posing the problem in such a way that efficient numerical
algorithms can be brought to bear, without costly iterations or tuning
parameters. Our approach, which we call “Linear Optimal Low-rank” () embedding
(see Figure [fig:mnist]), utilizes the first two moments, as do SIR, spectral
decompositions, and high-dimensional discriminant analysis methods
@Bouveyron07a, but does not require iterative algorithms and therefore is vastly
more computationally efficient. The motivation for  comes from a simple
geometric intuition (Figure [fig:cigars]). Indeed, we provide both theoretical
insight explaining why our method is more general than previous approaches
(low-bias), as well as finite sample guarantees (low-variance). A variety of
simulations provide further evidence that  efficiently finds a better
low-dimensional representation than competing methods, not just under the
provable model assumptions, but also under much more general contexts (Figure
[fig:properties]). Moreover, we demonstrate that  achieves better performance,
in less time, as compared to several reference high-dimensional classifiers, on
several benchmark datasets, including genomics, connectomics, and image
processing problems (Figure [fig:realdata]). Finally,  can also be used to
improve high-dimensional regression and testing (Figure [fig:generalizations]).
Based on the above, we suggest that   be considered as one of the reference
method for supervised manifold learning for wide data. For reproducibility and
extensibility, MATLAB code to run all numerical experiments and reproduce all
figures is available from our github repository available here:
<http://openconnecto.me/lol>.

Results
=======

An Illustrative Real Data Example of Supervised Linear Manifold Learning
------------------------------------------------------------------------

![ Illustrating three different classifiers— (top),  (middle), and  (bottom)—for embedding images of the digits 3, 7, and 8 (from MNIST), each of which is 28 $\times$ 28 = 784 dimensional. **(A)**: Exemplars, boundary colors are only for visualization purposes. **(B)**: The first four projection matrices learned by the three different approaches on 300 training samples. Note that  is sparse and supervised,  is dense and unsupervised, and  is dense and supervised. **(C)**: Embedding 500 test samples into the top 2 dimensions using each approach. Digits color coded as in (A). **(D)**: The estimated posterior distribution of test samples after 5-dimensional projection learned via each method. We show only 3 vs. 8 for simplicity. The vertical line shows the classification threshold. The filled area is the estimated error rate: the goal of any classification algorithm is to minimize that area. Clearly,  exhibits the best separation after embedding, which results in the best classification performance. ](<../Figs/mnist.pdf>)

Pseudocode of any method that embeds high-dimensional data as part of
classification proceeds as schematized in Figure [fig:mnist]: (A) obtain/select
n training samples of the data, (B) learn a low dimensional projection, (C)
project n’ testing samples onto the lower dimensional space, (D) classify the
embedded testing samples using some classifier. We consider three different
linear dimensionality reduction methods—, , and —each of which we compose with a
classifier to form high-dimensional classifiers.[^1]

[^1]: Although  is not a 2-step method (where embedding is learned first, and
then a classifier is applied), adaptive lasso @Zou2006a and its variants improve
on lasso’s theoretical and empirical properties, so we consider such an approach
here.

To demonstrate the utility of , we first consider one of the most popular
benchmark datasets ever, the MNIST dataset @mnist. This dataset consists of many
thousands of examples of images of the digits 0 through 9. Each such image is
represented by a 28$\times$28 matrix, which means that the observed (or ambient)
dimensionality of the data is $p=$784. Because we are motivated by the $n \ll p$
scenario, we subsample the data to select n=300 examples of the numbers 3, 7,
and 8. We then apply all three approaches to this subsample of the MNIST
dataset, learning a projection, and embedding n’=500 testing samples, and
classifying the resulting embedded data.

, by virtue of being a sparse method, finds the pixels that most discriminate
the 3 classes. The resulting embeddings mostly live along the boundaries,
because these images are close to binary, and therefore, images either have or
do not have a particular pixel. Indeed, although the images themselves are
nearly sparse (over 80% of the pixels in the dataset have intensity $\leq
0.05$), a low-dimensional discriminant boundary does not seem to be so. , on the
other hand, finds the linear combinations of training samples that maximize the
variance. This unsupervised linear manifold learning method results in
projection matrices that indeed look like linear combinations of the three
different digits. The goal here, however, is separating classes, not maximizing
variability. The resulting embeddings are not particularly well separated,
suggesting the the directions of discriminability are not the same as the
directions of maximum variance.  is our newly proposed supervised linear
manifold learning method (see below for details). The projection matrices it
learns look qualitatively much like those of . This is not surprising, as both
are linear combinations of the training examples. The resulting embeddings
however, look quite different. The three different classes are very clearly
separated by even the first two dimensions. The result of these embeddings
yields classifiers whose performance is obvious from looking at the embeddings:
 achieves significantly smaller error than the other two approaches. This
numerical experiment justifies the use of supervised linear manifold learning,
we next investigate the performance of these methods in simpler simulated
examples, to better illustrate when we can expect  to outperform other methods,
and perhaps more importantly, when we expect this “vanilla” variant of  to fail.

Linear Gaussian Intuition
-------------------------

The above real data example suggests the geometric intuition for when
 outperforms its sparse and unsupervised counterparts. To further investigate,
both theoretically and numerically, we consider the simplest setting that
illustrates the relevant geometry. In particular, we consider a two-class
classification problem, where both classes are distributed according to a
multivariate normal distribution, the class priors are equal, and the joint
distribution is centered, so that the only difference between the classes is
their means (we call this the Linear Discriminant Analysis (LDA) model; see
Methods for details).

To motivate , and the following simulations, lets consider what the optimal
projection would be in this scenario. The optimal low-dimensional projection is
analytically available as the dot product of the difference of means and the
inverse covariance matrix, $\mb{A}_*=\mb{\delta}\T \bSig^{-1}$ @Bickel2004 (see
Methods for details). , the dominant unsupervised manifold learning method,
utilizes only the covariance structure of the data, and ignores the difference
between the means. In particular,  would project the data on the top d
eigenvectors of the covariance matrix. **The key insight of our work is the
following: we can use both the difference of the means and the covariance
matrix, rather than just the covariance matrix, to find a low dimensional
projection.** Naively, this should typically improve performance, because in
this stylized scenario, both are important. Formally, we implement this idea by
simply concatenating the difference of the means with the top d eigenvectors of
the covariance. This is equivalent to first projecting onto the difference of
the means vector, and then projecting the residuals onto the first d principle
components. Thus, it requires almost no additional computational time or
complexity, rather, merely estimates the difference of the means. In this sense,
 can be thought of as a very simply “supervised ”.

![  achieves near optimal performance for a wide variety of distributions. Each point is sampled from a multivariate Gaussian; the three columns correspond to different simulation parameters (see Methods for details). In each of 3 simulations, we sample n=100 points in p=1000 dimensions. And for each approach, we embed into the top 20 dimensions. Note that we use the sample estimates, rather than the true population values of the parameters. In this setting, the results are similar. **(A)**: The mean difference vector is aligned with the direction of maximal variance, maxing it ideal for both  to discover the discriminant direction and a sparse solution. **(B)**: The mean difference vector is orthogonal to the direction of maximal variance, making  fail, but sparse methods can still recover the correct dimensions. **(C)**: Same as (B), but the data are rotated. **Row 1**: A scatter plot of the first two dimensions of the sampled points, with class 0 and 1 as black and gray dots, respectively. **Row 2**: . **Row 3**: , a sparse method designed specifically for this model @Fan2012. **Row 4**: , our newly proposed method. **Row 5**: the Bayes optimal classifier, which is what all classifiers strive to achieve. Note that  is closest to Bayes optimal in all three settings. ](<../Figs/cigars_est.pdf>)

Figure [fig:cigars] shows three different examples of data sampled from the LDA
model to geometrically illustration this intuition. In each, we sample n=100
training samples in p=1000 dimensional space, so $n \ll p$. Figure
[fig:cigars](A) shows an example we call “stacked cigars”. In this example and
the next, the covariance matrix is diagonal, so all ambient dimensions are
independent of one another. Moreover, the difference between the means and
diagonal are both large along the same dimensions (they are highly correlated
with one another). This is an idealized setting for , because  finds the
direction of maximal variance, which happens to correspond to the direction of
maximal separation. However,  does not weight the discriminant directions
sufficiently, and therefore performs only moderately well.[^2] Because all
dimensions are independent, this is a good scenario for sparse methods. Indeed,
, a sparse classifier designed for precisely this scenario, does an excellent
job finding the most useful ambient dimensions.  does the best of all three
approaches, by using both the difference of the means and the covariance.

[^2]: When having to estimate the eigenvector from the data,  performs even
worse. This is because when $n \ll p$,  is an inconsistent estimator with large
variance @Baik2006[@Paul2007]

Figure [fig:cigars](B) shows an example which is a worst case scenario for using
 to find the optimal projection for classification. In particular, the variance
is getting larger for subsequent dimensions, $\sigma_1 < \sigma_2 < \cdots <
\sigma_p$, while the magnitudes of the difference between the means are
decreasing with dimension, $\delta_1 > \delta_2 < \cdots > \delta_p$. Thus, for
any truncation level,  finds exactly the *wrong* directions. is not hampered by
this problem, it is also able to find the directions of maximal discrimination,
rather than those of maximal variance. Again, , by using both parameters, does
extremely well.

Figure [fig:cigars](C) is exactly the same as (B), except the data have been
randomly rotated in all 1000 dimensions. This means that none of the original
coordinates have much information, rather, linear combinations of them do. This
is evidenced by observing the scatter plot, which shows that two dimensions
clearly fail to disambiguate the two classes. , being rotationally invariant,
fails in this scenario as it did in (B). Now, there is no small number of
ambient dimensions that separate the data well, so also fails. However, , by
virtue of being rotationally invariant, is unperturbed by this rotation. In
particular, it is able to “unrotate” the data, to find dimensions that optimally
separate the two classes.

Theoretical Confirmation
------------------------

The above numerical experiments provide the intuition to guide our theoretical
developments.

[thm:LDA] Under the LDA model,  is better than .

In words, it is better to incorporate the mean difference vector into the
projection matrix. The degree of improvement is a function of the embedding
dimension d, the ambient dimensionality p, and the parameters (see Methods for
details and proof).

How many dimensions to keep?
----------------------------

In the above numerical and theoretical investigations, we fixed d, the number of
dimensions to embed into. Much unsupervised manifold learning theory typically
focuses on finding the “true” intrinsic dimensionality of the data. The
analogous question for supervised manifold learning would be to find the true
intrinsic dimensionality of the discriminant boundary. However, in real data
problems, typically, their is no perfect low dimensional representation. Thus,
in all the following simulations, the true ambient dimensionality of the data is
equal to the dimensionality of the optimal discriminant boundary (given infinite
data). In other words, there does not exist a discriminant space that is lower
dimensional than the ambient space, so we cannot find the “intrinsic dimension”
of the data or the discriminant boundary. Rather, we face a trade-off: keeping
more dimensions reduces bias, but increases variance. The optimal bias/variance
trade-off depends on the distribution of the data, as well as the sample size
@Trunk1979. We formalize this notion for the LpA model and proof the following:

[thm:n] Under the LDA model, estimated  is better than .

Note that the degree of improvement is a function of the number of samples n, in
addition to the embedding dimension d, the ambient dimensionality p, and the
parameters (see Methods for details and proof).

Consider again the rotated trunk example as well as a “Toeplitz” example, as
depicted in Figures [fig:properties](A) and (B). In both cases, the data are
sampled from the LDA model, and in both cases, the optimal dimensionality
depends on the particular approach, but is never the true dimensionality.
Moreover,  dominates the other approaches, regardless of the number of
dimensions used. Figure [fig:properties](C) shows a sparse example with “fat
tails” to mirror real data settings better. The qualitative results are
consistent with those of (A) and (B). Indeed, we can generalize Theorem [thm:n]
to include “sub-Gaussian” data, rather than just Gaussian:

[thm:FAT] Under a sub-Gaussian generalization of the LDA model,  is still better
than .

Multiple Classes
----------------

 can trivially be extended to $>2$ class situations. Naively it may seem like we
would need to keep all pairwise differences between means. However, given $k$
classes, the set of all $k^2$ differences is only rank $k-1$. In other words, we
can equivalently find the class which has the maximum number of samples
(breaking ties randomly), and subtract its mean from all other class means.
Figure [fig:properties](D) shows a 3-class generalization of (A). While  uses
the additional class naturally, many previously proposed high-dimensional
 variants, such as , natively only work for 2-classes.

![ Seven simulations demonstrating that even when the true discriminant boundary is high-dimensional,  can find a low-dimensional projection that wins the bias-variance trade-off against competing methods. For the first four, the top panels depict the means (top), the shared covariance matrix (middle). For the next three, the top panels depict a 2D scatter plot (left), mean and level set of one standard deviation of covariance matrix (right). For all seven simulations, the bottom panel shows misclassification rate as a function of the number of embedded dimensions, for several different classifiers. The simulations settings are as follows: **(A)** Rotated Trunk: same as Figure [fig:cigars](C). **(B)** Toeplitz: another setting where mean difference is not well correlated with any eigenvector, and no ambient coordinate is particularly useful on its own. **(C)** Fat Tails: a common phenomenon in real data; we have theory to support this generalization of the LDA model. **(D)** 3 Classes:  naturally adapts to multiple classes. **(E)** QDA: QOQ, a variant of  when each class has a unique covariance, outperforms , as expected. **(F)** Outliers: adding high-dimensional outliers degrades performance of standard eigensolvers, but those can easily be replaced in  for a robust variants (called ). **(F)** XOR: a high-dimensional stochastic generalization of XOR, demonstrating the  and QOQ work even in scenarios that are quite distinct from the original motivating problems. In all 7 cases, , or the appropriate generalization thereof, outperforms unsupervised, sparse, or other methods. Moreover, the optimal embedding dimension is never the true discriminant dimension, but rather, a smaller number jointly determined by parameter settings and sample size. ](<../Figs/properties.pdf>)

Generalizations of
-------------------

The simple geometric intuition which led to the development of  suggests that we
can easily generalize  to be more appropriate for more complicated settings. We
consider three additional scenarios:

Sometimes, it makes more sense to model each class as having a unique covariance
matrix, rather than a shared covariance matrix. Assuming everything is Gaussian,
the optimal classifier in this scenario is called Quadratic Discriminant
Analysis (QDA) @TBF01. Intuitively then, we can modify  to compute the
eigenvectors separately for each class, and concatenate them (sorting them
according to their singular values). Moreover, rather than classifying the
projected data with , we can then classify the projected data with QDA. Indeed,
simulating data according to such a model (Figure [fig:properties](E),  performs
slightly above chance, regardless of the number of dimensions we use to project,
whereas QOQ (which denotes we estimate eigenvectors separately and then use QDA
on the projected data) performs significantly better regardless of how many
dimensions it keeps.

Outliers persist in many real data sets. Finding outliers, especially in
high-dimensional data, is both tedious and difficult. Therefore, it is often
advantageous to have estimators that are robust to certain kinds of outliers
@Huber1981[@Rousseeuw1999; @Qin2013a].  and eigenvector computation are
particularly sensitive to outliers @Candes2009a. Because  is so simple and
modular, we can replace typical eigenvector computation with a robust variant
thereof, such as @Zhang2014. Figure [fig:properties](F) shows an example where
we generated $n/2$ training samples according to the simple LDA model, but then
added another $n/2$ training samples from a noise model.  (our robust variant of
 that simply replaces the fragile eigenvector computation with a robust
version), performs better than  regardless of the number of dimensions we keep.

XOR is perhaps the simplest nonlinear problem, the problem that led to the
demise of the perceptron, prior to its resurgence after the development of
multi-layer perceptrons @Bishop2006. Thus, in our opinion, it is warranted to
check whether any new classification method can perform well in this scenario.
The classical (two-dimensional) XOR problem is quite simple: the output of a
classifier is zero if both inputs are the same (00 or 11), and the output is one
if the inputs differ (01 or 10). Figure [fig:properties](G) shows a high
dimensional and stochastic variant of XOR. This simulation was designed such
that standard classifiers, such as support vector machines and random forests,
achieve chance levels (not shown). , performs moderately better than chance, and
QOQ performs significantly better than chance, regardless of the chosen
dimensionality. This demonstrates that our classifiers developed herein, though
quite simple and intuition, can perform well even in settings where the data are
badly modeled by our underlying assumptions. This mirrors previous findings
where the so-called “idiots’s Bayes” classifier outperforms more sophisticated
classifiers @Bickel2004. In fact, we think of our work as finding intermediate
points between idiot’s Bayes (or naive Bayes) and , by enabling degrees of
regularization by changing the dimensionality used.

Computational Efficiency
------------------------

In many applications, the main quantifiable consideration in whether to use a
particular method, other than accuracy, is numerical efficiency. Because
implementing  requires only highly optimized linear algebraic routines—including
computing moments and singular value decomposition—rather than the costly
iterative programming techniques currently required for sparse or dictionary
learning type problems. To quantify the computational efficiency of  and its
variants, Figure [fig:speed] shows the wall time it takes to run each method on
the stacked cigars problem, varying the ambient dimensionality, embedded
dimensionality, and sample size. Note that for completeness, we include two
additional variants of :  and .  (short for fast ) replaces the standard
 algorithm with a randomized variant, which can be much faster in certain
situations @Halko2011.  goes even one step further, replacing  with random
projections @Candes06a. This variant of  is the fastest, its runtime is least
sensitive to (p,d,n), and its accuracy is often commensurate (or better) than
other variants of . We will explore Ra in future work. Note that the runtime of
all the variants of  are quite similar to . Given, given ’s improved accuracy,
and nearly identical simplicity, it seems there is very little reason to not use
 instead of .

![ Computational efficiency of various low-dimensional projection methods. In all cases, n=100, and we used the “stacked cigars” simulation parameters. We compare  with the projection steps from , QOQ, , , and , for different values of (p,d). The addition of the mean difference vector is essentially negligible. Moreover, for small d, the  is advantageous.  is always fastest, and its performance is often comparable to other methods (not shown). ](<../Figs/speed_test.pdf>)

Benchmark Real Data Applications
--------------------------------

To more comprehensively understand the relative advantages and disadvantages of
 with respect to other high-dimensional classification approaches, in addition
to evaluating its performance in theory, and in a variety of numerical
simulations, it is important to evaluate it also on benchmark datasets. For
these purposes, we have selected four commonly used high-dimensional datasets
(see Methods for details). For each, we compare  to (i) support vector machines,
(ii) , (iii) lasso, (iv) and random forest (RF). Because in practice all these
approaches have “hyperparameters” to tune, we consider several possible values
for SVM, lasso, and  (but not RF, as its runtime was too high). Figure
[fig:realdata] shows the results for all four datasets.

Qualitatively, the results are similar across datasets:  achieves high accuracy
and computational efficiency as compared to the other methodologies. Considering
Figure [fig:realdata](A) and (B), two popular sparse settings, we find that  can
find very low dimensional projections with very good accuracy. For the prostate
data, with a sufficiently non-sparse solution for , it slightly outperforms ,
but at substantial computational cost, in particular, takes about 100 times
longer to run on this dataset. Figure [fig:realdata](C) and (D) are 10-class
problems, so is no longer possible. Here, SVM can again slightly outperform ,
but again, requiring 100 fold additional computational time. In all cases, the
beloved random forest classifier performs subpar.

![ For four standard datasets, we benchmark  (green circles) versus standard classification methods, including support vector machines (blue up triangles), (cyan down triangles),  (magenta pluses), and random forest (orange diamonds). Top panels show error rate as a function of log$_2$ number of embedded dimensions (for , , and ) or cost (for SVM). Bottom panels show the minimum error rate achieved by each of the five algorithms versus time. The lower left dark gray (upper right light gray) rectangle is the area in which any algorithm is *better* (worse) than  in terms of both accuracy and efficiency. **(A)** Prostate: a standard sparse dataset. 1-dimensional  does very well, although keeping $2^5$ ambient coordinates slightly improves performance, at a significant cost of compute time (two orders of magnitude), with minimal additional interpretability. **(B)** Colon: another standard sparse dataset. Here, 2-4 dimensions of  outperforms all other approaches considered. **(C)** MNIST: 10 image categories here, so is not possible.  does very well regardless of the number of dimensions kept. SVN marginally improves on  accuracy, at a significant cost in computation (two orders of magnitude). **(D)** CIFAR-10: a higher dimensional and newer 10 category image classification problem. Results are qualitatively similar to (C). Note that, for none of the problems is there an algorithm ever performing better and faster than ; rather, most algorithms typically perform worse and slower (though some are more accurate and much more computationally expensive. This suggests that regardless of how one subjectively weights computational efficiency versus accuracy,  is the best default algorithm in a variety of real data settings. ](<../Figs/realdata.pdf>)

Extensions to Other Supervised Learning Problems
------------------------------------------------

The utility of incorporating the mean difference vector into supervised machine
learning for wide data extends beyond merely classification. In particular,
hypothesis testing can be considered as a special case of classification, with a
particular loss function. Therefore we apply the same idea to a hypothesis
testing scenario. The multivariate generalization of the t-test, called
Hotelling’s Test, suffers from the same problem as does the classification
problem; namely, it requires inverting an estimate of the covariance matrix. To
mitigate this issue in the hypothesis testing scenario, authors have applied
similar tricks as they have done in the classification setting. One particularly
nice and related example is that of Lopes et al. @Lopes2011, who addresses this
dilemma by using random projections to obtain a low-dimensional representation,
following by applying Hotelling’s Test in the lower dimensional subspace. Figure
[fig:generalizations](A) and (B) shows the power of their test alongside the
power of the same approach, but using the  projection rather than random
projections. The two different simulations include the simulated settings
considered in their manuscript (see Methods for details). The results make it
clear that the  test has higher power for essentially all scenarios. Moreover,
it is not merely the replacing random projections with , nor simply
incorporating the mean difference vector, but rather, it appears that  for
testing uses both modifications to improve performance.

High-dimensional linear regression is another supervised learning method that
can utilize this idea. Linear regression, like classification and Hotelling’s
Test, requires inverting a singular matrix as well. By projecting the data only
a lower dimensional subspace first, followed by linear regression on the
low-dimensional data, we can mitigate the curse of high-dimensions. To choose
the projection matrix, we partition the data into K partitions, based on the
percentile of the target variable, we obtain a K class classification problem.
Then, we can apply  to learn the embedding. Figure [fig:generalizations](C)
shows an example of this approach, contrasted with lasso and partial least
squares, in a sparse simulation setting (see Methods for details).  is able to
find a better low-dimensional projection than lasso, and performs significantly
better than PLS, for essentially all choices of number of dimensions to embed
into.

![ The intuition of including the mean difference vector is equally useful for other supervised manifold learning problems, including testing and regression. (A) and (B) show two different high-dimensional testing settings, as described in Methods. Power is plotted against the decay rate of the spectrum, which approximates the effective number of dimensions.  composed with Hotelling’s test outperforms the random projections variants described in @Lopes2011, as well as several other variants. (C) shows a high-dimensional regression settings, as described in Methods. Log$_{10}$ mean squared error is plotted against the number of embedded dimensions. Regression  composed with linear regression outperforms  (cyan), the classic sparse regression method, as well as partial least squares (PLS; black). In the legend, ’A’ denote either ’linear regression’ (in (C)), or ’Hotelling’ (in (A) and (B)). These three simulation settings therefore demonstrate the generality of this technique. ](<../Figs/regression_power.pdf>)

Discussion
==========

We have introduced a very simple, yet new, device to improve performance on
supervised learning problems with wide data. In particular, we have proposed a
supervised manifold learning procedure, the utilizes both the difference of the
means, and the covariance matrices. This is in stark contrast to previous
approaches, which only utilize the covariance matrices (or kernel variants
thereof), or solve a difficult optimization theoretic problem. In addition to
demonstrating the accuracy and numerical efficiency of  on simulated and real
classification problems, we also demonstrate how the same idea can also be used
for other kinds of supervised learning problems, including regression and
hypothesis testing.

One of the first publications to compose  with an unsupervised learning method
was the celebrated Fisherfaces paper @Belhumeur1997. The authors showed via a
sequence of numerical experiments the utility of embedding with  prior to
classifying with . We extend this work by adding a supervised component to the
initial embedding. Moreover, we provide the geometric intuition for why and when
this is advantageous, as well as show numerous examples demonstrating its
superiority. Finally, we have matrix concentration inequalities proving the
advantages of  over Fisherfaces.

The LOL idea, appending the mean difference vector to convert unsupervised
manifold learning to supervised manifold learning, has many potential
applications. We have presented the first few. Incorporating additional
nonlinearities via kernel methods @Mika1999, ensemble methods such as random
forests @Breiman2001, multiscale methods @Allard12a, and more scalable
implementations @Chang2011, are all of immediate interest.

![Table of algorithms and their properties for high-dimensional data. Gray elements indicate that results are demonstrated in the Figure labeled in the bottom row. ’X’ denotes relatively good performance for a given setting, or has the particular property. ](<../Figs/table.pdf>)

Theory
======

The Classification Problem
--------------------------

Let $(\bX,Y)$ be a pair of random variables, jointly sampled from $F
:=F_{\bX,Y}=F_{\bX|Y}F_{Y}$. Let $\bX$ be a multivariate vector-valued random
variable, such that its realizations live in p dimensional Euclidean space, $\bx
\in \Real^p$. Let $Y$ be a categorical random variable, whose realizations are
discrete, $y \in \{0,1,\ldots C\}$. The goal of a classification problem is to
find a function $g(\bx)$ such that its output tends to be the true class label
$y$:

$$
\begin{aligned}
 %\label{eq:bayes}
g^*(\bx) := \argmax_{g \in \mc{G}} \PP[g(\bx) = y].\end{aligned}
$$

When the joint distribution of the data is known, then the Bayes optimal
solution is:

$$
\begin{aligned}
  \label{eq:R}
g^*(\bx) := \argmax_y f_{y|\bx} = \argmax_y f_{\bx|y}f_y =\argmax_y \{\log f_{\bx|y} + \log f_y \}\end{aligned}
$$

Denote expected misclassification rate of classifier $g$ for a given joint
distribution $F$,

$$
\begin{aligned}
L^F_g := \EE[g(\bx) \neq y] := \int \PP[g(\bx) \neq y] f_{\bx,y} d\bx dy,\end{aligned}
$$

where $\EE$ is the expectation, which in this case, is with respect to $F_{XY}$.
For brevity, we often simply write $L_g$, and we define $L_* := L_{g^*}$.

Linear Discriminant Analysis (LDA) Model
----------------------------------------

A statistical model is a family of distributions indexed by a parameter $\bth
\in \bTh$, $\mc{F}_{\bth}=\{F_{\bth} : \bth \in \bTh \}$. Consider the special
case of the above where $F_{\bX|Y=y}$ is a multivariate Gaussian distribution,
$\mc{N}(\bmu_y,\bSig)$ and $F_Y$ is a categorical distribution $\mc{C}(\bpi)$,
where $\bpi=(\pi_1,\ldots,\pi_C)$ and $\PP[Y=y]$ is $\pi_y$. In this scenario,
the different classes have different means, but a shared covariance matrix. We
refer to this model as the Linear Discriminant Analysis (LDA) model. Let
$\bth=(\bpi,\bmu,\bSig)$, and let $\bTh_{LDA}=( \triangle_C, \Real^{p \times
C},\Real_{\succ 0}^{p \times p})$, where $\bmu=(\bmu_1,\ldots, \bmu_C)$,
$\triangle_C$ is the $C$ dimensional simplex, that is $\triangle_C = \{ \bx :
x_i \geq 0 \forall i, \sum_i x_i = 1\}$, and $\Real_{\succ 0}^{p \times p}$ is
the set of positive definite $p \times p$ matrices. Denote
$\mc{F}_{LDA}=\{F_{\bth} : \bth \in \bTh_{LDA}\}$.

Define

$$
\begin{aligned}
g_{LDA}(\bx)&=\argmin_y \frac{1}{2} (\bx-\bmu_0)\T \bSig^{-1}(\bx-\bmu_0) + \II\{Y=y\}  \log \pi_y,\end{aligned}
$$

where $\II\{ \cdot\}$ is one when its argument is true, and zero otherwise. Let
$L_{LDA}$ be the misclassification rate of the above classifier.

For any $F \in \mc{F}_{LDA}$, $L_{LDA}=L_*$.

Under the LDA model, the Bayes optimal classifier is available by plugging the
explicit distributions into Eq. .

Under the two-class model, with equal class prior and centered means,
$\pi_0=\pi_1$ and $(\bmu_0+\bmu1)/2=0$, re-arranging a bit, we obtain

$$
\begin{aligned}
g_{LDA}(\bx) :=  \argmin_y \bx\T \bSig^{-1} \bmu_y = \II\{ \bx\T \bSig^{-1} \bdel > 0 \},\end{aligned}
$$

where $\bdel=\bmu_0-\bmu_1$. In words, the Bayes optimal classifier, under the
LDA model, takes the input vector $\bx$, and projects it onto the real number
line with projection matrix $\bSig^{-1} \bdel$. If the resulting projection is
greater than $0$, then $\mh{y}=1$, otherwise, $\mh{y}=0$. Note that the equal
class prior and centered means assumptions merely changes the threshold constant
from $0$ to something else.

Projection Based Classifiers
----------------------------

Let $\bA \in \Real^{d \times p}$ be an orthonormal matrix, that is, a matrix
that projects p dimensional data into a d dimensional subspace, where $\bA\bA\T$
is the $d \times d$ identity matrix, and $\bA\T \bA$ is symmetric $p \times p$
matrix with rank d. The question that motivated this work is: what is the best
projection matrix that we can estimate, to use to “pre-process” the data prior
to applying LDA. Projecting the data $\bx$ onto a low-dimensional subspace, and
the classifying via LDA in that subspace is equivalent to redefining the
parameters in the low-dimensional subspace, $\bSig_A=\bA \bSig \bA\T \in
\Real^{d \times d}$ and $\bdel_A = \bA \bdel \in \Real^d$, and then performing

$$
\begin{aligned}
 \label{eq:g_A}
g_A(x) := \II \{ (\bA \bx)\T \bSig^{-1}_A \bdel_A > 0\}.\end{aligned}
$$

Let $L_A :=\int \PP[g_A(\bx)=y] f_{\bx,y} d\bx dy$. Our goal therefore is to be
able to choose $A$ for a given parameter setting $\bth=(\bdel,\bSig)$, such that
$L_A$ is as small as possible (note that $L_A$ will never be smaller than
$L_*$).

Formally, we seek to solve the following optimization problem:

$$
\label{eq:A}
\begin{aligned}
& \underset{\bA}{\text{minimize}}
& & \EE [ \II \{ \bx\T \bA\T \bSig^{-1}_A \bdel_A > 0\} \neq y] \\
& \text{subject to} & & \bA \in \Real^{p \times d}, \quad \bA \bA\T = \bI_{d \times d},
\end{aligned}
$$

where $\bI_{u \times v}$ is the $u \times v$ identity matrix identity, that is,
$\bI(i,j)=1$ for all $i=j \leq \min(u,v)$, and zero otherwise. In our opinion,
Eq.  is the simplest supervised manifold learning problem there is: a two-class
classification problem, where the data are multivariate Gaussians with shared
covariances, the manifold is linear, and the classification is done via LDA.
Nonetheless, solving Eq.  is difficult, because we do not know how to evaluate
the integral analytically, and we do not know any algorithms that are guaranteed
to find the global optimum in finite time. This has led to previous work using a
surrogate function @not[@sure; @who]. We proceed by studying a few natural
choices for $\bA$.

### Bayes Optimal Projection

For any $F \in \mc{F}_{LDA}$, $L_{\bdel\T \bSig^{-1}} = L_*$

Let $\bB = (\bSig^{-1} \bdel)\T = \bdel\T (\bSig^{-1})\T = \bdel\T \bSig^{-1}$,
so that $\bB\T = \bSig^{-1} \bdel$, and plugging this in to Eq. , we obtain

$$
\begin{aligned}
g_{B}(x) &= \II \{ \bx \bB\T  \bSig^{-1}_{B} \bdel_{B} > 0\}
\\&= \II \{ \bx\T \bSig^{-1} \bdel \times (\bSig^{-1}_{B} \bdel_{B}) > 0\}
\\&= \II \{ \bx\T \bSig^{-1} \bdel k > 0\},\end{aligned}
$$

where the third equality follows from the fact that $(\bSig^{-1}_{B} \bdel_{B})$
is just a positive constant $k > 0$. In other words, letting $\bB$ be the Bayes
optimal projection recovers the Bayes classifier, as it should.

### Principle Components Analysis () Projection

Principle Components Analysis () finds the directions of maximal variance in a
dataset.  is closely related to eigendecompositions and singular value
decompositions (). In particular, the top principle component of a matrix $\bX
\in \Real^{p \times n}$, whose columns are centered, is the eigenvector with the
largest corresponding eigenvalue of the centered covariance matrix $\bX \bX\T$.
 enables one to estimate this eigenvector without ever forming the outer product
matrix, because  factorizes a matrix $\bX$ into $\bU \bS \bV\T$, where $\bU$ and
$\bV$ are orthonormal ${p \times n}$ matrices, and $\bS$ is a diagonal matrix,
whose diagonal values are decreasing, $s_1 \geq s_2 \geq \cdots > s_n$. Defining
$\bU =[\bu_1, \bu_2, \ldots, \bu_n]$, where each $\bu_i \in \Real^p$, then
$\bu_i$ is the $i^{th}$ eigenvector, and $s_i$ is the square root of the
$i^{th}$ eigenvalue of $\bX \bX\T$. Let $\bA^{PCA}_d =[\bu_1, \ldots , \bu_d]$
be the truncated  orthonormal matrix.

The  matrix is perhaps the most obvious choice of a orthonormal matrix for
several reasons. First, truncated  minimizes the squared error loss between the
original data matrix and all possible rank d representations:

$$
\begin{aligned}
\argmin_{A \in \Real^{d \times p} : \bA \bA\T = \bI_{d \times d}} \norm{ \bX - \bA^T \bA }_F^2.\end{aligned}
$$

Second, the ubiquity of  has led to a large number of highly optimized numerical
libraries for computing  (for example, LAPACK @Anderson1999).

Moreover, let $\bU_d=[\bu_1,\ldots,\bu_d] \in \Real^{p \times d}$, and note that
$\bU_d\T \bU_d = \bI_{d \times p}$ and $\bU_d\T \bU_d  = \bI_{p \times d}$.
Similarly, let $\bU \bS \bU\T = \bSig$, and $\bU \bS^{-1} \bU\T = \bSig^{-1}$.
Let $\bS_d$ be the matrix whose diagonal entries are the eigenvalues, up to the
$d^{th}$ one, that is $\bS_d(i,j)=s_i$ for $i=j \leq d$ and zero otherwise.
Similarly, $\bSig_d=\bU \bS_d \bU\T=\bU_d \bS_d \bU_d\T$.

Let $g_{PCA_d}:=g_{A^{PCA}_d}$, and let $L_{PCA_d}:=L_{A^{PCA}_d}$. And let
$g_{LDA_d} := \II \{ x \bSig_d^{-1} \bdel > 0\}$ be the regularized  classifier,
that is, the  classifier, but sets the bottom $p-d$ eigenvalues to zero.

$L_{A^{PCA}_d} = L_{LDA_d}$.

Plugging $\bU_d$ into Eq.  for $\bA$, and considering only the left side of the
operand, we have

$$
\begin{aligned}
(\bA \bx)\T \bSig^{-1}_A \bdel_A &= \bx\T \bA\T \bA \bSig^{-1} \bA\T \bA \bdel,
\\&= \bx\T  \bU_d\bU_d\T \bSig^{-1} \bU_d\bU_d\T \bdel,
\\&= \bx\T  \bU_d \bU_d\T \bU \bS^{-1} \bU \bU_d\bU_d\T \bdel,
\\&= \bx\T  \bU_d \bI_{d \times p} \bS^{-1} \bI_{p \times d} \bU_d\T \bdel,
\\&= \bx\T  \bU_d \bS^{-1}_d  \bU_d\T \bdel ,
\\&= \bx\T  \bSig^{-1}_d  \bdel.\end{aligned}
$$

The implication of this lemma is that if one desires to implement Fisherfaces,
rather than first learning the eigenvectors and then learning , one can instead
directly implement regularized  by setting the bottom $p-d$ eigenvalues to zero.

### Linear Optimal Low-Rank () Projection

The basic idea of  is to let $\bA^{LOL}_d=[\bdel, \bA^{PCA}_{d-1}]$. In other
words, we simply concatenate the mean difference vector with the top $d-1$
principal components. Technically, to maintain orthonormality, we must
orthonormalize, $\bA^{LOL}_d= ([\bdel, \bA^{PCA}_{d-1}])$. Below, we show that
this orthonormalization does not matter very much.

###  is rotationally invariant

For certain classification tasks, the ambient coordinates have intrinsic value,
for example, when simple interpretability is desired. However, in many other
contexts, interpretability is less important @Breiman01b. When the exploitation
task at hand is invariant to rotations, then we have no reason to restrict our
search space to be sparse in the ambient coordinates, rather, for example, we
can consider sparsity in the eigenvector basis. Fisherfaces is one example of a
rotationally invariant classifier, under certain model assumptions. Let $\bW$ be
a rotation matrix, that is $\bW \in \mc{W}=\{\bW : \bW\T = \bW^{-1}$ and
det$(\bW)=1\}$. Moreover, let $\bW \circ F$ denote the distribution $F$ after
rotation by $\bW$. For example, if $F=\mc{N}(\bmu,\bSig)$ then $\bW \circ
F=\mc{N}(\bW  \bmu, \bW \bSig \bW\T)$.

A rotationally invariant classifier has the following property:

$$
L_g^F = L_g^{W \circ F}, \qquad F \in \mc{F}.
$$

In words, the Bayes risk of using classifier $g$ on distribution $F$ is
unchanged if $F$ is first rotated, for any $F \in \mc{F}$.

Now, we can state the main lemma of this subsection:  is rotationally invariant.

[lem:rot] $L_{\Fld}^F = L_{\Fld}^{W \circ F}$, for any $F \in \mc{F}$.

 simply becomes thresholding $\bx\T \bSig^{-1} \bdel$. Thus, we can demonstrate
rotational invariance by demonstrating that $\bx\T \bSig^{-1} \bdel$ is
rotationally invariant.

$$
\begin{aligned}
% \bx\T \bSig^{-1} \bdel &=
(\bW \bx) \T  (\bW \bSig \bW\T )^{-1} \bW \bdel  %& \text{from Lemma \ref{lem:rot}}\\
&= \bx\T \bW\T  (\bW \bU \bS \bU\T \bW\T)^{-1} \bW \bdel & \text{by substituting $\bU \bS \bU\T$ for $\bSig$} \\
&= \bx\T \bW\T  (\mt{\bU} \bS \mt{\bU}\T)^{-1} \bW \bdel & \text{by letting $\mt{\bU}=\bW \bU$} \\
&= \bx\T \bW\T  (\mt{\bU} \bS^{-1} \mt{\bU}\T) \bW \bdel & \text{by the laws of matrix inverse} \\
&= \bx\T \bW\T  \bW \bU \bS^{-1}  \bU\T \bW\T \bW \bdel & \text{by un-substituting $\bW \bU=\mt{\bU}$} \\
&= \bx\T  \bU \bS^{-1}  \bU\T  \bdel  & \text{because $\bW\T \bW = \bI$} \\
&= \bx\T   \bSig^{-1} \bdel & \text{by un-substituting $\bU \bS^{-1} \bU\T = \bSig$}\end{aligned}
$$

One implication of this lemma is that we can reparameterize without loss of
generality. Specifically, defining $\bW := \bU\T$ yields a change of variables:
$\bSig \mapsto \bD$ and $\bdel \mapsto \bU\T \bdel := \mt{\bdel}$, where $\bD$
is a diagonal covariance matrix. Moreover, let $\bd=(\sigma_1,\ldots,
\sigma_D)\T$ be the vector of eignevalues, then $\bD^{-1} \mt{\bdel}=\bd^{-1}
\odot \mt{\bdel}$, where $\odot$ is the Hadamard (entrywise) product. The
 classifier may therefore be encoded by a unit vector, $\mt{\bd}:= \frac{1}{m}
\bd^{-1} \odot \mt{\bdel}$, and its magnitude, $m:=\norm{\bd^{-1} \odot
\mt{\bdel}}$.

### Rotation of Projection Based Linear Classifiers $g_A$

By a similar arguement as above, one can easily show that:

$$
\begin{aligned}
(\bA  \bW \bx) \T  (\bA \bW  \bSig  \bW\T \bA\T)^{-1} \bA \bW \bdel
&= \bx\T (\bW\T \bA\T) (\bA \bW) \bSig^{-1} (\bW\T \bA\T) (\bA \bW) \bdel \\
&= \bx\T \bY\T \bY \bSig^{-1} \bY\T \bY \bdel \\
&= \bx\T \bZ \bSig^{-1} \bZ\T \bdel \\
&= \bx\T (\bZ \bSig \bZ\T)^{-1} \bdel = \bx\T \mt{\bSig}_d^{-1} \bdel,
% (\bA\T \bA \bx) \T  \bSig^{-1} \bA\T \bA \bdel = (\bA \bx)\T \bSig^{-1}_A \bdel_A.\end{aligned}
$$

where $\bY = \bA \bW \in \Real^{d \times p}$ so that $\bZ=\bY\T \bY$ is a
symmetric ${p \times p}$ matrix of rank $d$. In other words, rotating and then
projecting is equivalent to a change of basis. The implications of the above is:

$g_A$ is rotationally invariant if and only if span($\bA$)=span($\bSig_d$). In
other words,  is the only rotationally invariant projection.

### Simplifying the Objective Function

Recalling Eq. , a projection based classifier is effectively thresholding the
dot product of $\bx$ with the linear projection operator $\bP_A :=\bA\T
\bSig_A^{-1} \bdel_A \in \Real^p$. Unfortunately, the nonlinearity in in Eq. 
makes analysis difficult. However, because of the linear nature of the
classifier and projection matrix operator, an objective function that is simpler
to evaluate is available:

$$
\label{eq:angle}
\begin{aligned}
& \underset{\bA}{\text{minimize}}
& & -\frac{ \bP_A\T \bP_*}{||\bP_A||_2 ||\bP_*||_2},
\\ & \text{subject to} & & \bA \in \Real^{p \times d}, \quad \bA \bA\T = \bI_{d \times d}.
\end{aligned}
$$

[lem:angle] The solution to Eq.  is also the solution to Eq.  for any given $d$.

The minimum of Eq.  is clearly $\bA=\bSig^{-1} \bdel$, which is also the minimum
of Eq. .

Define $\angle(\bP,\bP') = \frac{ \bP\T \bP'}{||\bP||_2 ||\bP'||_2} \in (0,1)$.
Let $\bP_*=\bP_{A_*}=\bSig^{-1} \bdel$, and $\alpha^*_A=\angle(\bP_*,\bP_A)$. A
corollary to the above is:

[cor:angle] $\angle(\bP_A,\bP_*) \leq \angle(\bP_{A'},\bP_*) \implies L_A \leq
L_{A'}$.

i’m not sure this is true.

Note that Corollary [cor:angle] is a stronger statement than Lemma [lem:angle],
and in particular, Corollary [cor:angle] implies Lemma [lem:angle]. Given the
above, we can evaluate various choices of $\bA$ in terms of their induced
projection operator $\bP_A$ and the angle between said projection operators and
the Bayes optimal projection operator.

### Evaluating Different Projections using Eq. 

Based on the above, rather than operating on the non-convex $L_A$, we can
instead analyze the properties of different $\bA$ matrices, and their resulting
projection matrices, $\bP_A$, and their angles with respect to $\bP_*$. More
specifically, we would like to prove something like:

[thm:anglegoal]

$$
\begin{aligned}
 \label{eq:angle_goal}
\angle(\bP_{\Pca},\bP_*) \leq \angle(\bP_{\Lol},\bP_*) \forall \, \bth \in \bTh, \text{ where }\bth = (\bpi,\bdel,\bSig,\bA).\end{aligned}
$$

This would mean that for any $\bth$,  would yield a projection closer than  to
the optimal projection. Recall some basic probability theory which we will use
in the sequel. The distribution $\bX$ is actually mixture of Gaussians: $\bX
\sim \sum_j \pi_j \mc{N}(\bmu_j,\bSig)$. Assume that $\bX$ is mean centered
without loss of generality, to simplify notation. Further assume that we only
have two classes, so the number of mixture components is two, and $\mu_0=-\mu_1$
and $\bdel=2 \bmu_0=2 \bmu$. When $\bSig$ is diagonal, this factorizes: $\bX
\sim \prod_{i \in [p]} \sum_j \pi_j \mc{N}(\mu_{ij},\sigma_i^2)$. Consider each
$X_i$ separately therefore, we have: $X_i \sim \sum_j \pi_j
\mc{N}(\mu_{ij},\sigma_i^2)$, where mean($X_i$)$=\mb{0}$ by assumption and
var($X_i$)$=\sum_j \pi_j \mu_{i,j}^2 \sigma_i^2=\sum_j \pi_j \mu_i^2
\sigma_i^2$, where the second equality follows from the centered mean
assumption.

To build up to being able to prove Theorem [thm:anglegoal], we start very
simply.

When $d=1$, so $\bA \in \Real^{p}$ is a $p$-dimensional vector, and $\bSig=\bI$
and $\pi_0=\pi_1$. Then (i) $\angle(\bP_{\Lol},\bP_*)=1$ and (ii)
$\angle(\bP_{\Pca},\bP_*) \leq 1$.

First note that when $\bSig=c \bI$, that $\bA_* = \bSig^{-1} \bdel = \bdel$.
Moreover, note that by definition, the first projection vector of $\bA_{\Lol}$
is $\bdel$. Therefore, (i) the lemma is immediate.

Now, to obtain the first principle component, consider the general definition of
variance, and let each $\sigma_i=1$, such that the variance of the $i^{th}$
dimension is var($X_i$)=$\sum_j \pi_j \mu_i^2=\mu_i^2$. In such a scenario, the
eigenvector with the largest eigenvalue (the direction of maximal variance) will
be $\bu_1=(\mu_1^2,\ldots, \mu_p^2)$. Let $\mt{\bu}_1=\bu_1/\norm{\bu_1}$ and
$\mt{\bdel}=\bdel/\norm{\bdel}$. Then, $\mt{\bu}_1\T \mt{\bdel}=1$ if and only
if $\mu_i \in \{\mu,0\}$, for some $\mu \in \Real$.

$\bA_{\Pca_1}=\bA_{\Lol_1}=\bA_*=\mt{\bd}$ when $\bSig=\bD$, $\pi_0=\pi_1$, and
$\bmu_0-\bmu_1=\mb{0}$.

Recall that $\mt{\bd}=\bd \odot \bdel$, where $\bd$ is the diagonal of $\bD$,
and $\odot$ is the Hadamard (elementwise) product. By definition, the first
dimension of  is $\mt{\bd}$, which proves the second equality.

The variance of the $i^{th}$ dimension is var($X_i$)=var($\pi_0
\mc{N}(\mu_{i,0},\sigma_i^2) + \pi_1 \mc{N}(\mu_{i,1},\sigma_i^2)$)= $\sum_j
\pi_j \mu_{i,j}^2 \sigma_i^2$.

Another good thing to prove would be

$$
\begin{aligned}
\bP_{\Pca}\T \bP_* /\norm{\bP_{\Pca}} \norm{\bP_*} - \bP_{\Lol}\T \bP_* /\norm{\bP_{\Lol}} \norm{\bP_*} < t  \text{ whenever } \bdel \in \mc{X}, \bSig \in \mc{Y}, \bA \in \mc{Z},\end{aligned}
$$

for suitable $\mc{X}, \mc{Y}, \mc{Z}$.

This would mean that  is better than  as a projection.

### Probabilistic Extensions of the above

$$
\begin{aligned}
\PP[ \bP_{\Pca} \T \bP_*  - \bP_{\Lol} \T \bP_*  > t \norm{\bP_A} \norm{\bP_*} ] < f(t,p,d),\end{aligned}
$$

which would state that  is better than , again, under suitable assumptions.

In terms of distributiosn of the above, it seems that perhaps we could start
simple. Assume for the moment that $\bdel,\bu_1,\ldots,\bu_p \iid \mc{N}(\bmu_p,
\bSig_p)$, and let $\bLam=(\bu_1,\ldots,\bu_p)\T$, and $\bSig = \bLam\T \bLam$.

The reason the above is probabilistic is because it is under certain assumptiosn
on the *distributions* of $bdel$, $\bSig$, and $\bA$.

Perhaps even simpler is to start with specific assumptions about $\bdel$,
$\bSig$, and $\bA$. Because  is rotationally invariant, I believe that we can
assert, without loss of generality, that $\bSig=\bD$, where $\bD$ is a diagonal
matrix with diagonal entries $\sigma_1,\ldots, \sigma_p$, where all $\sigma_j >
0$. Now, the optimal projection $\bSig^{-1} \bdel$ is just a simple dot product,
$\bd\T \bdel$, where $\bd=$diag($\bD$)$\in \Real^p$.

For example, letting $\bA=\bU_d$, and letting $\bU_i=e_i$ be the unit vector,
with zeros everywhere except a one in the $i^{th}$ position, we have

$$
\begin{aligned}
\bP_A\T \bP_* %&
= \bdel\T \bU_d\T \bU_d \bSig^{-1} \bU_d\T \bU_d \bSig^{-1} \bdel %\\ =
\bdel\T \bSig_d \bSig^{-1} \bSig_d \bSig^{-1} \bdel %\\&
= \bdel\T \bSig^{-2} \bdel.\end{aligned}
$$

So, we want to understand the probability that $\alpha_{PCA}$ is small under
different parameter settings, $\bth \in \bTh$.

Learning Classifiers from Data
------------------------------

In real data problems, however, the true joint distribution is typically not
provided. Instead, what is provided is a set of training data. We therefore
assume the existence of n training samples, each of which has been sampled
identically and independently from the same distribution, $(\bX_i,Y_i) \iid
P_{\bX,Y}$, for $i =1,2,\ldots, n$. We can use these training samples to then
estimate $f_{x|y}$ and $f_y$. Plugging these estimates in to Eq. , we obtain the
Bayes plugin classifier:

$$
\begin{aligned}
 \label{eq:plugin}
\mh{g}^*_n(\bx) := \argmax_y \mh{p}_{\bx|y}\mh{p}_y.\end{aligned}
$$

Under suitable conditions, it is easy to show that this Bayes plugin classifiers
performance is asymptotically optimal. Formally, we know that: $L_{\mh{g}^*_n}
\conv L_{g^*}$.

When the parameters, $\bSig$ and $\bdel$ are unknown, as in real data scenarios,
we can use the training samples to estimate them, and plug them in, as in Eq. :

$$
\begin{aligned}
\mh{g}^*_n(\bx) := \II\{ \bx\T \mh{\bSig}^{-1} \mh{\bdel} > 0 \}.\end{aligned}
$$

This Bayes plugin classifier is called Fisher’s Linear Discriminant (FLD; in
contrast to , which uses the true—not estimated—parameters). Unfortunately, when
$p \gg n$, the estimate of the covariance matrix $\bSig$ will be low-rank, and
therefore, not invertible (because an infinite number of solutions all fit
equally well). In such scenarios, we seek alternative methods, even in the LDA
model.
