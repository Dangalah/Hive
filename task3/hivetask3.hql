ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/json-serde-1.3.8-jar-with-dependencies.jar;

SET hive.variable.substitute=true;

USE shipovalovair;

DROP TABLE IF EXISTS kkt_task3;
CREATE EXTERNAL TABLE kkt_task3 (
    id string,
    fsId string,
    subtype string,
    receiveDate struct<date: bigint>,
    protocolVersion string,
    ofdId string,
    protocolSubversion string,
    content struct<nds18: string, dateTime: struct<date: bigint>, cashTotalSum: string, totalSum: int, receiptCode: string, taxationType: string, userInn: string,  kktRegId: string>,
    documentId string
)

ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
WITH SERDEPROPERTIES(
'ignore.malformed.json' = 'true',
'mapping.id' = '_id',
'mapping.oid' = '$oid',
'mapping.date' = '$date')
STORED AS TEXTFILE
LOCATION '/data/hive/fns2';

DROP TABLE IF EXISTS pbt;
CREATE TABLE PBT STORED AS TEXTFILE AS
    SELECT content.userInn AS inn, from_unixtime(CAST(content.dateTime.date DIV 1000 as bigint), 'dd') AS day, COALESCE(content.totalSum, 0) AS totalSum
    FROM kkt_task3;

DROP TABLE IF EXISTS dist;
CREATE TABLE dist STORED AS TEXTFILE AS
    SELECT inn, day, SUM(totalSum) AS profit
    FROM pbt
    GROUP BY inn, day;

DROP TABLE IF EXISTS pp;
CREATE TABLE pp STORED AS TEXTFILE AS
    SELECT inn, MAX(profit) AS profit
    FROM dist
    GROUP BY inn;

SELECT dist.inn AS inn, MAX(dist.day) AS day, pp.profit AS profit
FROM dist INNER JOIN pp ON pp.inn = dist.inn AND pp.profit = dist.profit
GROUP BY dist.inn, pp.profit;
