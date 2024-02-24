Identify Data

1. Data Download
# https://archive.ics.uci.edu/ml/datasets/Wholesale+customers

2. Read Data
df <- read.csv('Wholesale customers data.csv', stringsAsFactors = F, header = T)

3. Identify Data
library(dplyr)
head(df)
## Channel Region Fresh Milk Grocery Frozen Detergents_Paper Delicassen
## 1 2 3 12669 9656 7561 214 2674 1338
## 2 2 3 7057 9810 9568 1762 3293 1776
## 3 2 3 6353 8808 7684 2405 3516 7844
## 4 1 3 13265 1196 4221 6404 507 1788
## 5 2 3 22615 5410 7198 3915 1777 5185
## 6 2 3 9413 8259 5126 666 1795 1451
df$Channel <- df$Channel %>% as.factor() # Change to Categorical Data Factor
df$Region <- df$Region %>% as.factor() # Change to Categorical Data Factor

4. Identify if there is any missing value
colSums(is.na(df))
## Channel Region Fresh Milk
## 0 0 0 0
## Grocery Frozen Detergents_Paper Delicassen
## 0 0 0 0

5. Verifying descriptive statistics and distribution by variable
summary(df)
## Channel Region Fresh Milk Grocery
## 1:298 1: 77 Min. : 3 Min. : 55 Min. : 3
## 2:142 2: 47 1st Qu.: 3128 1st Qu.: 1533 1st Qu.: 2153
## 3:316 Median : 8504 Median : 3627 Median : 4756
## Mean : 12000 Mean : 5796 Mean : 7951
## 3rd Qu.: 16934 3rd Qu.: 7190 3rd Qu.:10656
## Max. :112151 Max. :73498 Max. :92780
## Frozen Detergents_Paper Delicassen
## Min. : 25.0 Min. : 3.0 Min. : 3.0
## 1st Qu.: 742.2 1st Qu.: 256.8 1st Qu.: 408.2
## Median : 1526.0 Median : 816.5 Median : 965.5
## Mean : 3071.9 Mean : 2881.5 Mean : 1524.9
## 3rd Qu.: 3554.2 3rd Qu.: 3922.0 3rd Qu.: 1820.2
## Max. :60869.0 Max. :40827.0 Max. :47943.0
boxplot(df[, 3:ncol(df)])

6. Changing the Exponential Marking Method
options(scipen = 100)
boxplot(df[, 3:ncol(df)])

7. Outlier removal
temp <- NULL
for (i in 3:ncol(df)) {
    temp <- rbind(temp, df[order(df[, i], decreasing = T), ] %>% slice(1:5))
}
temp %>% arrange(Fresh) %>% head() # There are duplicate
## Channel Region Fresh Milk Grocery Frozen Detergents_Paper Delicassen
## 1 2 3 85 20959 45828 36 24231 1423
## 2 2 3 85 20959 45828 36 24231 1423
## 3 2 2 8565 4980 67298 131 38102 1215
## 4 2 2 8565 4980 67298 131 38102 1215
## 5 1 3 11314 3090 2062 35009 71 2698
## 6 2 3 16117 46197 92780 1026 40827 2944
temp <- distinct(temp) # Dete duplicate
df.rm.outlier <- anti_join(df,temp) # Delete temp from df

8. Check box plot after outlier removal
par(mfrow = c(1, 2))
boxplot(df[, 3:ncol(df)])
boxplot(df.rm.outlier[, 3:ncol(df)])
dev.off()
## null device
## 1



Analyzing, checking and interpreting results

1. Set the number of k clusters (Elbow method)
library(factoextra)
set.seed(1234)
fviz_nbclust(df.rm.outlier[, 3:ncol(df.rm.outlier)], kmeans, method = "wss", k.max = 15) + theme_minimal() + ggtitle("Elbow Method")

2. Set the number of k clusters (Silhouette method)
fviz_nbclust(df.rm.outlier[, 3:ncol(df.rm.outlier)], kmeans, method = "silhouette", k.max = 15) + theme_minimal() + ggtitle("Silhouette Plot")

