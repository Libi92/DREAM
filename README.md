# DREAM: Diabetic Retinopathy Analysis Using Machine Learning

This project presents a computer-aided screening sys- tem (DREAM) that
analyzes fundus images with varying illumina- tion and fields of view,
and generates a severity grade for diabetic retinopathy (DR) using
machine learning. Classifiers such as the Gaussian Mixture model (GMM),
k-nearest neighbor (kNN), sup- port vector machine (SVM), and AdaBoost
are analyzed for clas- sifying retinopathy lesions from nonlesions. GMM
and kNN clas- sifiers are found to be the best classifiers for bright
and red lesion classification, respectively. A main contribution of
this paper is the reduction in the number of features used for lesion
classification by feature ranking using Adaboost where 30 top features
are selected out of 78. A novel two-step hierarchical classification
approach is proposed where the nonlesions or false positives are
rejected in the first step. In the second step, the bright lesions are
classified as hard exudates and cotton wool spots, and the red lesions
are classified as hemorrhages and micro-aneurysms. This lesion clas-
sification problem deals with unbalanced datasets and SVM or
combination classifiers derived from SVM using the Dempster– Shafer
theory are found to incur more classification error than the GMM and
kNN classifiers due to the data imbalance.