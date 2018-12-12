FROM consul:latest as consul
FROM concourse/concourse-pipeline-resource:latest as concourse
FROM wernight/kubectl:latest as kubectl
FROM telegraf:1.8
COPY --from=consul /bin/consul /usr/local/bin/consul
COPY --from=concourse /opt/resource/fly /usr/local/bin/fly
COPY --from=kubectl /usr/local/bin/kubectl /usr/local/bin/kubectl
ADD bin/concourse_workers.sh /usr/local/bin/
ADD bin/concourse_workers_btrfs.sh /usr/local/bin
RUN apt update && apt install -y gawk
