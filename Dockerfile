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
HOST=${1}, TEAM=${2}, RUNS=${3}, ATTACKTIME=${4}, IDLETIME=${5}, PARALLEL=${6}\n\
Usage: setsid ./runffuf.sh aseff.sheldon.one Expelliarmus 1440 120 10 100 >/dev/null 2>&1'; /bin/bash