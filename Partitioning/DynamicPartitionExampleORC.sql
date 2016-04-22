-- Create Simple Hive Partitioned table
set hive.execution.engine=mr;
SET hive.exec.dynamic.partition.mode=nonstrict;

-- Maximum number of dynamic partitions allowed to be created in each mapper/reducer node
SET hive.exec.max.dynamic.partitions.pernode=100;

-- Maximum number of dynamic partitions allowed to be created in total
SET hive.exec.max.dynamic.partitions=1000;

--Maximum number of HDFS files created by all mappers/reducers in a MapReduce job
SET hive.exec.max.created.files=100000;

-- Whether to throw an exception if dynamic partition insert generates empty results
SET hive.error.on.empty.partition=false;


DROP TABLE IF EXISTS page_view_stg;
DROP TABLE IF EXISTS page_view;

CREATE EXTERNAL TABLE page_view_stg(viewTime String, country String, userid BIGINT,
                page_url STRING, referrer_url STRING,
                ip STRING COMMENT 'IP Address of the User')
COMMENT 'This is the staging page view table'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/staging/page_view_stg';

CREATE EXTERNAL TABLE UserPreferences_stg(userid BIGNINT, preference String)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/staging/UserPreferences_stg';
CREATE TABLE page_view( userid BIGINT,
                page_url STRING, referrer_url STRING,
                ip STRING COMMENT 'IP Address of the User', country STRING)
COMMENT 'This is the page view table'
PARTITIONED BY(viewTime String)
STORED AS SEQUENCEFILE;



-- Non strict mode insert
INSERT OVERWRITE TABLE page_view PARTITION (viewTime) SELECT userid, page_url, referrer_url,ip, country, viewTime FROM page_view_stg;


EXPLAIN Select viewTime, country, count(*) from page_view_stg where viewTime='1999/01/11' AND country='se' group by viewTime, country ;
EXPLAIN Select viewTime, country, count(*) from page_view  where viewTime='1999/01/11'  AND country='se' group by viewTime, country;