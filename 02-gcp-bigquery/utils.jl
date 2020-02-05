module Utils

export CREDENTIALS, DATASET, TABLE, LOCATION, set_env

CREDENTIALS = "GOOGLE_APPLICATION_CREDENTIALS"
DATASET = "BIGQUERY_DATASET"
TABLE = "BIGQUERY_TABLE"
LOCATION = "BIGQUERY_LOCATION"

ENV_VARS = (CREDENTIALS, DATASET, TABLE, LOCATION)

function set_env()
    path = "env.yaml"
    open(path) do file
        for line in eachline(file)
            line = replace(line, "\n" => "")
            parts = split(line, ":")

            key = strip(parts[1])
            value = strip(parts[2])

            if key == CREDENTIALS
                if isfile(value) 
                    value = abspath(value)
                end
            end
          
            if !haskey(ENV, key)
                ENV[key] = value
            end
        end
    end
end

end
