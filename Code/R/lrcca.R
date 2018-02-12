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