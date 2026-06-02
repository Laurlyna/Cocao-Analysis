USE flavors_of_cacao ;

SELECT*
FROM flavors_of_cacao;

--- creating a new table 

CREATE DATABASE flavors_of_cacao ;

RENAME TABLE flavors_of_cacao TO
cacao_flavors ;

CREATE TABLE cacao_flavors2 LIKE 
cacao_flavors;

INSERT INTO cacao_flavors2
SELECT*
FROM cacao_flavors ;

--- lets change column name 

SELECT*
FROM cacao_flavors2 ;

ALTER TABLE cacao_flavors2
CHANGE COLUMN `CompanyÂ 
(Maker-if known)`company TEXT;

SHOW COLUMNS 
FROM cacao_flavors2;

SELECT*
FROM cacao_flavors2
LIMIT 1;

ALTER TABLE cacao_flavors2
RENAME COLUMN `Bean
Type` TO bean_type ;

ALTER TABLE cacao_flavors2
RENAME COLUMN `Specific Bean Origin
or Bar Name` TO bean_origin ;


ALTER TABLE cacao_flavors2
RENAME COLUMN `Review
Date` TO review_date ;

ALTER TABLE cacao_flavors2
RENAME COLUMN `Cocoa
Percent` TO cocoa_percent  ;

ALTER TABLE cacao_flavors2
RENAME COLUMN `Company
Location` TO company_location ;

ALTER TABLE cacao_flavors2
RENAME COLUMN `Rating` TO rating;

ALTER TABLE cacao_flavors2
RENAME COLUMN `Broad Bean
Origin` TO bean_origin_country;


SELECT*
FROM cacao_flavors2
LIMIT 1;

--- lets fix the % in cocoa_percent 
UPDATE cacao_flavors2
SET cacoa_percent= 
REPLACE(cacoa_percent, '%', '');

ALTER TABLE cacao_flavors2
MODIFY COLUMN cacoa_percent INT ;

SHOW COLUMNS 
FROM cacao_flavors2 ;

SELECT*
FROM cacao_flavors2;

ALTER TABLE cacao_flavors2
MODIFY COLUMN cocoa_percent INT ;

SET SQL_SAFE_UPDATES = 0;

UPDATE cacao_flavors2
SET cocoa_percent = 
REPLACE(cocoa_percent, '%', '');


DESCRIBE cacao_flavors2 ;


---- lets us check for duplicates

WITH cacao_table AS (SELECT*, 
ROW_NUMBER() OVER(PARTITION BY company, bean_origin,REF, review_date,cocoa_percent,company_location, rating, bean_type, bean_origin_country)AS row_num
FROM cacao_flavors2 )
SELECT*
FROM cacao_table 
WHERE row_num > 1;


--- no duplicate 

--- lets handle null, empty space 

SELECT*
FROM cacao_flavors2 
WHERE bean_type IS NULL ;

SELECT*
FROM cacao_flavors2 
WHERE bean_type = '';

SELECT DISTINCT bean_type, bean_origin
FROM cacao_flavors2 
ORDER BY bean_type ASC;

UPDATE cacao_flavors2 
SET bean_type = NUll
WHERE bean_type = 'Â ' ;

UPDATE cacao_flavors2 
SET bean_type = 'unknown'
WHERE bean_type = '';

SET SQL_SAFE_UPDATES = 0 ;

SELECT*
FROM cacao_flavors2 ;

SELECT bean_type,COUNT(*) AS count
FROM  cacao_flavors2
GROUP BY bean_type
order by count DESC ;

SELECT*
FROM cacao_flavors2
WHERE rating ='Â ' OR rating = '';

UPDATE cacao_flavors2
SET bean_origin_country = 'unknown' 
WHERE bean_origin_country='Â ' OR bean_origin_country = '';


----- Standardizing
 
 UPDATE cacao_flavors2
 SET bean_type = TRIM(LOWER(bean_type));
 
UPDATE cacao_flavors2
 SET bean_origin = TRIM(LOWER(bean_origin)); 
 
 UPDATE cacao_flavors2
 SET bean_origin_country = TRIM(LOWER(bean_origin_country));
 
 UPDATE cacao_flavors2
 SET company = TRIM(LOWER(company));
 
 UPDATE cacao_flavors2
 SET company_location = TRIM(LOWER(company_location));
 
 SELECT*
 FROM cacao_flavors2 ;
 
 -- let make the first letter in the word  capitalized
 
