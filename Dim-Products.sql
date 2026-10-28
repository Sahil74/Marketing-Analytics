--select * from products;
select 
    "ProductID",
    "ProductName",
    "Price",

    CASE
        when "Price" < 50 THEN 'Low'
        when "Price" BETWEEN 50 and 200 THEN 'Medium'
        ELSE 'High'
    END AS PriceCategory    

from products;


ALTER TABLE products
ADD COLUMN "PriceCategory" VARCHAR(10);

UPDATE products
SET "PriceCategory" = CASE
    WHEN "Price" < 50 THEN 'Low'
    WHEN "Price" BETWEEN 50 AND 200 THEN 'Medium'
    ELSE 'High'
END;