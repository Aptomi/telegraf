#!/bin/sh
set -e
(fly -t main status || fly -t main login -c ${CONCOURSE_URL} -u ${CONCOURSE_USERNAME} -p ${CONCOURSE_PASSWORD}) >/dev/null 2>&1
fly -t main workers |  awk -F" " '{
	printf("concourse,worker=%s state=%s,containers=%s %d000000000\n", $1, ($6 == "running") ? 1 : 0, $2, systime())
}'

