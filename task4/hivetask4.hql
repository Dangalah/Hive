ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/json-serde-1.3.8-jar-with-dependencies.jar;

USE shipovalovair;

SELECT prof_day.user, prof_day.summ, prof_ev.summ 
FROM (SELECT sub.user AS user, cast(avg(sub.summ) AS int) AS summ
FROM (SELECT ink.content.userInn AS user, from_unixtime(CAST(ink.content.dateTime.date/1000 AS bigint), 'HH') AS day, ink.content.totalSum AS summ FROM kkt_task1 ink) sub WHERE sub.day >= 13 
GROUP BY sub.user) prof_ev
JOIN (SELECT sub.user AS user, cast(avg(sub.summ) AS int) AS summ 
FROM (SELECT ink.content.userInn AS user, from_unixtime(CAST(ink.content.dateTime.date/1000 AS bigint), 'HH') AS day, ink.content.totalSum AS summ FROM kkt_task1 ink) sub WHERE sub.day < 13 
GROUP BY sub.user) prof_day on
prof_day.user = prof_ev.user
WHERE prof_ev.summ < prof_day.summ ORDER BY prof_day.summ ASC limit 50;
