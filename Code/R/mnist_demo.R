k <- 15
m <- read.csv("mnist-data.txt", header=FALSE)
m <- m[,1:(dim(m)[2]-1)]
labels <- scan("mnist-labels.txt")

q <- LOL(t(m), labels, k)
for (i in 1:dim(q)[2]) {
  print(c(i, norm(as.matrix(q[,i]), type="1")))
}
