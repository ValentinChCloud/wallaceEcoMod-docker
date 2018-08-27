FROM rocker/shiny:latest

# Installing packages needed for check traffic on the container and kill if none

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    apt-get -qq update && apt-get install --no-install-recommends -y libgdal-dev libproj-dev net-tools procps libcurl4-openssl-dev libxml2-dev libssl-dev openjdk-8-jdk libgeos-dev texlive-xetex  texlive-fonts-recommended texlive-latex-recommended lmodern && \
    # Installing R package dedicated to the shniy app
    R CMD javareconf && \
    Rscript -e "install.packages('wallace')" && \
    # Bash script to check traffic
    mkdir /srv/shiny-server/sample-apps/SIG


RUN apt-get install -y git-all
RUN git clone -b v1.0.5 https://github.com/wallaceEcoMod/wallace.git &&\
    mv /wallace/inst /srv/shiny-server/sample-apps/SIG/wallace


# Add maxent module
RUN wget -O /usr/local/lib/R/site-library/dismo/java/maxent.jar https://github.com/mrmaxent/Maxent/blob/master/ArchivedReleases/3.3.3e/maxent.jar?raw=true

# Monitoriring life container
ADD ./monitor_traffic.sh /monitor_traffic.sh

# Adapt download function to export to history Galaxy
COPY ./global.r /srv/shiny-server/sample-apps/SIG/wallace/shiny/
COPY ./shiny-server.conf /etc/shiny-server/shiny-server.conf


# Bash script to lauch all process needed
COPY shiny-server.sh /usr/bin/shiny-server.sh

RUN apt-get install -y r-cran-rjava
RUN Rscript -e "install.packages('rJava')"
RUN mkdir /import

# Python script to export data to history Galaxy

CMD ["/usr/bin/shiny-server.sh"]
