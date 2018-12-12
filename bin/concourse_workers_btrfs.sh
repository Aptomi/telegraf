#!/bin/bash
set -e


concourse_worker_list() {
	kubectl -n ${CONCOURSE_NS} get pods -l release=concourse,app=concourse-worker -o jsonpath='{.items[*].metadata.name}' 
} 

concourse_worker_brtfs_du() {
	local pod_name=$1
	local cmd="/concourse-work-dir/${CONCOURSE_VERSION}/assets/btrfs/btrfs filesystem usage --raw /concourse-work-dir/volumes"
	kubectl -n ${CONCOURSE_NS} exec -ti ${pod_name} -- ${cmd}
} 


btrfs_parse() {
	local pod_name=$1
	awk -v pod_name=${pod_name} '
	/Device size:/ {
		size=$3
	}
	/Free \(estimated\):/ {
		free=$3
	}
	END {
		printf("concourse,worker=%s size=%d,free=%d,usage_percent=%d\n", pod_name, size, free, (size-free)*100/size )	
	}
'
} 

KUBECONFIG=/tmp/kubeconfig
CONCOURSE_NS=concourse
CONCOURSE_VERSION="4.2.1"

test -n "${KUBECONFIG_DATA}"
test -f ${KUBECONFIG} || echo "${KUBECONFIG_DATA}" | base64 -d > ${KUBECONFIG}

kubectl version > /dev/null 2>&1

for pod in $(concourse_worker_list); do 	
	concourse_worker_brtfs_du ${pod} | btrfs_parse ${pod}
		
done
