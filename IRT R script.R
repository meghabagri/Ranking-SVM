library("data.table")
ohsumed.dt <- fread("data.txt", sep = " ")
ohsumed.dt <- ohsumed.dt[, -c(48,49), with = FALSE] # remove residual cols
col.names <- paste(rep("C", 45), seq(1:45), sep = "")
col.names <- c("r", "qid", col.names, "docid")
setnames(ohsumed.dt, col.names)
letor <- ohsumed.dt
for (j in names(letor)) set(letor,j=j,value= gsub(".*:", "", letor[[j]]))
setcolorder(letor, c(names(letor)[1:2], names(letor)[48], names(letor)[3:47]))
for (j in names(letor)) set(letor,j=j,value= as.numeric(gsub(",","",letor[[j]])))
head(letor[,c(1:10), with = FALSE])
length(unique(letor$qid)) ## number of queries
length(unique(letor$docid))
sum(duplicated(letor)) > 0
sum(apply(as.matrix(letor), 2, function(x) sum(is.na(x)))) > 0 
library("caret")
suppressMessages(require(caret)) ## http://topepo.github.io/caret/index.html
highly.corelated <- caret::findCorrelation(cor(letor[,4:48, with = FALSE], use = "na.or.complete"),cutoff=0.8)
highly.corelated
letor[is.finite(rowSums(letor))]
suppressMessages(require(verification)) # for arear under the ROC
suppressMessages(require(ROCR))         # for performance measurements 
suppressMessages(require(randomForest)) # rf, gbm and svm are also 
suppressMessages(require(gbm))          # included in the caret. 
suppressMessages(require(e1071))        # package
letor$r.bin <- ifelse(letor$r > 1, 1, 0) 
setcolorder(letor, c(names(letor)[1:3], names(letor)[49], names(letor)[4:48]))
set.seed(921981)
rIdx <- sample(length(unique(letor$qid)), length(unique(letor$qid))*0.1)
rqid <- unique(letor$qid)[rIdx]
Test <- as.data.frame(subset(letor, qid %in% rqid))
Train <-  as.data.frame(subset(letor, !(qid %in% rqid))[,c(2,4:48), with = FALSE])
qid.train <- unique(Train$qid)
nsamples <- 4 # ideally a multiple of the number of cores 
set.seed(921980)
rqid2 <- qid.train[sample(length(qid.train), 10, TRUE)]
train <- subset(Train, !(qid %in% rqid2))[,2:ncol(Train)]
suppressMessages(library(doParallel))
suppressMessages(library(foreach))
registerDoParallel(cores = 4)
n = floor(length(qid.train)/nsamples)
err.vect <- rep(NA, nsamples)
cv.train <- foreach (i = 1:nsamples) %dopar% {
    s = (i-1) * n+1
    f = i*n
    sub <- s:f
    cv.qidtrain <-  qid.train[-sub]
    subset(Train, qid %in% cv.qidtrain)[,2:ncol(Train)]
}

cv.test <- foreach (i = 1:nsamples) %dopar% {
    s = (i-1) * n+1
    f = i*n
    sub <- s:f
    cv.qidtest <- qid.train[sub]
    subset(Train, qid %in% cv.qidtest)[,2:ncol(Train)]
}

## The following two lines should be run to adpequately tune the cost and gamma.
## However it takes too long in my personal computer. 
## bestPar <- foreach() tune.svm(x = cv.train[[1]][,-1], y = as.factor(cv.train[[1]][,1]), gamma = 2^(-4:4), cost = 2^(2:10)) 

## run folds in pararell
modelDataSVM <- foreach(i = 1:nsamples, .packages = c("e1071")) %dopar% {

    svm(x = cv.train[[i]][,-1], y = as.factor(cv.train[[i]][,1]),
probability=TRUE, cost=100, gamma=1, na.action =na.omit)

}                

predictSVM <- foreach(i = 1:nsamples, .packages = c("e1071")) %dopar% {

    predict(modelDataSVM[[i]], cv.test[[i]][,-1], probability=TRUE)

}

## AUC 
for (i in 1:nsamples) {

    prob <- attr(predictSVM[[i]], "probabilities")[,2]
    err.vect[i] <- roc.area(cv.test[[i]][,1], prob)$A
    cat("AUC for fold ", i, ":", err.vect[i], "\n")

}
mean(err.vect)
