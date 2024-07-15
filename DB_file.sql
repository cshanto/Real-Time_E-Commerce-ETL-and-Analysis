

-- Create the amazon_products table
CREATE TABLE amazon_products (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_price DECIMAL(10, 2) NOT NULL,
);

-- Create the flipkart_products table
CREATE TABLE flipkart_products (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_price DECIMAL(10, 2) NOT NULL,
);



-- Optional(relatively small datasets): Indexes to improve query performance
CREATE INDEX idx_amazon_products_name ON amazon_products(product_name);
CREATE INDEX idx_flipkart_products_name ON flipkart_products(product_name);


-- Check for null values in product_name or product_price
SELECT * FROM amazon_products
WHERE product_name IS NULL OR product_price IS NULL;

-- Count the number of records in each table
SELECT COUNT(*) AS total_records_amazon
FROM amazon_products;

SELECT COUNT(*) AS total_records_flipkart
FROM flipkart_products;

-- Example: Check for duplicate product names
SELECT product_name, COUNT(*)
FROM amazon_products
GROUP BY product_name
HAVING COUNT(*) > 1;

-- Example: Check for outliers in product prices
SELECT *
FROM amazon_products
WHERE product_price > 100000;


-- Data Explorations

-- Example: Calculate average product price of amazon products
SELECT AVG(product_price) AS avg_price
FROM amazon_products;

-- Example: Calculate average product price of flipkart products
SELECT AVG(product_price) AS avg_price
FROM flipkart_products;

-- Example: Top 10 most expensive products in amazon
SELECT product_name, product_price
FROM amazon_products
ORDER BY product_price DESC
LIMIT 10;


-- Example: Top 10 most expensive products in flipkart
SELECT product_name, product_price
FROM flipkart_products
ORDER BY product_price DESC
LIMIT 10;


-- Summary statistics for amazon_products
SELECT 
    COUNT(*) AS total_products,
    AVG(product_price) AS average_price,
    MIN(product_price) AS min_price,
    MAX(product_price) AS max_price,
    STDDEV(product_price) AS std_dev_price
FROM amazon_products;

-- Summary statistics for flipkart_products
SELECT 
    COUNT(*) AS total_products,
    AVG(product_price) AS average_price,
    MIN(product_price) AS min_price,
    MAX(product_price) AS max_price,
    STDDEV(product_price) AS std_dev_price
FROM flipkart_products;

-- Price distribution for amazon_products
SELECT 
    CASE
        WHEN product_price < 10000 THEN '< 10,000'
        WHEN product_price BETWEEN 10000 AND 40000 THEN '10,000 - 40,000'
        WHEN product_price BETWEEN 40001 AND 60000 THEN '40,001 - 60,000'
        WHEN product_price BETWEEN 60001 AND 80000 THEN '60,001 - 80,000'
        WHEN product_price BETWEEN 80001 AND 100000 THEN '80,001 - 100,000'
        ELSE '> 1,00,000'
    END AS price_range,
    COUNT(*) AS product_count
FROM amazon_products
GROUP BY price_range
ORDER BY price_range;

-- Price distribution for flipkart_products
SELECT 
    CASE
        WHEN product_price < 10000 THEN '< 10,000'
        WHEN product_price BETWEEN 10000 AND 40000 THEN '10,000 - 40,000'
        WHEN product_price BETWEEN 40001 AND 60000 THEN '40,001 - 60,000'
        WHEN product_price BETWEEN 60001 AND 80000 THEN '60,001 - 80,000'
        WHEN product_price BETWEEN 80001 AND 100000 THEN '80,001 - 100,000'
        ELSE '> 1,00,000'
    END AS price_range,
    COUNT(*) AS product_count
FROM flipkart_products
GROUP BY price_range
ORDER BY price_range;




-- Top 5 most expensive products on Amazon
SELECT product_name, product_price
FROM amazon_products
ORDER BY product_price DESC
LIMIT 5;

-- Top 5 least expensive products on Amazon
SELECT product_name, product_price
FROM amazon_products
ORDER BY product_price ASC
LIMIT 5;

-- Top 5 most expensive products on Flipkart
SELECT product_name, product_price
FROM flipkart_products
ORDER BY product_price DESC
LIMIT 5;

-- Top 5 least expensive products on Flipkart
SELECT product_name, product_price
FROM flipkart_products
ORDER BY product_price ASC
LIMIT 5;


-- Average price comparison for products available on both Amazon and Flipkart
SELECT 
    a.product_name,
    AVG(a.product_price) AS avg_amazon_price,
    AVG(f.product_price) AS avg_flipkart_price
FROM amazon_products a
JOIN flipkart_products f ON a.product_name = f.product_name
GROUP BY a.product_name
ORDER BY avg_amazon_price DESC;


-- Products unique to Amazon
SELECT product_name
FROM amazon_products
WHERE product_name NOT IN (SELECT product_name FROM flipkart_products);

-- Products unique to Flipkart
SELECT product_name
FROM flipkart_products
WHERE product_name NOT IN (SELECT product_name FROM amazon_products);

-- Products common to both Amazon and Flipkart
SELECT product_name
FROM amazon_products
WHERE product_name IN (SELECT product_name FROM flipkart_products);


-- Check for specific product name matches using LIKE
SELECT 
    a.product_name AS amazon_product_name,
    f.product_name AS flipkart_product_name
FROM amazon_products a
JOIN flipkart_products f 
ON TRIM(LOWER(a.product_name)) LIKE '%' || TRIM(LOWER(f.product_name)) || '%'
   OR TRIM(LOWER(f.product_name)) LIKE '%' || TRIM(LOWER(a.product_name)) || '%';



-- Refined matching with price range similarity
SELECT 
    a.product_name AS amazon_product_name,
    f.product_name AS flipkart_product_name,
    AVG(a.product_price) AS avg_amazon_price,
    AVG(f.product_price) AS avg_flipkart_price
FROM amazon_products a
JOIN flipkart_products f 
ON (TRIM(LOWER(a.product_name)) LIKE '%' || TRIM(LOWER(f.product_name)) || '%'
     OR TRIM(LOWER(f.product_name)) LIKE '%' || TRIM(LOWER(a.product_name)) || '%')
AND ABS(a.product_price - f.product_price) < 1000  -- Example price similarity condition
GROUP BY a.product_name, f.product_name
ORDER BY avg_amazon_price DESC;


-- Price comparison report
SELECT 
    amazon_product_name,
    amazon_price,
    flipkart_price,
    CASE 
        WHEN amazon_price < flipkart_price THEN 'Amazon'
        WHEN amazon_price > flipkart_price THEN 'Flipkart'
        ELSE 'Same Price'
    END AS cheaper_platform
FROM combined_products;

