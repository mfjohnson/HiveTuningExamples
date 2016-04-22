-- Create Simple Hive Partitioned table
set hive.execution.engine=mr;
SET hive.exec.dynamic.partition.mode=nonstrict;
-- SET hive.exec.dynamic.partition=true;
SET hive.exec.compress.output=false;
SET io.seqfile.compression.type=BLOCK;
SET hive.merge.size.per.task=256000000;
SET hive.merge.smallfiles.avgsize=16000000000;
-- Merge small files at the end of a map-only job.
SET hive.merge.mapfiles=true;  

SET hive.merge.mapredfiles=true;
-- SET hive.mergejob.maponly=true; ??

DROP TABLE page_view_stg;
DROP TABLE page_view;

CREATE EXTERNAL TABLE page_view_stg(viewTime String, country String, userid BIGINT,
                page_url STRING, referrer_url STRING,
                ip STRING COMMENT 'IP Address of the User')
COMMENT 'This is the staging page view table'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/staging/page_view_stg';


CREATE TABLE page_view( userid BIGINT,
                page_url STRING, referrer_url STRING,
                ip STRING COMMENT 'IP Address of the User')
COMMENT 'This is the page view table'
PARTITIONED BY(viewTime String, country String)
STORED AS SEQUENCEFILE;



-- Non strict mode insert
INSERT OVERWRITE TABLE page_view PARTITION (viewTime, country) SELECT userid, page_url, referrer_url,ip, viewTime, country FROM page_view_stg where viewTime='1999/01/10' or viewTime='1999/01/11';
Select viewTime, country, count(*) from page_view_stg where viewTime='1999/01/11' group by viewTime, country ;
Select viewTime, country, count(*) from page_view  where viewTime='1999/01/11' group by viewTime, country;