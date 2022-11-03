CREATE VIEW `braided-topic-362415.Ville_Montreal_DB.vw_stm_incidents` AS 
(SELECT 
  TX.Numero_d_incident,
  TX.Type_d_incident,
  TX.Cause_primaire,
  TX.Cause_secondaire,
  TX.Symptome,
  TX.Ligne,  
  TX.Code_de_lieu,
  TX.Date_Incident,
  DATE_ADD (TX.date_zero_de_l_incident, INTERVAL TX.Minutes_incident MINUTE) AS Date_heure_incident,
  DATE_ADD (TX.date_zero_de_l_incident, INTERVAL TX.Minutes_reprise MINUTE) AS Date_heure_reprise,
  TX.Heure_de_l_incident,
  TX.Heure_de_reprise,
  TX.nDay,
  TX.nMonth,
  TX.sMonth,
  TX.nYear,
  TX.nDayWeek,
  TX.sDayWeek,
  TX.WeekNumber,
  TX.Quarter,
  TX.stop_code,
  TX.stop_lat,
  TX.stop_lon,
  TX.stop_sequence
FROM 
  (SELECT 
    T0.Numero_d_incident,
    CASE 
      WHEN T0.Type_d_incident = 'T' THEN 'TRAIN' 
      WHEN T0.Type_d_incident = 'S' THEN 'STATION' 
      ELSE '' 
    END Type_d_incident,
    T0.Cause_primaire,
    CASE 
      WHEN T0.Cause_secondaire = '#N/D' THEN 'Autres' 
      WHEN T0.Cause_secondaire LIKE 'Contrats%' THEN 'Contrats' 
      WHEN T0.Cause_secondaire = 'MR-73' THEN 'Train' 
      WHEN T0.Cause_secondaire = 'MPM-10' THEN 'Train' 
      WHEN T0.Cause_secondaire LIKE 'Service%' THEN 'Service'
      ELSE T0.Cause_secondaire 
    END Cause_secondaire,
    T0.Symptome,
    T0.Ligne,
    CASE 
        WHEN T2.stop_name IS NULL THEN T0.Code_de_lieu 
        ELSE T2.stop_name END Code_de_lieu,  
    T0.Jour_calendaire AS Date_Incident,
    CAST (CONCAT (CAST (T0.Jour_calendaire AS STRING),' 00:00:00') AS DATETIME) AS date_zero_de_l_incident,
    `braided-topic-362415.Ville_Montreal_DB`.fn_hours_minute(T0.Heure_de_l_incident) AS Minutes_incident,
    `braided-topic-362415.Ville_Montreal_DB`.fn_hours_minute(T0.Heure_de_reprise) AS Minutes_reprise,
    T0.Heure_de_l_incident,
    T0.Heure_de_reprise,
    T1.nDay,
    T1.nMonth,
    T1.sMonth,
    T1.nYear,
    T1.nDayWeek,
    T1.sDayWeek,
    T1.WeekNumber,
    T1.Quarter,
    T2.stop_code,
    T2.stop_lat,
    T2.stop_lon,
    T3.stop_sequence 
  FROM 
    `braided-topic-362415.Ville_Montreal_DB.stm_incidents` T0 
  INNER JOIN 
    `braided-topic-362415.Ville_Montreal_DB.datesdimen` T1 ON T0.Jour_calendaire = T1.EachDate
  LEFT OUTER JOIN 
    `braided-topic-362415.Ville_Montreal_DB.stm_stops` T2 ON T2.location_type = 1 AND TRIM(T0.stop_code) = TRIM(T2.stop_icode)
  LEFT OUTER JOIN 
    `braided-topic-362415.Ville_Montreal_DB.stm_stop_seq` T3 ON T3.code_seq = T0.metrostat_code) TX)
