create database travistorrent;
use travistorrent;
show databases;
show tables;


SELECT distinct(tr_job_id) FROM travistorrent_27_10_2016;


-- git_commit and tr_job_id
-- SELECT count(DISTINCT(t1.tr_job_id)) FROM travistorrent_27_10_2016 t1, travistorrent_27_10_2016 t2 where t1.git_commit=(t2.git_commit);


SELECT count(*), gh_project_name FROM travistorrent_27_10_2016 where tr_tests_fail > 0 GROUP BY gh_project_name;


-- answer is '59798' builds passed and had more than 0 tests fail ie had tests fail
SELECT count(*), gh_lang FROM travistorrent_27_10_2016 WHERE tr_status = "passed" AND tr_tests_fail > 0 GROUP BY gh_lang;
SELECT gh_team_size, count(*) FROM travistorrent_27_10_2016 WHERE tr_status = "passed" AND tr_tests_fail > 0 GROUP BY gh_team_size ORDER BY gh_team_size asc;
SELECT gh_sloc, count(*) FROM travistorrent_27_10_2016 WHERE tr_status = "passed" AND tr_tests_fail > 0 GROUP BY gh_sloc ORDER BY gh_sloc asc;


-- answer is '104.8546' average tr tests failed for each tr build pass
SELECT gh_sloc, sum(tr_tests_fail)/sum(tr_status = "passed") FROM travistorrent_27_10_2016 WHERE tr_status = "passed" AND tr_tests_fail > 0 GROUP BY gh_sloc ORDER BY gh_sloc asc;
SELECT gh_project_name, sum(tr_tests_fail)/sum(tr_status = "passed") FROM travistorrent_27_10_2016 WHERE tr_status = "passed" AND tr_tests_fail > 0 GROUP BY gh_project_name ORDER BY gh_project_name asc;


-- rails/rails and sferik/twitter
SELECT DISTINCT(git_commit) FROM travistorrent_27_10_2016 where gh_project_name = "rails/rails";
SELECT DISTINCT(git_commit) FROM travistorrent_27_10_2016 where gh_project_name = "sferik/twitter";


select t.row, s.tr_build_id 
from test.travistorrent_27_10_2016 as t, test.travistorrent_27_10_2016 as s
where t.tr_prev_build = s.tr_build_id  and t.gh_src_churn=0 and t.gh_test_churn=0 and s.tr_tests_run!=0 and t.tr_tests_fail!=s.tr_tests_fail;
