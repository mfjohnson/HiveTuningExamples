-- Create Simple Hive Partitioned table
set hive.execution.engine=mr;
SET hive.exec.dynamic.partition.mode=nonstrict;

-- Maximum number of dynamic partitions allowed to be created in each mapper/reducer node
SET hive.exec.max.dynamic.partitions.pernode=1000;

-- Maximum number of dynamic partitions allowed to be created in total
SET hive.exec.max.dynamic.partitions=10000;

--Maximum number of HDFS files created by all mappers/reducers in a MapReduce job
SET hive.exec.max.created.files=100000;

-- Whether to throw an exception if dynamic partition insert generates empty results
SET hive.error.on.empty.partition=false;


DROP TABLE IF EXISTS page_view_stg;
DROP TABLE IF EXISTS page_view;
DROP TABLE IF EXISTS UserPreferences_stg;
DROP TABLE IF EXISTS UserPreferences;

CREATE EXTERNAL TABLE page_view_stg(viewTime String, country String, userid String,
                page_url STRING, referrer_url STRING,
                ip STRING )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/staging/page_view_stg';


CREATE EXTERNAL TABLE UserPreferences_stg(userid String, preference String)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
    STORED AS TEXTFILE
    LOCATION '/staging/UserPreferences_stg';


CREATE TABLE page_view( viewTime String, 
                page_url STRING, referrer_url STRING,
                ip STRING, country STRING)
PARTITIONED BY(userid String)
STORED AS ORC;

CREATE TABLE UserPreferences(userid String, preference String) STORED AS ORC;


-- Non strict mode insert
INSERT OVERWRITE TABLE page_view PARTITION (userid) SELECT page_url, referrer_url,ip, country, viewTime,userid FROM page_view_stg;


INSERT OVERWRITE TABLE UserPreferences select userid, preference from UserPreferences_stg;

select a.userid, a.preference, b.viewTime, b.country, b.userid, b.page_url, b.referrer_url,b.ip from UserPreferences as a JOIN page_view as b ON a.userid= b.userid;
