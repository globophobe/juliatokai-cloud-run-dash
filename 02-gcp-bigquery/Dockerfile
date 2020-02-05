FROM julia:latest

RUN useradd --create-home --shell /bin/bash julia

USER julia

ADD Project.toml /Project.toml
ADD Manifest.toml /Manifest.toml

ADD app.jl /app.jl
ADD bigquery.jl /bigquery.jl
ADD bitmex.jl /bitmex.jl

ENV JULIA_PROJECT "."
ENV IS_PRODUCTION "true"

RUN julia -e "using Pkg; pkg\"activate . \"; pkg\"instantiate\"; pkg\"precompile\"; "

RUN julia -e 'using Conda; Conda.add("google-cloud-bigquery[pyarrow]", channel = "conda-forge")';

ENV JULIA_DEPOT_PATH "/home/julia/.julia"

ADD .env /.env
CMD julia app.jl
