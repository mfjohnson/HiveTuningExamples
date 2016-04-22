# Run Through the sensor data examples
hadoop fs -rm -r -f /user/hive/SensorFiles
hadoop fs -mkdir -p /user/hive/SensorFiles/HVAC
hadoop fs -mkdir -p /user/hive/SensorFiles/building
hadoop fs -put SensorFiles/HVAC.csv /user/hive/SensorFiles/HVAC
hadoop fs -put SensorFiles/building.csv /user/hive/SensorFiles/building
beeline -u jdbc:hive2:// -n hive -p hive -f LoadSensorTables.sql --verbose=true 
time beeline -u jdbc:hive2:// -n hive -p hive -f SimpleJoinMR.sql --verbose=true 
time beeline -u jdbc:hive2:// -n hive -p hive -f SimpleJoinTEZ.sql --verbose=true 
time beeline -u jdbc:hive2:// -n hive -p hive -f maxJOINGroupByMR.sql --verbose=true 
time beeline -u jdbc:hive2:// -n hive -p hive -f maxJOINGroupByTez.sql --verbose=true 