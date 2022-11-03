CREATE FUNCTION `braided-topic-362415.Ville_Montreal_DB`.fn_hours_minute(hourstr STRING)
RETURNS INT64 
AS 
((CAST(SUBSTRING(hourstr,1,2) AS INT64)*60)+(CAST(SUBSTRING(hourstr,4,2) AS INT64)))
