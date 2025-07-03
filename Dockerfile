FROM rocker/shiny:latest

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    && apt-get clean

ENV R_REMOTES_UPGRADE=never
ENV R_REMOTES_NO_ERRORS_FROM_WARNINGS=true

RUN R -e "install.packages(c('devtools', 'shiny', 'DT', 'dplyr', 'pROC', 'epiR', 'roxygen2', 'usethis', 'remotes', 'htmlTable'))"

RUN R -e "devtools::install_github('Youngho-Cha/Submission-package-using-R', force=TRUE, upgrade='never')"

COPY . /home/app

EXPOSE 3838

CMD ["Rscript", "/home/app/start_app.R"]
