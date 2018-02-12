source('./lrcca.R')

LOL <- function(m, labels, k, type=c("svd", "rand_dense", "rand_sparse")) {
    counts <- as.data.frame(table(fm.conv.FM2R(labels)))
    num.labels <- length(counts$Freq)
    num.features <- dim(m)[1]
    nv <- k - (num.labels - 1)
    gr.sum <- fm.groupby(m, 1, fm.as.factor(labels, 2), fm.bo.add)
    gr.mean <- fm.mapply.row(gr.sum, counts$Freq, fm.bo.div)
    diff <- fm.get.cols(gr.mean, 1) - fm.get.cols(gr.mean, 2)
    diff.l2 <- sqrt(as.vector(sum(diff * diff)))
    stopifnot(diff.l2 != 0)
    diff <- diff / diff.l2
    if (nv == 0)
        return(diff)
    if (type == "svd") {
        # compute class conditional mean.
        # Here I assume dimension size is larger than the number of samples.
        # TODO I need to improve groupby to subtract the class conditional mean.
        rlabels <- fm.conv.FM2R(labels) + 1
        fm.materialize(gr.mean)
        mean.list <- list()
        for (i in 1:length(rlabels))
            mean.list[[i]] <- gr.mean[,rlabels[i]]
        mean.mat <- fm.cbind.list(mean.list)

        svd <- fm.svd(m - mean.mat, nv=nv, nu=nv)
        cbind(diff, svd$u)
    }
    else if (type == "rand_dense")
        cbind(diff, fm.rnorm.matrix(length(diff), nv))
    else if (type == "rand_sparse")
        cbind(diff, fm.rsparse.proj(length(diff), nv, 1/sqrt(length(diff))))
    else {
        print("wrong type")
        NULL
    }
}
tcrossprod_mean <- function(V, U) {
  s <- colMeans(V)
  vec <- as.vector(U %*% s)
  vec
}
tcrossprod_pca <- function(V, U, r) {
  V <- fm.as.matrix(V)
  U <- fm.as.matrix(U)
  mul <- function(vec, extra) {
    vec <- as.vector(U %*% (t(V) %*% vec))
    vec <- V %*% (t(U) %*% vec)
  }
  res <- fm.eigen(mul, k=r, n=nrow(V), which="LM", sym=TRUE)
  res$vectors
}

fm.lrcca <- function(X, Y, r, ...) {
  X <- fm.as.matrix(X)
  Y <- as.vector(Y)
  ylabs <- unique(Y)
  K <- length(ylabs)
  n <- nrow(X)
  d <- ncol(X)
  # hot-encoding of Y categorical variables
  Yh <- array(0, dim=c(n, K))
  # Yind is a indicator of membership in each respective class
  for (i in 1:length(ylabs)) {
    Yh[Y == ylabs[i],i] <- 1
  }

  S_y <- cov(Yh)
  S_yi <- MASS::ginv(S_y)

  # covariance matrices cov(X)
  #Xc <- X - outer(rep(1, n), colMeans(X))
  if (nrow(X) < ncol(X)) {
    Xc <- sweep(X, 2, colMeans(X), "-")
    #S_x <- 1/(n-1)*t(Xc) %*% Xc;
    X_cov_mul <- function(vec, extra) 1/(n-1) * t(Xc) %*% (Xc %*% vec)
    res <- fm.eigen(X_cov_mul, k=nrow(X), n=ncol(X), which="LM", sym=TRUE)
  } else {
    S_x <- cov(X)
    res <- eigen(S_x)
  }
  sigma <- res$values[res$values > 1e-6]
  U <- res$vectors[,1:length(sigma)]

  # inverse covariance matrices are ginverse in the low-rank case
  # S_xi <- U %*% diag(1/sigma) %*% t(U)
  # S_xi <- MASS::ginv(S_x);
  # S_xy <- 1/(n-1)*t(Xc) %*% Yc
  S_xy <- cov(X, fm.as.matrix(Yh))

  # decompose Sxi*Sxy*Syi*Syx
  # A <- lol.utils.pca(S_xi %*% S_xy %*% S_yi %*% t(S_xy), r, trans=FALSE)
  Z <- (t(U) %*% S_xy) %*% (S_yi %*% t(S_xy))
  Z <- t(Z)
  U <- U %*% diag(1/sigma)
  A <- tcrossprod_pca(U, Z, r)

  return(list(A=A, Xr=X %*% A, ylabs=ylabs))
}

