set hive.execution.engine=mr;

CREATE TABLE pageview_stg(viewTime INT, userid BIGINT,
                page_url STRING, referrer_url STRING,
                ip STRING COMMENT 'IP Address of the User',
                country STRING COMMENT 'country of origination')
COMMENT 'This is the staging page view table'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/user/hive/staging/pageview_stg';
LOAD DATA LOCAL INPATH absolute_filename OVERWRITE INTO TABLE pageview_stg; 

CREATE EXTERNAL TABLE UserPreferences_stg(userId BIGINT, preferences STRING)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/user/hive/staging/UserPreferences_stg';


CREATE TABLE page_view_pt(viewTime INT, userid BIGINT,
                page_url STRING, referrer_url STRING,
                ip STRING COMMENT 'IP Address of the User')
COMMENT 'This is the page view table'
PARTITIONED BY(dt STRING, country STRING)
STORED AS TEXTFILE;

CREATE TABLE user_master(userId BIGINT, preferences STRING)
STORED AS TEXFILE;
