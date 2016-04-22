#!/bin/bash
#
#  Load the examples data into HDFS staging and create external managed hive tables
ssh hive@server1 'hadoop fs -mkdir -p staging/pageView_stg'
scp ~/Hive/HiveTuningExamples/Partitioning/*.sql hive@server1:~
scp ~/Hive/HiveTuningExamples/Partitioning/PageViewData_1000.csv hive@server1:~
scp ~/Hive/HiveTuningExamples/Partitioning/UserPreferences_1000.csv hive@server1:~

ssh hive@server1 'hadoop fs -put PageViewData_1000.csv staging/page_view_stg'
ssh hive@server1 'hadoop fs -put UserPreferences_1000.csv staging/user_preferences_stg'
ssh hive@server1 'beeline -u jdbc:hive2:// -n hive -p hive -f CreatePageViewPartitioned.sql --verbose=true'

