-- Create Simple Hive Partitioned table
set hive.execution.engine=mr;
SET hive.exec.dynamic.partition.mode=nonstrict;

SET hive.exec.dynamic.partition=true;
SET hive.exec.compress.output=false;
SET hive.merge.mapredfiles=true;

DROP TABLE IF EXISTS page_view_stg;
DROP TABLE IF EXISTS page_view;
DROP TABLE IF EXISTS user_preferences_stg;
DROP TABLE IF EXISTS user_preferences;

CREATE EXTERNAL TABLE page_view_stg(viewTime String, country String, userid string,
                page_url STRING, referrer_url STRING,
                ip STRING COMMENT 'IP Address of the User')
COMMENT 'This is the staging page view table'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/user/hive/staging/';

CREATE EXTERNAL TABLE user_preferences_stg(userid String, preference string)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
    STORED AS TEXTFILE
    LOCATION '/user/hive/staging';


CREATE TABLE page_view( viewTime String,
                page_url STRING, referrer_url STRING, userid string,
                ip STRING COMMENT 'IP Address of the User')
COMMENT 'This is the page view table'
PARTITIONED BY(country String)
STORED AS ORC;

CREATE TABLE user_preferences( preference string) 
    PARTITIONED BY(userid string) 
    STORED AS ORC;


-- Non strict mode insert
INSERT OVERWRITE TABLE page_view PARTITION (country) SELECT userid, page_url, referrer_url,ip, viewTime, country FROM page_view_stg;

INSERT OVERWRITE TABLE user_preferences PARTITION(userid) SELECT userid, preference FROM user_preferences_stg;
