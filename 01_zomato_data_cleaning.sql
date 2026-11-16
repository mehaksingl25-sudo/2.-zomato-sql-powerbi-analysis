-- ============================================================================
-- Zomato Bengaluru Restaurants Dataset: Data Cleaning & Deduplication
-- ============================================================================

-- 1. Create raw staging table for CSV import (51,717 rows)
DROP TABLE IF EXISTS raw_zomato;

CREATE TABLE raw_zomato (
    url TEXT,
    address TEXT,
    name TEXT,
    online_order TEXT,
    book_table TEXT,
    rate TEXT,
    votes TEXT,
    phone TEXT,
    location TEXT,
    rest_type TEXT,
    dish_liked TEXT,
    cuisines TEXT,
    approx_cost TEXT,
    reviews_list TEXT,
    menu_item TEXT,
    listed_in_type TEXT,
    listed_in_city TEXT
);


-- 2. Create clean, deduplicated analytical table (12,499 unique branches)
DROP TABLE IF EXISTS clean_zomato;

CREATE TABLE clean_zomato AS
SELECT DISTINCT ON (TRIM(name), TRIM(address))
    TRIM(name) AS restaurant_name,
    TRIM(address) AS address,
    TRIM(online_order) AS online_order,
    TRIM(book_table) AS book_table,
    CASE 
        WHEN rate IS NULL OR TRIM(rate) IN ('', 'NEW', '-') THEN NULL
        ELSE CAST(TRIM(SPLIT_PART(rate, '/', 1)) AS NUMERIC(3,1))
    END AS rating,
    CAST(NULLIF(TRIM(votes), '') AS INT) AS votes,
    COALESCE(NULLIF(TRIM(location), ''), 'Unknown') AS location,
    COALESCE(NULLIF(TRIM(rest_type), ''), 'Unknown') AS rest_type,
    COALESCE(NULLIF(TRIM(cuisines), ''), 'Not Specified') AS cuisines,
    CAST(REPLACE(NULLIF(TRIM(approx_cost), ''), ',', '') AS INT) AS approx_cost_for_two,
    TRIM(listed_in_type) AS dining_type,
    TRIM(listed_in_city) AS neighborhood
FROM raw_zomato
WHERE name IS NOT NULL 
  AND TRIM(name) <> '';
