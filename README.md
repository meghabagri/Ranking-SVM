# RankingSVM
Learning to rank using svm model in R
LETOR: Benchmark Dataset for Research on  Learning to Rank for Information Retrieval 
2017

Background Scenario
Ranking is the central problem for information retrieval.
Employing machine learning techniques to learn the ranking function is viewed as a promising approach to IR.
No benchmark dataset available for such work.


Problem Statement / Research Question(s)
Learning to rank has been gained increasing attention in IR.
Many methods have been proposed and applied to IR applications. 
The experimental results in the papers were obtained from different   datasets and under different settings.
It was impossible to make a direct comparison between the results.

Motivation
Benchmark datasets, such as Reuters 21578 and RCV1 for text categorization, and SANBI EST for clustering. We need a benchmark datasets for learning model to rank could be developed. 
LETOR (Learning to Rank)

Proposed Solution
The paper provides detailed description of Letor dataset.
Many previous studies have shown that Ranking SVM is an effective algorithm for ranking.
Ranking SVM generalizes SVM to solve the problem of ranking: while traditional SVM works on documents, Ranking SVM adopts partial-order preference for document pairs as its constraints. 
Ranking performances of the state-of-the-arts ranking algorithms on the dataset.
https://medium.com/@nikhilbd/intuitive-explanation-of-learning-to-rank-and-ranknet-lambdarank-and-lambdamart-fe1e17fac418

Proposed Solution
Learning to Rank (LTR) is a class of techniques that apply supervised machine learning (ML) to solve ranking problems.

LETOR
Three subsets in the LETOR dataset for experimental studies: OHSUMED, TD2003, and TD2004. 
Each subset into five parts, denoted as S1, S2, S3, S4, and S5, in order to conduct five-fold cross validation.
25  extracted features from each judged query-document pair in the OHSUMED collection.
44 extracted features for each query-document pair in TREC. 

OHSUMED Dataset
Subset of MEDLINE, a database on medical publications.
348,566 records (out of over 7 million) from 270 medical journals during the period of 1987-1991. 
106 queries, about a medical search.
Total of 16,140 query-document pairs with relevance judgments given by humans.

TREC Dataset
Special track for web information retrieval.
 The web tracks used the “.gov” collection, which is based on a January, 2002 crawl of the “.gov” domain. There are in total 1,053,110 html documents in this collection, together with 11,164,829 hyperlinks. 
Topic distillation 
There are 50 queries and 75 queries in topic distillation tasks of TREC 2003 and 2004, respectively.

Evaluation & Results
We have used area under ROC curve as an evaluation measure.
It is a curve plotted between TPR and FPR.
AUC for fold  1 : 0.6380056 
AUC for fold  2 : 0.581247 
AUC for fold  3 : 0.5442208 
AUC for fold  4 : 0.5676856 
0.5827898-mean error

Evaluation & Results
The ROC curve is created by plotting the true positive rate (TPR) against the false positive rate (FPR) at various threshold settings. The true-positive rate is also known as sensitivity, recall or probability of detection in machine learning. The false-positive rate is also known as the fall-out or probability of false alarm and can be calculated as (1 − specificity). The ROC curve is thus the sensitivity as a function of fall-out. 
True positive: Sick people correctly identified as sick
False positive: Healthy people incorrectly identified as sick
True negative: Healthy people correctly identified as healthy
False negative: Sick people incorrectly identified as healthy
In general, Positive = identified and negative = rejected. Therefore:
True positive = correctly identified
False positive = incorrectly identified
True negative = correctly rejected
False negative = incorrectly rejected

Drawbacks & Future Scope	
Ranking SVM, RankBoost, and all the other existing models are query independent models. However, from the IR point of view, it seems better to employ query-dependent models. 
A new approach completely suitable for ranking is necessary.
Feature selection for ranking is still an unsolved problem and needs more investigations. 

