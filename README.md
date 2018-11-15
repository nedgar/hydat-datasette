# hydat-datasette

## Summary

Spins up a [datasette] server on Environment Canada's [HYDAT] database to 
enable interactive SQL queries for historical hydrometrics data.  
Details on the HYDAT DB schema are available here: [HYDAT schema].

[Running on IBM Cloud](https://hydat-datasette.mybluemix.net/Hydat).

[datasette]: https://simonwillison.net/2017/Nov/13/datasette/
[HYDAT]: https://wateroffice.ec.gc.ca/
[HYDAT schema]: http://collaboration.cmc.ec.gc.ca/cmc/hydrometrics/www/HYDAT_Definition_EN.pdf


## Examples

### DB date and format version [(run it)](https://hydat-datasette.mybluemix.net/Hydat-b1a09d3?sql=select+*+from+Version)
```
select * from Version
```

### Stations on the Ottawa River (aka Rivière des Outaouais) [(run it)](https://hydat-datasette.mybluemix.net/Hydat-b1a09d3?sql=select+STATION_NUMBER%2C+STATION_NAME%2C+LATITUDE%2C+LONGITUDE%2C+HYD_STATUS%2C+REAL_TIME%2C+DRAINAGE_AREA_GROSS%0D%0Afrom+STATIONS%0D%0Awhere+%28STATION_NAME+like+%27%25OTTAWA+RIVER%25%27+or+STATION_NAME+like+%27%25OUTAOUAIS+%28RIVIERE+DES%29%25%27%29+%0D%0Aorder+by+STATION_NUMBER)
```
select STATION_NUMBER, STATION_NAME, LATITUDE, LONGITUDE, HYD_STATUS, REAL_TIME, DRAINAGE_AREA_GROSS
from STATIONS
where (STATION_NAME like '%OTTAWA RIVER%' or STATION_NAME like '%OUTAOUAIS (RIVIERE DES)%') 
order by STATION_NUMBER
```

### Comments on Ottawa River stations [(run it)](https://hydat-datasette.mybluemix.net/Hydat-b1a09d3?sql=select+S.STATION_NUMBER%2C+S.STATION_NAME%2C+YEAR%2C+REMARK_TYPE_EN%2C+REMARK_EN%0D%0Afrom+STATIONS+S%2C+STN_REMARKS+R%2C+STN_REMARK_CODES+C+%0D%0Awhere+%28S.STATION_NAME+like+%27%25OTTAWA+RIVER%25%27+or+S.STATION_NAME+like+%27%25OUTAOUAIS+%28RIVIERE+DES%29%25%27%29+%0D%0Aand+S.STATION_NUMBER+%3D+R.STATION_NUMBER+and+R.REMARK_TYPE_CODE+%3D+C.REMARK_TYPE_CODE+%0D%0Aorder+by+S.STATION_NUMBER%2C+YEAR%2C+REMARK_TYPE_EN)
```
select S.STATION_NUMBER, S.STATION_NAME, YEAR, REMARK_TYPE_EN, REMARK_EN
from STATIONS S, STN_REMARKS R, STN_REMARK_CODES C 
where (S.STATION_NAME like '%OTTAWA RIVER%' or S.STATION_NAME like '%OUTAOUAIS (RIVIERE DES)%') 
and S.STATION_NUMBER = R.STATION_NUMBER and R.REMARK_TYPE_CODE = C.REMARK_TYPE_CODE 
order by S.STATION_NUMBER, YEAR, REMARK_TYPE_EN
```

### Changes in regulation regime for Ottawa River stations
```
select S.STATION_NUMBER, S.STATION_NAME, R.*
from STATIONS S, STN_REGULATION R
where (S.STATION_NAME like '%OTTAWA RIVER%' or S.STATION_NAME like '%OUTAOUAIS (RIVIERE DES)%') 
and S.STATION_NUMBER = R.STATION_NUMBER
order by S.STATION_NUMBER
```
Spoiler: Shows most are regulated.

### Info on types of data collected over time for a particular station (simple)
```
select * from STN_DATA_COLLECTION
where STATION_NUMBER = '02KF005'
order by DATA_TYPE, YEAR_FROM
```

### Info on types of data collected over time for a particular station (elaborated)
```
select SD.STATION_NUMBER, SD.DATA_TYPE, T.DATA_TYPE_EN, SD.YEAR_FROM, SD.YEAR_TO, SD.MEASUREMENT_CODE, M.MEASUREMENT_EN, SD.OPERATION_CODE, O.OPERATION_EN
from STN_DATA_COLLECTION SD, DATA_TYPES T, MEASUREMENT_CODES M, OPERATION_CODES O
where SD.DATA_TYPE = T.DATA_TYPE and SD.MEASUREMENT_CODE = M.MEASUREMENT_CODE and SD.OPERATION_CODE = O.OPERATION_CODE
and SD.STATION_NUMBER = '02KF005'
order by SD.DATA_TYPE, SD.YEAR_FROM
```

### Info on types of data collected over time for Ottawa River stations (elaborated)
```
select S.STATION_NUMBER, S.STATION_NAME, C.*, T.DATA_TYPE_EN, M.MEASUREMENT_EN, O.OPERATION_EN
from STATIONS S, STN_DATA_COLLECTION C, DATA_TYPES T, MEASUREMENT_CODES M, OPERATION_CODES O
where (S.STATION_NAME like '%OTTAWA RIVER%' or S.STATION_NAME like '%OUTAOUAIS (RIVIERE DES)%') 
and S.STATION_NUMBER = C.STATION_NUMBER and C.DATA_TYPE = T.DATA_TYPE and C.MEASUREMENT_CODE = M.MEASUREMENT_CODE and C.OPERATION_CODE = O.OPERATION_CODE
order by S.STATION_NUMBER, C.DATA_TYPE, C.YEAR_FROM
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

### Annual peaks (highs and lows) at a particular station and when they occurred:
```
select P.*, C.PRECISION_EN from ANNUAL_INSTANT_PEAKS P, PRECISION_CODES C
where STATION_NUMBER = '02KF005' and P.PRECISION_CODE = C.PRECISION_CODE
order by DATA_TYPE, YEAR
```

### Daily water level at a particular station
```
select *
from DLY_LEVELS
where STATION_NUMBER = '02KF005' and YEAR >= 1950
order by YEAR, MONTH
```
Note that the daily water level and flow data is de-normalized, with one month per row and separate columns for each day in month plus their data symbols.

### Daily flow rate at a particular station
```
select * from DLY_FLOWS
where STATION_NUMBER = '02KF005' and YEAR >= 1950
order by YEAR, MONTH
```

### Symbols used to indicate partial / anomolous data in readings
```
select * from DATA_SYMBOLS order by SYMBOL_ID
```
Spoiler: `A` indicates `Partial Day`, `E` indicates `Estimated`.

