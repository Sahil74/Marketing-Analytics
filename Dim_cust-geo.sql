select 
        "CustomerID",
        "CustomerName",
        "Email",
        "Gender",
        "Age",
        "Country",
        "City"

from
    customers cu 
left join 
    geography eng 
on 
cu."GeographyID" = eng."GeographyID";