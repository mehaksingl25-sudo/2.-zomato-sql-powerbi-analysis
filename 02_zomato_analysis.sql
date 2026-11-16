-- ============================================================================
-- Zomato Bengaluru Restaurants Dataset: Exploratory Business Analysis
-- ============================================================================

-- 1. Online Ordering Adoption & Rating Impact
SELECT 
    online_order,
    COUNT(*) AS total_restaurants,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(approx_cost_for_two), 0) AS avg_cost_for_two
FROM clean_zomato
GROUP BY online_order
ORDER BY total_restaurants DESC;


-- 2. Table Booking Availability vs. Pricing & Ratings
SELECT 
    book_table,
    COUNT(*) AS total_restaurants,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(approx_cost_for_two), 0) AS avg_cost_for_two
FROM clean_zomato
GROUP BY book_table
ORDER BY avg_cost_for_two DESC;


-- 3. Top 10 Foodie Neighborhoods in Bengaluru
SELECT 
    location,
    COUNT(*) AS total_restaurants,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(approx_cost_for_two), 0) AS avg_cost_for_two
FROM clean_zomato
WHERE location <> 'Unknown'
GROUP BY location
ORDER BY total_restaurants DESC
LIMIT 10;


-- 4. Budget vs. Premium Restaurant Price Tiers
SELECT 
    CASE 
        WHEN approx_cost_for_two < 400 THEN 'Budget'
        WHEN approx_cost_for_two BETWEEN 400 AND 800 THEN 'Mid-Range'
        ELSE 'Fine Dining'
    END AS price_tier,
    COUNT(*) AS total_restaurants,
    ROUND(AVG(rating), 2) AS avg_rating
FROM clean_zomato
WHERE approx_cost_for_two IS NOT NULL
GROUP BY 1
ORDER BY total_restaurants DESC;


-- 5. #1 Top-Rated Restaurant in Each Top Neighborhood (Min. 500 Votes)
WITH ranked_restaurants AS (
    SELECT 
        location,
        restaurant_name,
        cuisines,
        rating,
        votes,
        RANK() OVER (
            PARTITION BY location 
            ORDER BY rating DESC, votes DESC
        ) AS area_rank
    FROM clean_zomato
    WHERE location IN ('BTM', 'Koramangala 5th Block', 'Indiranagar', 'HSR', 'Whitefield')
      AND votes >= 500
      AND rating IS NOT NULL
)
SELECT 
    location,
    restaurant_name,
    cuisines,
    rating,
    votes
FROM ranked_restaurants
WHERE area_rank = 1
ORDER BY rating DESC, votes DESC;
