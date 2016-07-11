library(FlashR)
library(MASS)
source("Rpkg/R/LOL.R")
fm.set.test.na(FALSE)
p <- 16000000
n <- 1000
red.p <- 100
labels <- rep.int(0, n * 2)
labels[(n+1):(2*n)] <- 1

for (p in c(1, 2, 4, 8, 16)) {
	p <- p * 1000000
	cat("p:", p, "\n")
	mu <- 4/sqrt(seq.int(1, 2*p, 2))
	sigma.vec <- 1000/sqrt(seq.int(p, 1, -1))
	# generate the training dataset
	#mat1 <- rmvnorm(n, mu, diag(sigma.vec))
	mat1 <- fm.rnorm.matrix(nrow=n, ncol=p, in.mem=TRUE)
	mat1 <- sweep(mat1, 2, sqrt(sigma.vec), "*")
	mat1 <- sweep(mat1, 2, mu, "+")
	#mat2 <- rmvnorm(n, -mu, diag(sigma.vec))
	mat2 <- fm.rnorm.matrix(nrow=n, ncol=p, in.mem=TRUE)
	mat2 <- sweep(mat2, 2, sqrt(sigma.vec), "*")
	mat2 <- sweep(mat2, 2, -mu, "+")
	mat <- fm.rbind(mat1, mat2)
	# generate the testing dataset
	#test1 <- rmvnorm(100, mu, diag(sigma.vec))
	test1 <- fm.rnorm.matrix(nrow=100, ncol=p, in.mem=TRUE)
	test1 <- sweep(test1, 2, sqrt(sigma.vec), "*")
	test1 <- sweep(test1, 2, mu, "+")
	#test2 <- rmvnorm(100, -mu, diag(sigma.vec))
	test2 <- fm.rnorm.matrix(nrow=100, ncol=p, in.mem=TRUE)
	test2 <- sweep(test2, 2, sqrt(sigma.vec), "*")
	test2 <- sweep(test2, 2, -mu, "+")
	test <- fm.rbind(test1, test2)

	mat1 <- NULL
	mat2 <- NULL
	test1 <- NULL
	test2 <- NULL
	gc()

	for (i in 1:5) {
		#LOL
		start <- Sys.time()
		proj <- LOL(t(mat), fm.conv.R2FM(as.integer(labels)), red.p, type="svd")
		cat("LOL takes", as.integer(Sys.time()) - as.integer(start), "seconds\n")
		start <- Sys.time()
		mat.p <- mat %*% proj
		test.p <- test %*% proj
		cat("LOL projection takes", as.integer(Sys.time()) - as.integer(start), "seconds\n")
		res <- lda(as.matrix(fm.conv.FM2R(mat.p)), as.factor(labels))
		pred <- predict(object=res, newdata=as.matrix(fm.conv.FM2R(test.p)))

		# measure the accuracy
		truth <- rep.int(1, length(pred$class))
		truth[(length(truth)/2 + 1):length(truth)]<-2
		cat("LOL:", sum((as.integer(pred$class) - truth) != 0)/length(pred$class), "\n")

		#LAL
		start <- Sys.time()
		proj <- LOL(t(mat), fm.conv.R2FM(as.integer(labels)), red.p, type="rand_sparse")
		cat("LAL takes", as.integer(Sys.time()) - as.integer(start), "seconds\n")
		start <- Sys.time()
		mat.p <- mat %*% proj
		test.p <- test %*% proj
		cat("LAL projection takes", as.integer(Sys.time()) - as.integer(start), "seconds\n")
		res <- lda(as.matrix(fm.conv.FM2R(mat.p)), as.factor(labels))
		pred <- predict(object=res, newdata=as.matrix(fm.conv.FM2R(test.p)))

		# measure the accuracy
		truth <- rep.int(1, length(pred$class))
		truth[(length(truth)/2 + 1):length(truth)]<-2
		cat("LAL:", sum((as.integer(pred$class) - truth) != 0)/length(pred$class), "\n")
		proj <- NULL
		gc()

		#PCA
		start <- Sys.time()
		mu <- colMeans(mat)
		center.mat <- sweep(mat, 2, mu, "-")
		res <- fm.svd(center.mat, red.p, red.p)
		cat("PCA takes", as.integer(Sys.time()) - as.integer(start), "seconds\n")
		start <- Sys.time()
		mat.p <- mat %*% res$v
		test.p <- test %*% res$v
		cat("PCA projection takes", as.integer(Sys.time()) - as.integer(start), "seconds\n")
		res <- lda(as.matrix(fm.conv.FM2R(mat.p)), as.factor(labels))
		pred <- predict(object=res, newdata=as.matrix(fm.conv.FM2R(test.p)))

		# measure the accuracy
		truth <- rep.int(1, length(pred$class))
		truth[(length(truth)/2 + 1):length(truth)]<-2
		cat("PCA:", sum((as.integer(pred$class) - truth) != 0)/length(pred$class), "\n")
		mu <- NULL
		center.mat <- NULL
		gc()

		#LR-LDA
		start <- Sys.time()
		gr.sum <- fm.groupby(mat, 2, fm.as.factor(fm.conv.R2FM(as.integer(labels)), 2), fm.bo.add)
		counts <- as.data.frame(table(as.integer(labels)))
		gr.mean <- fm.mapply.col(gr.sum, counts$Freq, fm.bo.div, FALSE)
		mean.idxs <- as.integer(labels) + 1
		mean.list <- list()
		for (i in 1:length(labels))
			mean.list[[i]] <- gr.mean[mean.idxs[i],]
		mean.mat <- fm.rbind.list(mean.list)
		res <- fm.svd(mat - mean.mat, nv=red.p, nu=0)
		cat("LR-LDA takes", as.integer(Sys.time()) - as.integer(start), "seconds\n")
		start <- Sys.time()
		mat.p <- mat %*% res$v
		test.p <- test %*% res$v
		cat("LR-LDA projection takes", as.integer(Sys.time()) - as.integer(start), "seconds\n")
		res <- lda(as.matrix(fm.conv.FM2R(mat.p)), as.factor(labels))
		pred <- predict(object=res, newdata=as.matrix(fm.conv.FM2R(test.p)))

		# measure the accuracy
		truth <- rep.int(1, length(pred$class))
		truth[(length(truth)/2 + 1):length(truth)]<-2
		cat("LR-LDA:", sum((as.integer(pred$class) - truth) != 0)/length(pred$class), "\n")
		gr.sum <- NULL
		gr.mean <- NULL
		mean.list <- NULL
		res <- NULL
		gc()

	} # run experiment 5 times.

	mat <- NULL
	test <- NULL
	gc()

} # Vary the dimension size of the input data.
