# prove_10

library(datasets)
library(cluster)


#######################################
# AGGLOMERATIVE HIERARCHICAL CLUSTERING

# 1. Load the dataset

my_data <- state.x77


# 2. Use hierarchical clustering to cluster the data on all attributes and produce a dendrogram

# computing a distance matrix
distance <- dist(as.matrix(my_data))

# perform the clustering
hc <- hclust(distance)

# plot the dendrogram
plot(hc)

# 3. Repeat the previous item with a normalized dataset and note any differences

# normalizing the data
my_data_scaled <- scale(my_data)

# computing a distance matrix
distance <- dist(as.matrix(my_data_scaled))

# perform the clustering
hc <- hclust(distance)

# plot the dendrogram
plot(hc)

# California is now with Texas. Alaska is still on its own.

# 4. Remove "Area" from the attributes and re-cluster (and note any differences)

# dropping area column
no_area <- my_data_scaled[ ,-8]

# computing a distance matrix
distance <- dist(as.matrix(no_area))

# perform the clustering
hc <- hclust(distance)

# plot the dendrogram
plot(hc)

# Alaska is now grouped with Nevada and California and Texas are no longer together. 

# 5. Cluster only on the Frost attribute and observe the results

# grabbing only frost column
frost_only <- my_data_scaled[ ,7]

# computing a distance matrix
distance <- dist(as.matrix(frost_only))

# perform the clustering
hc <- hclust(distance)

# plot the dendrogram
plot(hc)

# the warmer states are closer together. Alaska is more grouped with the Eastern states


#########
# K MEANS

# 1. Make sure to use a normalized version of the dataset.

my_data_scaled <- scale(my_data)

# 2. Using k-means, cluster the data into 3 clusters. Note the size of each cluster and the mean values. Do you have any insight into why they were divided this way?
  
# cluster into k=5 clusters:
my_clusters <- kmeans(my_data_scaled, 3)

# summary of the clusters
summary(my_clusters)

# Centers (mean values) of the clusters
my_clusters$centers

# Cluster assignments
my_clusters$cluster

# Within-cluster sum of squares
my_clusters$withinss
# total sum of squares across clusters
my_clusters$tot.withinss


# 3. Using a for loop, repeat the clustering process for k = 1 to 25, and plot the total within-cluster sum of squares error for each k-value.

index <- 1:25
total_within_ss <- NULL
for (i in index) {
  my_clusters <- kmeans(my_data_scaled, i)
  total_within_ss[i] <- my_clusters$tot.withinss
}

plot(index, total_within_ss)

# 4. Evaluate the plot from the previous item, and choose an appropriate k-value using the "elbow method" mentioned in your reading. 
# Then re-cluster a single time using that k-value. Use this clustering for the remaining questions.

total_within_ss[-1] - total_within_ss[-25]

# I am going to chose k=8
my_clusters <- kmeans(my_data_scaled, 8)

# summary of the clusters
summary(my_clusters)

# Centers (mean values) of the clusters
my_clusters$centers


# Within-cluster sum of squares
my_clusters$withinss
# total sum of squares across clusters
my_clusters$tot.withinss


# 5. List the states in each cluster.

my_clusters$cluster


# 6. Use "clusplot" to plot a 2D representation of the clustering.

clusplot(my_data_scaled, 
         my_clusters$cluster, 
         color = TRUE, 
         shade = TRUE, 
         labels = 2, 
         lines = 0)

# 7. Analyze the centers of each of these clusters. Can you identify any insight into this clustering?