3. Generate k means model
df.kmeans <- kmeans(df.rm.outlier[, 3:ncol(df.rm.outlier)], centers = 5, iter.max =1000)
df.kmeans
## K-means clustering with 5 clusters of sizes 179, 42, 72, 110, 18
##
## Cluster means:
## Fresh Milk Grocery Frozen Detergents_Paper Delicassen
## 1 4267.933 3751.480 4672.950 2211.313 1550.4469 1036.006
## 2 25332.000 5603.548 7160.024 4144.667 1449.2381 2053.333
## 3 5152.250 12536.694 19616.472 1644.014 8794.1389 1696.653
## 4 14527.509 2606.064 3503.873 3202.073 804.8091 1037.882
## 5 40558.056 3113.444 3814.333 2974.833 684.2778 1271.333
##
## Clustering vector:
## [1] 4 1 1 4 2 1 4 1 1 3 1 4 2 2 2 4 1 1 2 1 4 1 2 2 4 4 4 3 5 2 1 4 2 1 1 2 3
## [38] 3 2 4 3 3 1 3 3 4 3 1 1 5 3 2 1 3 3 4 1 1 1 3 1 1 2 1 1 4 1 2 1 4 1 3 4 1
## [75] 1 3 1 4 4 1 2 4 4 3 3 1 1 1 1 4 3 3 1 4 4 1 3 1 3 4 3 4 4 4 4 4 1 4 1 4 1
## [112] 4 4 5 4 2 1 5 1 1 4 4 1 1 1 1 4 1 4 2 5 4 4 3 1 1 1 5 4 1 4 1 1 3 3 4 1 3
## [149] 1 4 4 3 1 3 1 1 1 1 3 3 1 3 1 1 5 4 4 1 4 1 1 1 1 1 3 3 4 4 1 3 1 4 1 4 4
## [186] 3 3 2 1 1 3 1 1 1 3 4 3 1 1 1 3 3 4 3 1 4 1 1 1 1 4 2 1 1 1 4 1 2 1 4 1 1
## [223] 4 1 5 2 2 4 4 1 3 1 4 4 1 1 3 1 2 1 5 4 1 5 1 1 2 1 3 3 3 4 3 4 1 1 1 5 1
## [260] 1 2 4 4 4 1 4 5 2 5 1 4 4 5 1 1 1 3 2 1 4 1 1 1 4 3 1 3 3 1 3 4 1 3 1 2 3
## [297] 4 4 3 1 1 4 3 1 1 4 4 2 1 1 4 1 4 3 2 4 2 4 4 1 1 1 1 1 3 1 1 3 2 1 3 1 3
## [334] 1 3 4 1 4 3 1 1 4 1 1 1 1 1 4 1 2 1 5 4 1 4 1 1 3 5 1 1 2 4 5 1 3 4 1 4 4
## [371] 4 1 1 1 2 4 4 1 4 4 4 1 2 2 2 4 1 2 3 1 1 1 1 1 1 1 1 3 1 3 1 3 4 2 4 4 4
## [408] 3 2 1 1 1 1 4 1 4 2 5 3 4 1
##
## Within cluster sum of squares by cluster:
## [1] 7488224454 2823135964 9143410363 3900150510 861057236
## (between_SS / total_SS = 70.9 %)
##
## Available components:
##
## [1] "cluster" "centers" "totss" "withinss" "tot.withinss"
## [6] "betweenss" "size" "iter" "ifault"

4. Visualize mean values by cluster
barplot(t(df.kmeans$centers), beside=TRUE, col = 1:6)
legend("topleft", colnames(df[, 3:8]), fill = 1:6, cex = 0.5)

5. Assign clusters to raw data
df.rm.outlier$cluster <- df.kmeans$cluster
head(df.rm.outlier)
## Channel Region Fresh Milk Grocery Frozen Detergents_Paper Delicassen cluster
## 1 2 3 12669 9656 7561 214 2674 1338 4
## 2 2 3 7057 9810 9568 1762 3293 1776 1
## 3 2 3 6353 8808 7684 2405 3516 7844 1
## 4 1 3 13265 1196 4221 6404 507 1788 4
## 5 2 3 22615 5410 7198 3915 1777 5185 2
## 6 2 3 9413 8259 5126 666 1795 1451 1