UPDATE cacao_flavors2
SET company = CONCAT(UPPER(LEFT(company, 1)),LOWER(SUBSTRING(company, 2)));
 
 UPDATE cacao_flavors2
SET company_location  = CONCAT(UPPER(LEFT(company_location, 1)),LOWER(SUBSTRING(company_location, 2))) ;
 
UPDATE cacao_flavors2
SET bean_origin = CONCAT(UPPER(LEFT(bean_origin, 1)),LOWER(SUBSTRING(bean_origin, 2))) ;
 
 
 SELECT company_location
 FROM cacao_flavors2 
 ORDER BY company_location ASC ;
 
 
 UPDATE cacao_flavors2
SET company_location = 'Czech Republic'
WHERE company_location = 'Czech republic' ;
 
SELECT DISTINCT company
FROM cacao_flavors2
ORDER BY company ASC ;
 
--- EDA

-- OVERALL RATING OVERVIEW 

SELECT  AVG(rating) avg_rating,
MIN(rating) min_rating,
MAX(rating) max_rating
FROM cacao_flavors2
 ;

--- RATING DISTRIBUTION
 
 SELECT rating, COUNT(*) AS count
 FROM cacao_flavors2
 GROUP BY rating
 ORDER BY count DESC ;
 
 --- TOP CHOCOLATE COMPANY
 
SELECT company,COUNT(*) count, AVG(rating) avg_rating
FROM cacao_flavors2
GROUP BY company
ORDER BY avg_rating DESC ;

SELECT company,COUNT(*) count
FROM cacao_flavors2
GROUP BY company
ORDER BY count DESC ;
 
 -- COCOA BEAN ORIGIN ANALYSIS
 
SELECT bean_origin_country,AVG(rating) rating
FROM cacao_flavors2
GROUP BY bean_origin_country
ORDER BY rating DESC ; 

SELECT bean_origin, COUNT(*) count
FROM cacao_flavors2
GROUP BY bean_origin
ORDER BY count DESC ;

-- COMPANY LOCATION ANALYSIS 

SELECT company_location ,AVG(rating) rating
FROM cacao_flavors2
GROUP BY company_location
ORDER BY rating DESC ; 

SELECT company_location, COUNT(*) count
FROM cacao_flavors2
GROUP BY company_location
ORDER BY count DESC ;

--- COCOA PERCENTAGE ANALYSIS

SELECT cocoa_percent ,AVG(rating) rating
FROM cacao_flavors2
GROUP BY cocoa_percent
ORDER BY rating DESC ;

--- BEAN TYPE ANALYSIS

SELECT bean_type ,AVG(rating) rating
FROM cacao_flavors2
GROUP BY bean_type
ORDER BY rating DESC ; 

SELECT bean_type, COUNT(*) count
FROM cacao_flavors2
GROUP BY bean_type
ORDER BY count DESC ;

--- TIME ANALYSIS
SELECT review_date ,AVG(rating) rating
FROM cacao_flavors2
GROUP BY review_date
ORDER BY review_date ASC ;  
 
---- TOP RATED CHOCOLATE 

 SELECT rating,company,COUNT(company) count
FROM cacao_flavors2
GROUP BY rating,company
ORDER BY rating DESC ; 
 
--- DATA QUALITY INSIGHT
 SELECT bean_type, COUNT(*)
 FROM cacao_flavors2
 WHERE bean_type = 'unknown';
 
 -- RANK CHOCOLATE FROM BEST TO WORST 
 SELECT company, bean_origin , rating ,
 DENSE_RANK() OVER( ORDER BY rating DESC ) AS ranking
 FROM cacao_flavors2
 ;
 
 --- TOP 3 COMPANIES
SELECT company, AVG(rating) avg_rating
FROM cacao_flavors2
GROUP BY company 
ORDER BY  avg_rating DESC
LIMIT 3 ;
 
 
 
 
 
 ---- best chocolate in each country 
 
 SELECT*
 FROM(
SELECT company, bean_origin_country, bean_origin, rating ,
RANK() OVER(PARTITION BY bean_origin_country ORDER BY rating DESC ) AS ranking
FROM cacao_flavors2) AS ranked
 WHERE ranking = 1;
 
 
 SELECT*
 FROM cacao_flavors2;
 
 
 
 
 
 
 
 
 

