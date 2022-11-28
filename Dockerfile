FROM ubuntu:latest

# Buildtime
RUN set -x; buildDeps='curl dnsutils iputils-ping golang-go git python3 python3-pip' \
    && apt-get update \
    && apt-get install -y $buildDeps \
    && git clone https://github.com/ffuf/ffuf

# Prepare files for build
WORKDIR /ffuf
RUN rm -f ./wordlist.txt \
    && rm -f ./sel.py \
    && rm -f ./requirements.txt
COPY ./wordlist.txt .
COPY ./sel.py .
COPY ./requirements.txt .

# Python and golang build
RUN python3 -m pip install -r ./requirements.txt \
    && go get \
    && go build

# Ffuf fuzzing and selenium browsing
RUN echo 'head -${FUZZ_COUNT} wordlist.txt > swordlist.txt' >> ~/.bashrc \
    && echo 'alias fuzz="alias fuzz; ./ffuf -w swordlist.txt -u https://${URL}?q=FUZZ -H \"User-Agent: Mozilla/5.0\""' >> ~/.bashrc \
    && echo 'alias sel="python3 sel.py"' >> ~/.bashrc

# Runtime
CMD echo 'Welcome to ast!\nAvailable commands (alias shorthands): sel, fuzz' ; /bin/bash