--select * from customer_reviews;

select 
    "ReviewID",
    "CustomerID",
    "ProductID",
    "ReviewDate",
    "Rating",
    --"ReviewText",
    REPLACE("ReviewText", '  ',' ') AS ReviewText
from 
customer_reviews;


UPDATE customer_reviews
SET "ReviewText" = REPLACE("ReviewText", '  ', ' ')
WHERE "ReviewText" LIKE '%  %';