ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/json-serde-1.3.8-jar-with-dependencies.jar;

USE shipovalovair;

DROP TABLE IF EXISTS kkt_task2;
CREATE TABLE kkt_task2 
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE AS 
SELECT sub.user, sub.summ FROM (SELECT ink.content.userInn AS user, sum(ink.content.totalSum) AS summ FROM kkt_task1 ink GROUP BY ink.content.userInn) sub
WHERE sub.summ IN (SELECT max(sub.summ) AS max_summ FROM (SELECT ink.content.userInn AS user, sum(ink.content.totalSum) AS summ FROM kkt_task1 ink GROUP BY ink.content.userInn) sub);

SELECT * FROM kkt_task2;
