-- History Values for Specified Host
SELECT itemid, to_char(to_timestamp(clock), 'DD-MM-YYYY HH24:MI:SS'), VALUE, ns
FROM history_uint
WHERE itemid = (
    SELECT itemid
    FROM items
    WHERE hostid = (
        SELECT hostid
        FROM hosts
        WHERE host = 'example.localdomain')
      AND name = 'Service CCP Status')
ORDER BY clock DESC;
 
-- Trends for Specified Host
SELECT itemid, to_char(to_timestamp(clock), 'DD-MM-YYYY HH24:MI:SS'), num, value_min, value_avg, value_max
FROM trends_uint
WHERE itemid = (
    SELECT itemid
    FROM items
    WHERE hostid = (
        SELECT hostid
        FROM hosts
        WHERE host = 'texample.localdomain')
      AND name = 'Service CCP Status')
ORDER BY clock DESC;
 
--
SELECT *
FROM events
WHERE name = 'Service Package CCP is not Running';
 
-- Select Items for Specified Host
SELECT *
FROM items
WHERE hostid = (
    SELECT hostid
    FROM hosts
    WHERE host = 'example.localdomain');
 
-- Match Groups to Hosts
SELECT H.name "Name", I.dns "DNS", I.ip "IP", I.port "Port", H.host, G.name "Group Name"
FROM hosts_groups HG,
     hosts H,
     hstgrp G,
     interface I
WHERE HG.hostid = H.hostid
  AND HG.groupid = G.groupid
  AND G.name != 'Templates'
  AND I.hostid = H.hostid
GROUP BY H.name, I.dns, I.ip, I.port, H.host, G.name
ORDER BY H.name;
 
-- User Sessions
SELECT U.alias, U.name, U.surname, to_char(to_timestamp(lastaccess), 'DD-MM-YYYY HH24:MI:SS'), S.sessionid
FROM sessions S,
     users U
WHERE S.userid = U.userid
  AND S.userid = (
    SELECT userid
    FROM users
    WHERE alias = 'administrator');
 
-- Match User and Group
SELECT U.alias, U.name, U.surname, U.passwd, G.name
FROM users U,
     users_groups UG,
     usrgrp G
WHERE UG.userid = U.userid
AND UG.usrgrpid = G.usrgrpid;
