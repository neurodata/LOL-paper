# m is a D x I matrix. Each column is a training instance and each instance has D features.
# labels contains I labels, one for each training instance
# k specifies #columns of the output matrix
# The output is a D x k matrix.
LOL <- function(m, labels, k) {
  unique.labels <- sort(unique(labels))
  num.labels <- length(unique.labels)
  num.features <- dim(m)[1]
  nv <- k - num.labels
  i <- 1
  qr.matrix <- matrix(rep.int(0, (num.labels + nv) * num.features),
                      num.features, num.labels + nv)
  for (label in unique.labels) {
    select <- labels == label
    qr.matrix[,i] <- rowMeans(m[,select])
    i <- i+1
  }
  
  svd <- irlba(as.matrix(m), nv=0, nu=nv)
  qr.matrix[,i:(num.labels+nv)] <- svd$u
  
  qr.Q(qr(qr.matrix))
}
