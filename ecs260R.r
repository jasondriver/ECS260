##
## INGEST DATA
##
# install.packages("pvclust")
# install.packages("cluster")
# install.packages("fpc")

travis <- read.csv("C:/Users/Jason/Desktop/travistorrent_30_9_2016.csv", stringsAsFactors=FALSE)



##
## CLEAN UP DATA ##
##
travis$gh_by_core_team_member = travis$gh_by_core_team_member*1
levels(travis$git_branch)
travis$git_commits <- NULL

# true/false statements converted to 1/0 (normalized to 1, not centered on 0)
travis$gh_is_pr = travis$gh_is_pr*1


travis$gh_project_name <- NULL
travis$git_merged_with <- NULL
travis$git_branch <- NULL
travis$gh_first_commit_created_at <- NULL
travis$tr_started_at <- NULL
travis$row <- NULL
travis$tr_jobs <- NULL
travis$tr_job_id <- NULL
travis$gh_pull_req_num <- NULL
travis$tr_tests_ran = travis$tr_tests_ran*1
travis$tr_tests_failed = travis$tr_tests_failed*1

travis$tr_frameworks <- NULL
travis$tr_status <- NULL
travis$tr_analyzer <- NULL
travis$git_commit <- NULL
travis$tr_failed_tests <- NULL
travis$tr_prev_build <- NULL

# normalized to 1, centered around 0
travis$gh_lang <- gsub("java", "-0.5", travis$gh_lang)
travis$gh_lang <- gsub("ruby", "0.5", travis$gh_lang)
travis$tr_lan <- gsub("java", "-0.5", travis$tr_lan)
travis$tr_lan <- gsub("ruby", "0.5", travis$tr_lan)

travis$gh_lang = as.character(travis$gh_lang)
travis$gh_lang = as.numeric(travis$gh_lang)
travis$tr_lan = as.character(travis$tr_lan)
travis$tr_lan = as.numeric(travis$tr_lan)

class(travis$tr_lan)
summary(travis)

# A lot of NAs throughout data.

#  gh_description_complexity (set NA to 0 because no words in pull request)
travis$gh_description_complexity[is.na(travis$gh_description_complexity)] <- 0

#  tr_duration  (replace NA with mean of original)  Mean: 3255    NA's   :2608
travis$tr_duration[is.na(travis$tr_duration)] <- mean(na.exclude(travis$tr_duration))

#  tr_setup_time (remove column: high NAs not sure what to fill instead of NA...) NA's   :418376
travis$tr_setup_time <- NULL

#  tr_tests_ok  Mean : 4915   NA's   :395900
travis$tr_tests_ok[is.na(travis$tr_tests_ok)] <- mean(na.exclude(travis$tr_tests_ok))

#  tr_tests_fail    Mean : 2.6   NA's   :152053
travis$tr_tests_fail[is.na(travis$tr_tests_fail)] <- mean(na.exclude(travis$tr_tests_fail))

#  tr_tests_run   Mean  : 4919    NA's   :396009
travis$tr_tests_run[is.na(travis$tr_tests_run)] <- mean(na.exclude(travis$tr_tests_run))

#  tr_tests_skipped  Mean : 188.2    NA's   :395628
travis$tr_tests_skipped[is.na(travis$tr_tests_skipped)] <- mean(na.exclude(travis$tr_tests_skipped))

#  tr_testduration    NA's   :390273
travis$tr_testduration <- NULL

#  tr_purebuildduration  (remove column: too many NA)  NA's   :896713 
travis$tr_purebuildduration <- NULL



# one NA (lowest number is 0)
travis$tr_tests_ran[is.na(travis$tr_tests_ran)] <- 0
# one NA
travis$tr_tests_failed[is.na(travis$tr_tests_failed)] <- 0
# one NA
travis$git_num_committers[is.na(travis$git_num_committers)] <- 0
# one NA (lowest number is 1)
travis$tr_num_jobs[is.na(travis$tr_num_jobs)] <- 1
# one NA
travis$tr_ci_latency[is.na(travis$tr_ci_latency)] <- 0
# tr_prev_build (swap values with average... maybe try 0 next or take out data)  NA's   :16488
#travis$tr_prev_build[is.na(travis$tr_prev_build)] <- mean(na.exclude(travis$tr_prev_build))

summary(travis)

##
## ANALYZE DATA ##
##
#d <- dist(as.matrix(travis))
#hc <- hclust(d)
#plot(hc)

travis <- scale(travis)

# Determine number of clusters
wss <- (nrow(travis)-1)*sum(apply(travis,2,var))
for (i in 2:15) wss[i] <- sum(kmeans(travis,
                                     centers=i)$withinss)
plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

# K-Means Cluster Analysis
fit <- kmeans(travis, 5) # 5 cluster solution
# get cluster means
aggregate(travis,by=list(fit$cluster),FUN=mean)
# append cluster assignment
travis <- data.frame(travis, fit$cluster) 

# Ward Hierarchical Clustering
d <- dist(travis, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward")
plot(fit) # display dendogram
groups <- cutree(fit, k=5) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters
rect.hclust(fit, k=5, border="red") 

# Ward Hierarchical Clustering with Bootstrapped p values
library(pvclust)
fit <- pvclust(travis, method.hclust="ward",
               method.dist="euclidean")
plot(fit) # dendogram with p values
# add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95) 

# Model Based Clustering
library(mclust)
fit <- Mclust(travis)
plot(fit) # plot results
summary(fit) # display the best model 

# K-Means Clustering with 5 clusters
fit <- kmeans(travis, 5)

# Cluster Plot against 1st 2 principal components

# vary parameters for most readable graph
library(cluster)
clusplot(travis, fit$cluster, color=TRUE, shade=TRUE,
         labels=2, lines=0)

# Centroid Plot against 1st 2 discriminant functions
library(fpc)
plotcluster(travis, fit$cluster)

# comparing 2 cluster solutions
library(fpc)
cluster.stats(d, fit1$cluster, fit2$cluster) 