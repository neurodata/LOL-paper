train.classifier <- function(data, labels, proj=c("LOL", "LAL", "PCA"), red.p=1)
{
	if (proj == "LOL")
		proj <- LOL(data, fm.conv.R2FM(as.integer(labels)), red.p, 
					type="svd")
	else if (proj == "LAL")
		proj <- LOL(data, fm.conv.R2FM(as.integer(labels)), red.p, 
					type="rand_sparse")
	else if (proj == "PCA") {
		mu <- rowMeans(data)
		center.mat <- sweep(data, 1, mu, "-")
		res <- fm.svd(t(center.mat), red.p, red.p)
		proj <- res$v
	}

	proj.res <- t(data) %*% proj
	lda.res <- lda(as.matrix(fm.conv.FM2R(proj.res)), as.factor(labels))
	list(proj=proj, lda.res=lda.res)
}

predict.classifier <- function(object, newdata)
{
	proj.res <- t(newdata) %*% object$proj
	predict(object=object$lda.res, newdata=as.matrix(fm.conv.FM2R(proj.res)))
}

rand.split.test <- function(data, labels, count, train.percent, red.p)
{
	train.size <- as.integer(ncol(data) * train.percent)
	for (run in 1:count) {
		idxs <- 1:ncol(data)
		train.idxs <- sort(sample(idxs, train.size))
		test.idxs <- which(is.na(pmatch(idxs, train.idxs)))
		train <- data[,train.idxs]
		test <- data[,test.idxs]
		train.labels <- labels[train.idxs]
		truth <- labels[test.idxs]+1

		res <- train.classifier(train, train.labels, proj="LOL", red.p)
		pred <- predict.classifier(object=res, newdata=test)
		# measure the accuracy
		cat("LOL:", sum((as.integer(pred$class) - truth) != 0)/length(pred$class), "\n")
		res <- NULL
		gc()

		res <- train.classifier(train, train.labels, proj="PCA", red.p)
		pred <- predict.classifier(object=res, newdata=test)
		# measure the accuracy
		cat("PCA:", sum((as.integer(pred$class) - truth) != 0)/length(pred$class), "\n")
		res <- NULL
		gc()
	}
}