embed.classifier <- function(data, labels, proj=c("LOL", "LAL", "QOQ", "PCA", "CCA"), red.p=1)
{
	if (proj == "LOL")
		proj <- LOL(data, fm.conv.R2FM(as.integer(labels)), red.p, type="svd")
	else if (proj == "LAL")
		proj <- LOL(data, fm.conv.R2FM(as.integer(labels)), red.p, type="rand_sparse")
	else if (proj == "QOQ")
		proj <- QOQ(data, fm.conv.R2FM(as.integer(labels)), red.p)
	else if (proj == "PCA") {
		mu <- rowMeans(data)
		center.mat <- sweep(data, 1, mu, "-")
		res <- fm.svd(t(center.mat), red.p, red.p)
		proj <- res$v
	} else if (proj == "CCA") {
	  proj <- fm.lrcca(data, fm.conv.R2FM(as.integer(labels)), red.p)
	}
}

train.classifier <- function(data, labels, proj, method="lda")
{
	proj.res <- t(data) %*% proj
	if (method == "lda")
		res <- lda(as.matrix(fm.conv.FM2R(proj.res)), as.factor(labels))
	else if (method == "qda")
		res <- qda(as.matrix(fm.conv.FM2R(proj.res)), as.factor(labels))
	else
		res <- NULL
	list(proj=proj, res=res)
}

predict.classifier <- function(object, newdata)
{
	proj.res <- t(newdata) %*% object$proj
	predict(object=object$res, newdata=as.matrix(fm.conv.FM2R(proj.res)))
}

rand.split.test <- function(data, labels, count, train.percent, red.ps)
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
		print("truth:")
		print(truth)

		proj <- embed.classifier(train, train.labels, proj="LOL", max(red.ps))
		for (red.p in red.ps) {
			res <- train.classifier(train, train.labels, proj[, 1:red.p], method="lda")
			pred <- predict.classifier(object=res, newdata=test)
			print("LOL+LDA predict:")
			print(pred$class)
			# measure the accuracy
			out <- paste("LOL-", red.p, "dim: ",
						 sum((as.integer(pred$class) - truth) != 0)/length(pred$class), sep="")
			print(out)




			res <- train.classifier(train, train.labels, proj[, 2:min(red.p + 1, ncol(proj))], method="lda")
			pred <- predict.classifier(object=res, newdata=test)
			print("RR-LDA predict:")
			print(pred$class)
			# measure the accuracy
			out <- paste("RR-LDA-", red.p, "dim: ",
						 sum((as.integer(pred$class) - truth) != 0)/length(pred$class), sep="")
			print(out)
			res <- NULL
			gc()
		}
		proj <- NULL
		gc()

		proj <- embed.classifier(train, train.labels, proj="CCA", max(red.ps))
		for (red.p in red.ps) {
  		res <- train.classifier(train, train.labels, proj[, 1:red.p], method="lda")
  		pred <- predict.classifier(object=res, newdata=test)
  		print("CCA+LDA predict:")
  		print(pred$class)
  		# measure the accuracy
  		out <- paste("CCA-", red.p, "dim: ",
  		             sum((as.integer(pred$class) - truth) != 0)/length(pred$class), sep="")
  		print(out)
  		res <- NULL
  		gc()
		}
		proj <- NULL
		gc()

		proj <- embed.classifier(train, train.labels, proj="PCA", max(red.ps))
		for (red.p in red.ps) {
			res <- train.classifier(train, train.labels, proj[, 1:red.p], method="lda")
			pred <- predict.classifier(object=res, newdata=test)
			print("PCA+LDA predict:")
			print(pred$class)
			# measure the accuracy
			out <- paste("PCA-", red.p, "dim: ",
						 sum((as.integer(pred$class) - truth) != 0)/length(pred$class), sep="")
			print(out)
			res <- NULL
			gc()
		}
		proj <- NULL
		gc()
	}
}

