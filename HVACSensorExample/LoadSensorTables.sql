-- Load Sensor Source Data tables
drop table if exists building;
drop table if exists HVAC;
drop table if exists hvac_orc;

CREATE TABLE building 
  (BuildingID bigint,BuildingMgr String,BuildingAge bigint,
   HVACproduct string,Country string)
      ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/user/hive/SensorFiles/building';

CREATE TABLE HVAC
   (Date string,Time string,TargetTemp bigint, ActualTemp bigint, System bigint,SystemAge bigint,BuildingID bigint)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/user/hive/SensorFiles/HVAC';
