# Zomato Bengaluru Restaurant Analytics — End-to-End SQL & Power BI Project

## Dashboard Preview
<img width="912" height="543" alt="Zomato analytics" src="https://github.com/user-attachments/assets/55f85396-7553-42ac-a32c-e9fcbc2700c9" />


## Project Overview
An end-to-end data analytics project built in PostgreSQL and Power BI Desktop examining 51,717 Zomato restaurant listings across Bengaluru. Raw web-scraped listings were deduplicated and standardized into 12,499 unique restaurant branches in PostgreSQL, then connected to Power BI to build an interactive executive dashboard.

## Data Cleaning & Transformation (01_zomato_data_cleaning.sql)
- Deduplicated Listings: Used `SELECT DISTINCT ON (restaurant_name, address)` to collapse repeated neighborhood cross-listings from 51,717 raw rows down to 12,499 unique physical branches.
- Parsed Rating Strings: Used `SPLIT_PART(rate, '/', 1)` and `CASE WHEN` to extract decimal ratings (e.g., `4.1/5` to `4.1`) while converting `'NEW'` and `'-'` entries into SQL `NULL`s.
- Standardized Cost & Missing Fields: Stripped commas from currency strings (`REPLACE(approx_cost, ',', '')`) before casting to integers, and standardized missing locations and cuisines using `COALESCE()` and `NULLIF()`.

## SQL Exploratory Analysis (02_zomato_analysis.sql)
1. Online Ordering Impact: Compared restaurant counts, ratings, and average cost for two between online-delivery and dine-in-only outlets.
2. Table Booking vs. Pricing: Evaluated how advance reservation availability correlates with higher average ratings and premium pricing.
3. Top 10 Foodie Locations: Ranked Bengaluru neighborhoods by unique restaurant density, led by Whitefield (885), Electronic City (730), and BTM (725).
4. Price Tier Segmentation: Categorized restaurants into Budget (< ₹400), Mid-Range (₹400–₹800), and Fine Dining (> ₹800) using `CASE WHEN`.
5. Top-Rated Restaurants by Hub: Used a CTE (`WITH`) and `RANK() OVER (PARTITION BY location ORDER BY rating DESC, votes DESC)` to identify the highest-rated established outlet (500+ votes) in each major neighborhood.

## Power BI Dashboard & DAX Highlights (ZOMATO_ANALYTICS_REPORT.pbix)
- KPI Cards: Tracks 12,499 Total Restaurants, 3.63 Average Rating, ₹488 Average Cost for Two, and 52.1% Online Order Adoption.
- Custom DAX Measures & Columns: Built `Total Restaurants`, `Avg Rating`, `Avg Cost for Two`, `Online Order %` (`DIVIDE` + `CALCULATE`), and a `Price Tier` calculated column (`SWITCH`).
- Interactive Slicers: Dynamic dropdown filters for Location and Dining Type allow instant drill-down across all visuals.

## Tools & Skills Demonstrated
- PostgreSQL: `DISTINCT ON`, `SPLIT_PART()`, `REPLACE()`, `COALESCE()`, `NULLIF()`, `CAST()`, `CASE WHEN`, `GROUP BY`, CTEs (`WITH`), Window Functions (`RANK()`)
- Power BI Desktop: PostgreSQL Import Integration, DAX Measures & Calculated Columns, Custom Branded Theme Design, Interactive Slicers, KPI Cards, Bar & Donut Charts

