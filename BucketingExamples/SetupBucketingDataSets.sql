-- Create Simple Hive Partitioned table
set hive.execution.engine=mr;


DROP TABLE IF EXISTS page_view_stg;
DROP TABLE IF EXISTS page_view;

CREATE EXTERNAL TABLE page_view_stg(viewTime String, country String, userid BIGINT,
                page_url STRING, referrer_url STRING,
                ip STRING COMMENT 'IP Address of the User')
COMMENT 'This is the staging page view table'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/user/hive/staging/page_view_stg';


CREATE TABLE b_page_view( userid BIGINT,
                page_url STRING, referrer_url STRING,
                ip STRING COMMENT 'IP Address of the User')
COMMENT 'This is the page view table'
CLUSTERED BY (userid) into 4 buckets
STORED AS ORC;

DROP TABLE IF EXISTS UserPreferences_stg;
DROP TABLE IF EXISTS b_UserPreferences_stg;

CREATE EXTERNAL TABLE UserPreferences_stg(userId BIGINT, preferences STRING)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/user/hive/staging/UserPreferences_stg';

CREATE EXTERNAL TABLE b_UserPreferences(userId BIGINT, preferences STRING)
    CLUSTERED BY (userId) INTO 4 BUCKETS;
STORED AS ORC;

-- Load data tables into staging tables
INSERT INTO TABLE b_page_view  
    SELECT userid, page_url, referrer_url,ip, viewTime, country 
    FROM page_view_stg;

INSERT INTO TABLE b_UserPreferences SELECT * FROM UserPreferences_stg;