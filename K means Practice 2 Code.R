1. Identify Data
library(jpeg)
img <- readJPEG('cat.jpeg')
class(img)
## [1] "array"
dim(img)
## [1] 1365 2048 3

2. Spread 3D data in 2D
imgdim <- as.vector(dim(img))
imgRGB <- data.frame(
    x = rep(1:imgdim[2], each = imgdim[1]),
    y = rep(imgdim[1]:1, imgdim[2]),
    R = as.vector(img[, , 1]),
    G = as.vector(img[, , 2]),
    B = as.vector(img[, , 3])
)
head(imgRGB)
## x y R G B
## 1 1 1365 0.09803922 0.2352941 0.1411765
## 2 1 1364 0.09411765 0.2313725 0.1372549
## 3 1 1363 0.09411765 0.2313725 0.1372549
## 4 1 1362 0.09803922 0.2392157 0.1372549
## 5 1 1361 0.10196078 0.2431373 0.1333333
## 6 1 1360 0.09803922 0.2509804 0.1372549
tail(imgRGB)
## x y R G B
## 2795515 2048 6 0.2313725 0.3333333 0.1568627
## 2795516 2048 5 0.2352941 0.3411765 0.1411765
## 2795517 2048 4 0.2352941 0.3411765 0.1411765
## 2795518 2048 3 0.2352941 0.3411765 0.1411765
## 2795519 2048 2 0.2392157 0.3450980 0.1450980
## 2795520 2048 1 0.2392157 0.3450980 0.1450980

3. Reduce the number of colors
kClusters <- c(3, 5, 10, 15, 30, 50) # Number of color clusters to reduce
set.seed(1234)
for (i in kClusters) {
    img.kmeans <- kmeans(imgRGB[, c("R", "G", "B")], centers = i)
    img.result <- img.kmeans$centers[img.kmeans$cluster,]
    img.array <- array(img.result, dim = imgdim)
    writeJPEG(img.array, paste('kmeans_', i, 'clusters.jpeg', sep = ''))
}