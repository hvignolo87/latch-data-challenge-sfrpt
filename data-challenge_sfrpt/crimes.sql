CREATE TABLE IF NOT EXISTS public.crimes (
    incident_datetime timestamp
    , incident_date date
    , incident_time varchar
    , incident_year varchar
    , incident_day_of_week varchar
    , report_datetime timestamp
    , row_id bigint PRIMARY KEY NOT NULL
    , incident_id int
    , incident_number int
    , cad_number int
    , report_type_code varchar
    , report_type_description varchar
    , filed_online varchar
    , incident_code bigint
    , incident_category varchar
    , incident_subcategory varchar
    , incident_description varchar
    , resolution varchar
    , intersection varchar
    , cnn int
    , police_district varchar
    , analysis_neighborhood varchar
    , supervisor_district int
    , latitude numeric
    , longitude numeric
    , point varchar
);

-- For the query filtering incidents by analysis neighborhood, incident category, and incident datetime
CREATE INDEX CONCURRENTLY IF NOT EXISTS
crimes_analysis_incident_cat_incident_dt_idx
ON crimes (analysis_neighborhood, incident_category, incident_datetime);

-- For the query grouping incidents by analysis neighborhood:
CREATE INDEX CONCURRENTLY IF NOT EXISTS
crimes_analysis_neighborhood_idx
ON crimes (analysis_neighborhood);

-- For the query counting open or active incidents grouped by police district
CREATE INDEX CONCURRENTLY IF NOT EXISTS
crimes_resolution_police_district_idx
ON crimes (resolution, police_district);

-- For the query counting incidents grouped by police district
CREATE INDEX CONCURRENTLY IF NOT EXISTS
crimes_police_district_idx
ON crimes (police_district);

-- For the query involving window functions and grouping by incident timestamp and analysis neighborhood
CREATE INDEX CONCURRENTLY IF NOT EXISTS
crimes_analysis_incident_dt_idx
ON crimes (analysis_neighborhood, incident_datetime);

CREATE INDEX CONCURRENTLY IF NOT EXISTS
crimes_incident_subcategory_idx
ON crimes (incident_subcategory);

CREATE INDEX CONCURRENTLY IF NOT EXISTS
crimes_report_datetime_idx
ON crimes (report_datetime);
