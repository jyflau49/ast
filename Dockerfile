FROM ubuntu:latest

# Buildtime
RUN set -x; buildDeps='curl dnsutils iputils-ping golang-go git python3 python3-pip' \
    && apt-get update \
    && apt-get install -y $buildDeps \
    && git clone https://github.com/ffuf/ffuf

# Ffuf golang build
WORKDIR /ffuf
RUN go get \
    && go build

# Prepare files for build
WORKDIR /code
RUN rm -f ./wordlist.txt \
    && rm -f ./sel.py \
    && rm -f ./requirements.txt
COPY ./code/wordlist.txt .
COPY ./code/sel.py .
COPY ./code/requirements.txt .

# Python deps install
RUN python3 -m pip install -r ./requirements.txt

# Ffuf fuzzing and selenium browsing
RUN echo 'head -${FUZZ_COUNT} ./wordlist.txt > ./swordlist.txt' >> ~/.bashrc \
    && echo 'alias fuzz="../ffuf/ffuf -w ./swordlist.txt -u https://${URL}?q=FUZZ -H \"User-Agent: Mozilla/5.0 (astbot)\"; alias fuzz"' >> ~/.bashrc \
    && echo 'alias sel="python3 ./sel.py; alias sel"' >> ~/.bashrc

# Runtime
CMD echo 'Welcome to ast!\nAvailable commands (alias shorthands): sel, fuzz' ; /bin/bash