module BigQuery

export load_dataframe

using DataFrames
using PyCall
include("utils.jl")
using .Utils

set_env()

py"""
import os
import google.auth
from google.cloud import bigquery

def query(credentials_file, dataset, table_name, date_from, date_to, location=None):
    if os.path.exists(credentials_file):
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = credentials_file

    credentials, project_id = google.auth.default(
        scopes=["https://www.googleapis.com/auth/cloud-platform"]
    )
    bq = bigquery.Client(credentials=credentials, project=project_id, location=location)
    job_config = bigquery.QueryJobConfig(
        query_parameters=[
            bigquery.ScalarQueryParameter("date_from", "DATE", date_from),
            bigquery.ScalarQueryParameter("date_to", "DATE", date_to),
        ]
    )

    # Query by partition.
    table_id = f"{dataset}.{table_name}"
    sql = f'''
        SELECT * FROM {table_id}
        WHERE date >= @date_from
        AND date <= @date_to
        ORDER BY timestamp, index;
    '''
    return bq.query(sql, job_config=job_config)
"""

function load_dataframe(date_from, date_to)
    result = py"query"(
      ENV[CREDENTIALS], ENV[DATASET], ENV[TABLE], date_from, date_to; location=ENV[LOCATION]
    )

    timestamp = []
    open = []
    high = []
    low = []
    close = []
    buyVolume = []
    sellVolume = []
    buyTicks = []
    sellTicks = []
  
    for row in result
      push!(timestamp, get(row, 1))
      push!(open, get(row, 3))
      push!(high, get(row, 4))
      push!(low, get(row, 5))
      push!(close, get(row, 6))
      push!(buyVolume, get(row, 7))
      push!(sellVolume, get(row, 8))
      push!(buyTicks, get(row, 9))
      push!(sellTicks, get(row, 10))
    end

    DataFrames.DataFrame(
      timestamp = timestamp,
      open = open,
      high = high,
      low = low,
      close = close,
      buyVolume = buyVolume,
      sellVolume = sellVolume,
      buyTicks = buyTicks,
      sellTicks = sellTicks,
    )
end

end
