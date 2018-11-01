travis <- read.csv("C:/Users/Jason/Desktop/travistorrent_27_10_2016.csv")v

job_id <- unique(travis$tr_job_id)
build_id <- unique(travis$tr_build_id)
git_commit <- unique(travis$git_commit)
length(job_id)
# [1] 713613
length(build_id)
# [1] 170772
length(git_commit)
# [1] 162014

uniqueTravis <- unique(travis[,-1])

nrow(travis)
# [1] 1011987
nrow(uniqueTravis)
# [1] 852714