#!/bin/sh
set -e

source()  {
        (fly -t main status || fly -t main login -c ${CONCOURSE_URL} -u ${CONCOURSE_USERNAME} -p ${CONCOURSE_PASSWORD}) >/dev/null 2>&1
        fly -t main workers
}

fake_source() {
        cat<<EOF
concourse-worker-0  0  linux  none  none  running  2.1
concourse-worker-1  1  linux  none  none  runni2ng  2.1
concourse-worker-2  1  linux  none  none  running  2.1
EOF
}

parse() {
        awk -F" " '{
                printf("concourse,worker=%s state=%s,containers=%s %d000000000\n", $1, ($6 == "running") ? 1 : 0, $2, systime())
        }'
}


source | parse

