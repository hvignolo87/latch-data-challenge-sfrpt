CREATE OR REPLACE VIEW crimes_aggregate AS (
    SELECT
        incident_id
        , DATE_BIN('15 minutes', incident_datetime, '1987-03-27'::timestamp) AS incident_ts
        , STRING_AGG(DISTINCT incident_subcategory, '||' ORDER BY incident_subcategory) AS incident_categories
        , MIN(incident_datetime) AS first_incident_datetime
        , MIN(report_datetime) AS first_report_datetime
        , COUNT(*) OVER (
            PARTITION BY analysis_neighborhood
            ORDER BY DATE_BIN('15 minutes', incident_datetime, '1987-03-27'::timestamp)
            RANGE BETWEEN CURRENT ROW AND INTERVAL '15 minutes' FOLLOWING
        ) AS neighborhood_incidents
    FROM crimes
    GROUP BY incident_ts, incident_id, analysis_neighborhood
    ORDER BY incident_ts, incident_id
);
