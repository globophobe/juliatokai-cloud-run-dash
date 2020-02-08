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

def query(credentials_file, dataset, table_name, date, location=None):
    if os.path.exists(credentials_file):
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = credentials_file

    credentials, project_id = google.auth.default(
        scopes=["https://www.googleapis.com/auth/cloud-platform"]
    )
    bq = bigquery.Client(credentials=credentials, project=project_id, location=location)
    job_config = bigquery.QueryJobConfig(
        query_parameters=[
            bigquery.ScalarQueryParameter("date", "DATE", date),
        ]
    )

    # Query by partition.
    table_id = f"{dataset}.{table_name}"
    sql = f'''
        SELECT * FROM {table_id}
        WHERE date >= @date
        ORDER BY timestamp;
    '''
    return bq.query(sql, job_config=job_config)
"""

function load_dataframe(date)
    result = py"query"(
      ENV[CREDENTIALS], ENV[DATASET], ENV[TABLE], date; location=ENV[LOCATION]
    )

    date = []
    timestamp = []
    price = []
    averagePrice = []
    buyVolume = []
    sellVolume = []
    exponent = []
    notional = []
 
    for row in result
      push!(date, get(row, 0))
      push!(timestamp, get(row, 1))
      push!(price, get(row, 2))
      push!(averagePrice, get(row, 3))
      push!(buyVolume, get(row, 4))
      push!(sellVolume, get(row, 5))
      push!(exponent, get(row, 6))
      push!(notional, get(row, 7))
    end

    DataFrames.DataFrame(
      date = date,
      timestamp = timestamp,
      price = price,
      averagePrice = averagePrice,
      buyVolume = buyVolume,
      sellVolume = sellVolume,
      exponent = exponent,
      notional = notional
    )
end

end
