ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/json-serde-1.3.8-jar-with-dependencies.jar;

USE shipovalovair;

DROP TABLE IF EXISTS kkt_task1;

CREATE TABLE kkt_task1 (
id struct<oid: string>,
  fsId string,
  kktRegId string,
  subtype string,
  receiveDate struct<date: string>,
  protocolVersion string,
  ofdId string,
  protocolSubversion string,
  content struct<nds18: string, 
    cashTotalSum: string, 
    shiftNumber: string, 
    totalSum: string, 
    receiptCode: string,
    items: struct<nds18: string, 
      name: string, 
      barcode: string, 
      sum: string, 
      price: string, 
      quantity: string>,
    fiscalDriveNumber: string,
    operator: string,
    rawData: string,
    shiftNumber: string,
    user: string,
    kktRegId: string,
    userInn: string,
    fiscalSign: string,
    fiscalDocumentNumber: string,
    code: string,
    dateTime: struct<date: bigint>>,
    documentId int
)

ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
WITH SERDEPROPERTIES(
'ignore.malformed.json' = 'true',
'mapping.id' = '_id',
'mapping.oid' = '$oid',
'mapping.date' = '$date')
LOCATION 'hdfs:/data/hive/fns2';

SELECT content.userInn, content.kktRegId, subtype FROM kkt_task1 LIMIT 50;
