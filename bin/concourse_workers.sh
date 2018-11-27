#!/bin/sh

fly -t main status || fly -t main login -c ${CONCOURSE_URL} -u ${CONCOURSE_USERNAME} -p ${CONCOURSE_PASSWORD}
fly -t main workers | awk -F" " '{printf("concourse,worker=%s containers=%d state=%s\n", $1, $2, $6)}'
