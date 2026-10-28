--select * from calendar

CREATE TABLE calendar AS
WITH dates AS (
    SELECT generate_series(
        DATE '2023-01-01',
        DATE '2025-12-31',
        INTERVAL '1 day'
    )::date AS "Date"
)

SELECT
    "Date",
    TO_CHAR("Date", 'YYYYMMDD')::integer AS "DateAsInteger",
    EXTRACT(YEAR FROM "Date")::integer AS "Year",
    TO_CHAR("Date", 'MM') AS "Monthnumber",
    TO_CHAR("Date", 'YYYY/MM') AS "YearMonthnumber",
    TO_CHAR("Date", 'YYYY/Mon') AS "YearMonthShort",
    TO_CHAR("Date", 'Mon') AS "MonthNameShort",
    TO_CHAR("Date", 'FMMonth') AS "MonthNameLong",
    EXTRACT(ISODOW FROM "Date")::integer AS "DayOfWeekNumber",
    TO_CHAR("Date", 'FMDay') AS "DayOfWeek",
    TO_CHAR("Date", 'Dy') AS "DayOfWeekShort",
    'Q' || EXTRACT(QUARTER FROM "Date") AS "Quarter",
    EXTRACT(YEAR FROM "Date")::text
        || '/Q' || EXTRACT(QUARTER FROM "Date") AS "YearQuarter"
FROM dates;
