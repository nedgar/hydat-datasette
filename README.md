# hydat-datasette

## Summary

Spins up a [datasette] server on Environment Canada's [HYDAT] database to 
enable interactive SQL queries for historical hydrometrics data.  
Details on the HYDAT DB schema are available here: [HYDAT schema].

Runs on [IBM Cloud] (aka Bluemix).

[datasette]: https://simonwillison.net/2017/Nov/13/datasette/
[HYDAT]: https://wateroffice.ec.gc.ca/
[HYDAT schema]: http://collaboration.cmc.ec.gc.ca/cmc/hydrometrics/www/HYDAT_Definition_EN.pdf
[IBM Cloud]: https://bluemix.net


## Examples

### Stations on the Ottawa River (aka Rivière des Outaouais)
```
select STATION_NUMBER, STATION_NAME, LATITUDE, LONGITUDE, HYD_STATUS, REAL_TIME, DRAINAGE_AREA_GROSS
from STATIONS
where (STATION_NAME like '%OTTAWA RIVER%' or STATION_NAME like '%OUTAOUAIS (RIVIERE DES)%') 
order by STATION_NUMBER
```

### Comments on Ottawa River stations
```
select S.STATION_NUMBER, S.STATION_NAME, YEAR, REMARK_TYPE_EN, REMARK_EN
from STATIONS S, STN_REMARKS R, STN_REMARK_CODES C 
where (S.STATION_NAME like '%OTTAWA RIVER%' or S.STATION_NAME like '%OUTAOUAIS (RIVIERE DES)%') 
and S.STATION_NUMBER = R.STATION_NUMBER and R.REMARK_TYPE_CODE = C.REMARK_TYPE_CODE 
order by S.STATION_NUMBER, YEAR, REMARK_TYPE_EN
```

### Info on types of data collected over time for a particular station (simple)
```
select * from STN_DATA_COLLECTION
where STATION_NUMBER = '02KF005'
order by YEAR_FROM, DATA_TYPE
```

### Info on types of data collected over time for a particular station (elaborated)
```
select SD.STATION_NUMBER, SD.YEAR_FROM, SD.YEAR_TO, SD.DATA_TYPE, T.DATA_TYPE_EN, SD.MEASUREMENT_CODE, M.MEASUREMENT_EN, SD.OPERATION_CODE, O.OPERATION_EN
from STN_DATA_COLLECTION SD, DATA_TYPES T, MEASUREMENT_CODES M, OPERATION_CODES O
where SD.DATA_TYPE = T.DATA_TYPE and SD.MEASUREMENT_CODE = M.MEASUREMENT_CODE and SD.OPERATION_CODE = O.OPERATION_CODE
and SD.STATION_NUMBER = '02KF005'
order by SD.YEAR_FROM, SD.DATA_TYPE
```

### Annual summary stats for water level at a particular station
```
select *
from ANNUAL_STATISTICS
where STATION_NUMBER = '02KF005' and DATA_TYPE='H'
order by YEAR
```

### Annual summary stats for flow rate at a particular station
```
select *
from ANNUAL_STATISTICS
where STATION_NUMBER = '02KF005' and DATA_TYPE='Q'
order by YEAR
```
