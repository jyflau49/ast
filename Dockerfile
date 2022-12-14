FROM ubuntu:latest

# Buildtime
RUN set -x; buildDeps='curl dnsutils iputils-ping golang-go git' \
    && apt-get update \
    && apt-get install -y $buildDeps \
    && git clone https://github.com/ffuf/ffuf

# Golang build ffuf
WORKDIR /ffuf
RUN go get \
    && go build

# Prepare files for /ffuf
RUN rm -f ./dscqehn.txt \
    && rm -f ./runffuf.sh \
    && rm -f ./ua.txt
COPY ./code/dscqehn.txt .
COPY --chmod=700 ./code/runffuf.sh .
COPY ./code/ua.txt .

# Runtime banner
CMD echo 'Welcome to vanilla_ffuf!\nENVs:\
HOST=${1}, TEAM=${2}, RUNS=${3}, ATTACKTIME=${4}, IDLETIME=${5}, PARALLEL=${6}, DELAY=${7}, ISTOR=${8}\n\
Usage: setsid ./runffuf.sh team42-cyberwargames-ratecontrols.akamaized.net titanium 86400 60 2 80 1 DIRECT >/dev/null 2>&1'; /bin/bash