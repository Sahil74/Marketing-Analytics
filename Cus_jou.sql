--SELECT * from customer_journey

With Duplicatesonly AS (
select 
    "JourneyID",
    "CustomerID",
    "ProductID",
    "VisitDate",
    UPPER("Stage") AS Stage,
    "Action",
    "Duration",
    AVG("Duration") OVER (PARTITION BY "VisitDate") AS avg_duration,
    row_number() over(PARTITION BY "CustomerID", "ProductID", "VisitDate", "Stage", "Action" ORDER BY "JourneyID") AS row_num 
 from customer_journey
)

--Duplicates
/*
select count(*)
from Duplicatesonly
WHERE "row_num" > 1;
*/


select 
    "JourneyID",
    "CustomerID",
    "ProductID",
    "VisitDate",
    stage,
    "Action",
    COALESCE("Duration",avg_duration) AS Duration
FROM Duplicatesonly
Where row_num = 1;


WITH CleanedData AS (
    SELECT
        "JourneyID",
        UPPER("Stage") AS stage,
        COALESCE("Duration", AVG("Duration") OVER (PARTITION BY "VisitDate")) AS duration,
        ROW_NUMBER() OVER (PARTITION BY "CustomerID", "ProductID", "VisitDate", UPPER("Stage"), "Action" ORDER BY "JourneyID") AS row_num
    FROM customer_journey
)
UPDATE customer_journey AS cj
SET
    "Stage" = cd.stage,
    "Duration" = cd.duration
FROM CleanedData AS cd
WHERE cj."JourneyID" = cd."JourneyID"
  AND (
      cd.row_num = 1
  )
  AND (
      cj."Stage" IS DISTINCT FROM cd.stage
      OR cj."Duration" IS DISTINCT FROM cd.duration
  );


SELECT
    column_name,
    data_type,
    numeric_precision,
    numeric_scale
FROM information_schema.columns
WHERE table_name = 'customer_journey'
  AND column_name = 'Duration';