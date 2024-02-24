1. Identify Data
library(jpeg)

cat <- readJPEG('cat.jpeg')
class(cat)
## [1] "array"
dim(cat)
## [1] 1365 2048 3

2. rgb data segmentation and principal component analysis
r <- cat[, , 1] # Data corresponding to r in array
g <- cat[, , 2] # Data corresponding to g in array
b <- cat[, , 3] # Data corresponding to b in array
cat.r.pca <- prcomp(r, center = F) # r PCA
cat.g.pca <- prcomp(g, center = F) # g PCA
cat.b.pca <- prcomp(b, center = F) # b PCA
rgb.pca <- list(cat.r.pca, cat.g.pca, cat.b.pca) # Combine the results of the analysis by rgb

3. Reduce dimensions and save as jpg
pc <- c(2, 10, 50, 100, 300) # Number of dimensions to reduce

for (i in pc) {
    pca.img <- sapply(rgb.pca, function(j) {
        compressed.img <- j$x[, 1:i] %*% t(j$rotation[, 1:i])
    }, simplify = 'array')

    writeJPEG(pca.img, paste('cat_pca_', i, '.jpeg', sep = ''))
}