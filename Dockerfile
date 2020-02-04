FROM julia:1.3.1

RUN useradd --create-home --shell /bin/bash julia

USER julia

ADD Project.toml /Project.toml
ADD Manifest.toml /Manifest.toml
ADD app.jl /app.jl

ENV JULIA_PROJECT "."

RUN julia -e "using Pkg; pkg\"activate . \"; pkg\"instantiate\"; pkg\"precompile\"; "

ENV JULIA_DEPOT_PATH "/home/julia/.julia"

CMD julia app.jl
