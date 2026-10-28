--select * from engagement_data;

select 
    engagement_data."EngagementID",
    engagement_data."ContentID",
    engagement_data."CampaignID",
    engagement_data."ProductID",
    UPPER(REPLACE("ContentType",'Socialmedia','Social Media')) AS contenttype,
    LEFT("ViewsClicksCombined",POSITION('-' IN "ViewsClicksCombined") - 1) AS Views,
    RIGHT("ViewsClicksCombined", LENGTH("ViewsClicksCombined") - POSITION('-' IN "ViewsClicksCombined")) AS Clicks,
    "Likes",
    TO_CHAR("EngagementDate",'DD.MM.YYYY') AS EngagementDate
from
    engagement_data
where
    TRIM("ContentType") NOT ILIKE 'newsletter';


/*SELECT
    "ViewsClicksCombined",
    COUNT(*) AS value_count
FROM engagement_data
GROUP BY "ViewsClicksCombined"
ORDER BY value_count DESC; */

/*SELECT count("ViewsClicksCombined")
FROM engagement_data
WHERE POSITION('-' IN "ViewsClicksCombined") = 0; */


UPDATE engagement_data
SET "ContentType" = UPPER(
    REPLACE("ContentType", 'Socialmedia', 'Social Media')
)
WHERE "ContentType" ILIKE '%socialmedia%'
   OR "ContentType" <> UPPER("ContentType");

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'engagement_data'
ORDER BY ordinal_position;

ALTER TABLE engagement_data
ADD COLUMN "Views" INTEGER,
ADD COLUMN "Clicks" INTEGER;


UPDATE engagement_data
SET "Views" = LEFT("ViewsClicksCombined",
        POSITION('-' IN "ViewsClicksCombined") - 1
    )::INTEGER,
    "Clicks" = RIGHT(
        "ViewsClicksCombined",
        LENGTH("ViewsClicksCombined")
        - POSITION('-' IN "ViewsClicksCombined")
    )::INTEGER;