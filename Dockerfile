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

RUN R -e "install.packages(c('devtools', 'shiny', 'DT', 'dplyr', 'pROC', 'epiR', 'roxygen2', 'usethis', 'remotes', 'htmlTable'))"

COPY . /home/app

RUN R -e "remotes::install_github('Youngho-Cha/Submission-package-using-R')"

EXPOSE 3838

CMD ["Rscript", "/home/app/docker/start_app.R"]
