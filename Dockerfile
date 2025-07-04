FROM rocker/shiny:latest

RUN apt-get update && apt-get install -y \
    libproj-dev \
    proj-data \
    proj-bin \
    libgdal-dev \
    gdal-bin \
    libgeos-dev \
    libudunits2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    && ln -s /usr/lib/x86_64-linux-gnu/libproj.so.22 /usr/lib/x86_64-linux-gnu/libproj.so.25 || true \
    && ln -s /usr/lib/x86_64-linux-gnu/libgdal.so.30 /usr/lib/x86_64-linux-gnu/libgdal.so.34 || true \
    && apt-get clean

ENV R_REMOTES_UPGRADE=never
ENV R_REMOTES_NO_ERRORS_FROM_WARNINGS=true

RUN R -e "install.packages(c('shiny', 'DT', 'dplyr', 'pROC', 'epiR', 'htmlTable'))"

COPY . /home/app

RUN R -e "install.packages('/home/app/submission.package', repos = NULL, type = 'source')"

EXPOSE 3838

CMD ["Rscript", "/home/app/start_app.R"]
