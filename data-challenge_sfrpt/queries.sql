-- How many burglaries occurred in the South of Market neighborhood between 2018-05-01 and 2018-05-31 inclusive?
SELECT COUNT(*) AS num_burglaries
FROM crimes
WHERE analysis_neighborhood = 'South of Market'
    AND incident_category = 'Burglary'
    AND incident_datetime > '2018-05-01'::timestamp
    AND incident_datetime <= '2018-05-31'::timestamp;



-- 2. Across the entire dataset, what are the top five neighborhoods with the fewest number of reported incidents? (Note: ignoring null/unknown neighborhood)
SELECT
    analysis_neighborhood AS top_analysis_neighborhoods
    , COUNT(*) AS num_incidents
FROM crimes
WHERE analysis_neighborhood IS NOT NULL
GROUP BY 1
ORDER BY 2 ASC
LIMIT 5;



-- 3. Which police district has the most open/active incidents? Which has the fewest?
-- Most
SELECT
    police_district
    , COUNT(*) AS num_open_or_active_incidents
FROM crimes
WHERE resolution = 'Open or Active'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Fewest
SELECT
    police_district
    , COUNT(*) AS num_open_or_active_incidents
FROM crimes
WHERE resolution = 'Open or Active'
GROUP BY 1
ORDER BY 2 ASC
LIMIT 1;
