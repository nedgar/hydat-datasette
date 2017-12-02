# hydat-datasette

## Summary

Spins up a [datasette] server on Environment Canada's [HYDAT] database to 
enable interactive SQL queries for historical hydrometrics data.
Runs on [IBM Cloud] (aka Bluemix).

[datasette]: https://simonwillison.net/2017/Nov/13/datasette/
[HYDAT]: https://wateroffice.ec.gc.ca/
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
