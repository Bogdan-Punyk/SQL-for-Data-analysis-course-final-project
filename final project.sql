USE mavenfuzzyfactory;

-- -----------------------------------------------TASK 1-----------------------------------------------------

SELECT 
	YEAR(website_sessions.created_at) AS year,
    QUARTER(website_sessions.created_at) AS qrt,
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at >= '2012-04-01'
GROUP BY 1,2;

-- -----------------------------------------------TASK 2-----------------------------------------------------

SELECT 
	YEAR(website_sessions.created_at) AS year,
    QUARTER(website_sessions.created_at) AS qrt,
	COUNT(DISTINCT order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_rate,
    SUM(price_usd)/COUNT(DISTINCT order_id) AS revenue_per_order,
    SUM(price_usd)/COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at >= '2012-04-01'
GROUP BY 1,2;

-- -----------------------------------------------TASK 3-----------------------------------------------------

SELECT 
	YEAR(website_sessions.created_at) AS year,
    QUARTER(website_sessions.created_at) AS qrt,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN order_id END) AS direct_type_in_orders,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN order_id END) AS organic_search_orders,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN order_id END) AS brand_search_orders,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' AND utm_source = 'gsearch' THEN order_id END) AS gsearch_nonbrand_orders,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' AND utm_source = 'bsearch' THEN order_id END) AS bsearch_nonbrand_orders
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at >= '2012-04-01'
GROUP BY 1,2;

-- -----------------------------------------------TASK 4-----------------------------------------------------

SELECT 
	YEAR(website_sessions.created_at) AS year,
    QUARTER(website_sessions.created_at) AS qrt,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN order_id END)/
		COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_sessions.website_session_id END) AS direct_type_in_conv_rt,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN order_id END)/
		COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_sessions.website_session_id END) AS organic_search_conv_rt,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN order_id END)/
		COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_sessions.website_session_id END) AS brand_search_conv_rt,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' AND utm_source = 'gsearch' THEN order_id END)/
		COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' AND utm_source = 'gsearch' THEN website_sessions.website_session_id END) AS gsearch_nonbrand_conv_rt,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' AND utm_source = 'bsearch' THEN order_id END)/
		COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' AND utm_source = 'bsearch' THEN website_sessions.website_session_id END) AS bsearch_nonbrand_conv_rt
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at >= '2012-04-01'
GROUP BY 1,2;

-- -----------------------------------------------TASK 5-----------------------------------------------------

SELECT 
	YEAR(website_sessions.created_at) AS year,
	MONTH(website_sessions.created_at) AS month,
    SUM(CASE WHEN product_id = 1 THEN order_items.price_usd END) AS product_1_rev,
    SUM(CASE WHEN product_id = 1 THEN order_items.price_usd - order_items.cogs_usd END) AS product_1_margin,
    SUM(CASE WHEN product_id = 2 THEN order_items.price_usd END) AS product_2_rev,
    SUM(CASE WHEN product_id = 2 THEN order_items.price_usd - order_items.cogs_usd END) AS product_2_margin,
    SUM(CASE WHEN product_id = 3 THEN order_items.price_usd END) AS product_3_rev,
    SUM(CASE WHEN product_id = 3 THEN order_items.price_usd - order_items.cogs_usd END) AS product_3_margin,
    SUM(CASE WHEN product_id = 4 THEN order_items.price_usd END) AS product_4_rev,
    SUM(CASE WHEN product_id = 4 THEN order_items.price_usd - order_items.cogs_usd END) AS product_4_margin,
    COUNT(DISTINCT orders.order_id) AS total_sales,
    SUM(order_items.price_usd) AS total_rev

FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
	LEFT JOIN order_items
		ON order_items.order_id = orders.order_id
GROUP BY 1,2;

-- -----------------------------------------------TASK 6-----------------------------------------------------

SELECT
	YEAR(time) AS year,
    MONTH(time) AS month,
    COUNT(DISTINCT session_id) AS to_products_sessions,
    COUNT(CASE WHEN pages_visited > 2 THEN session_id END)/COUNT(DISTINCT session_id) AS products_clickthrough,
    COUNT(CASE WHEN pages_visited = 7 THEN session_id END)/COUNT(DISTINCT session_id) AS orders_per_product_session
FROM(
SELECT 
	sessions_w_poducts.product_session_id AS session_id,
	COUNT(DISTINCT website_pageviews.website_pageview_id) AS pages_visited,
    website_pageviews.created_at AS time
FROM(
SELECT 
	website_session_id AS product_session_id
FROM website_pageviews
WHERE pageview_url = '/products'
) AS sessions_w_poducts
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_w_poducts.product_session_id
	-- LEFT JOIN orders here if your wit is didn't work perfectly
GROUP BY 1
) AS sauce
GROUP BY 1,2;

-- -----------------------------------------------TASK 7-----------------------------------------------------

SELECT
-- 	YEAR(time) AS year,
--     MONTH(time) AS month,
    COUNT(CASE WHEN primary_product = '1is_primary' AND total_price = 109.98 THEN time END) AS 1_to_2,
    COUNT(CASE WHEN primary_product = '1is_primary' AND total_price = 95.98 THEN time END) AS 1_to_3,
    COUNT(CASE WHEN primary_product = '1is_primary' AND total_price = 79.98 THEN time END) AS 1_to_4,
    COUNT(CASE WHEN primary_product = '2is_primary' AND total_price = 109.98 THEN time END) AS 2_to_1,
    COUNT(CASE WHEN primary_product = '2is_primary' AND total_price = 105.98 THEN time END) AS 2_to_3,
    COUNT(CASE WHEN primary_product = '2is_primary' AND total_price = 89.98 THEN time END) AS 2_to_4,
    COUNT(CASE WHEN primary_product = '3is_primary' AND total_price = 95.98 THEN time END) AS 3_to_1,
    COUNT(CASE WHEN primary_product = '3is_primary' AND total_price = 105.98 THEN time END) AS 3_to_2,
    COUNT(CASE WHEN primary_product = '3is_primary' AND total_price = 75.98 THEN time END) AS 3_to_4,
	COUNT(CASE WHEN primary_product = '4is_primary' AND total_price = 79.98 THEN time END) AS 4_to_1,
    COUNT(CASE WHEN primary_product = '4is_primary' AND total_price = 89.98 THEN time END) AS 4_to_2,
    COUNT(CASE WHEN primary_product = '4is_primary' AND total_price = 75.98 THEN time END) AS 4_to_3
FROM(
SELECT 
	CASE WHEN product_id = 1 AND is_primary_item = 1 THEN '1is_primary'
		 WHEN product_id = 2 AND is_primary_item = 1 THEN '2is_primary'
         WHEN product_id = 3 AND is_primary_item = 1 THEN '3is_primary'
         WHEN product_id = 4 AND is_primary_item = 1 THEN '4is_primary'
         END AS primary_product,
	SUM(price_usd) AS total_price,
    created_at AS time
FROM order_items
GROUP BY order_id
) AS sauce
WHERE time > '2014-12-05'
-- GROUP BY 1,2

-- -----------------------------------------------TASK 8-----------------------------------------------------

