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
