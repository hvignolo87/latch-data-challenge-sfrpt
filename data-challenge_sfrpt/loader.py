from os import getenv
from pathlib import Path

from numpy import NaN
import pandas as pd
from sqlalchemy import BIGINT, DATE, INTEGER, NUMERIC, TIMESTAMP, VARCHAR, create_engine
from sqlalchemy.engine.url import URL


def loader():
    """
    Load data from sf_crimes.jsonl into a PostgreSQL table.
    """

    root_dir = Path(__file__).parent
    df = pd.read_json(root_dir / "sf_crime_reports.jsonl", lines=True)

    df.replace({"": NaN, "null": NaN}, inplace=True)
    df["cnn"] = pd.to_numeric(df["cnn"], errors="coerce")

    db_url = URL(
        drivername="postgresql",
        username=getenv("POSTGRES_USER"),
        password=getenv("POSTGRES_PASSWORD"),
        host=getenv("POSTGRES_HOST"),
        port=getenv("POSTGRES_PORT"),
        database=getenv("POSTGRES_DB"),
        query={},
    )
    engine = create_engine(db_url)
    conn = engine.connect()

    dtypes = {
        "incident_datetime": TIMESTAMP(),
        "incident_date": DATE(),
        "incident_time": VARCHAR(),
        "incident_year": VARCHAR(),
        "incident_day_of_week": VARCHAR(),
        "report_datetime": TIMESTAMP(),
        "row_id": BIGINT(),
        "incident_id": INTEGER(),
        "incident_number": INTEGER(),
        "cad_number": INTEGER(),
        "report_type_code": VARCHAR(),
        "report_type_description": VARCHAR(),
        "filed_online": VARCHAR(),
        "incident_code": BIGINT(),
        "incident_category": VARCHAR(),
        "incident_subcategory": VARCHAR(),
        "incident_description": VARCHAR(),
        "resolution": VARCHAR(),
        "intersection": VARCHAR(),
        "cnn": INTEGER(),
        "police_district": VARCHAR(),
        "analysis_neighborhood": VARCHAR(),
        "supervisor_district": VARCHAR(),
        "latitude": NUMERIC(),
        "longitude": NUMERIC(),
        "point": VARCHAR(),
    }

    df.to_sql(
        name="crimes",
        con=conn,
        if_exists="replace",
        index=False,
        dtype=dtypes,
    )


if __name__ == "__main__":
    loader()
