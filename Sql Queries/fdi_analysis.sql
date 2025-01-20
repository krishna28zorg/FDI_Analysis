-- This File Contains SQL commands that are required only for data transformation


-- Load data from the CSV file into the `investment_data` table
LOAD DATA INFILE '/path/to/your/file.csv'
INTO TABLE investment_data
FIELDS TERMINATED BY ','  -- Assuming the CSV is comma-separated
ENCLOSED BY '"'           -- Enclosing values with double quotes
LINES TERMINATED BY '\n'  -- Line break after each record
IGNORE 1 ROWS;            -- Ignore the header row if your CSV has headers

-- Create the `investment_periods` table to store aggregated data
CREATE TABLE investment_periods (
    sector VARCHAR(255),
    total_2000_2004 DECIMAL(15,2),
    total_2004_2009 DECIMAL(15,2),
    total_2010_2014 DECIMAL(15,2),
    total_2015_2017 DECIMAL(15,2)
);

-- Insert aggregated data into `investment_periods` table
INSERT INTO investment_periods (sector, total_2000_2004, total_2004_2009, total_2010_2014, total_2015_2017)
SELECT
    sector,
    (COALESCE(`2000-01`, 0) + COALESCE(`2001-02`, 0) + COALESCE(`2002-03`, 0) + COALESCE(`2003-04`, 0) + COALESCE(`2004-05`, 0)) AS total_2000_2004,
    (COALESCE(`2005-06`, 0) + COALESCE(`2006-07`, 0) + COALESCE(`2007-08`, 0) + COALESCE(`2008-09`, 0) + COALESCE(`2009-10`, 0)) AS total_2004_2009,
    (COALESCE(`2010-11`, 0) + COALESCE(`2011-12`, 0) + COALESCE(`2012-13`, 0) + COALESCE(`2013-14`, 0) + COALESCE(`2014-15`, 0)) AS total_2010_2014,
    (COALESCE(`2015-16`, 0) + COALESCE(`2016-17`, 0)) AS total_2015_2017
FROM
    investment_data;

-- View the total investment for each sector
SELECT
    sector,
    ROUND(total_2000_2004 + total_2004_2009 + total_2010_2014 + total_2015_2017, 2) AS TotalInvestment
FROM
    investment_periods
ORDER BY
    sector;
