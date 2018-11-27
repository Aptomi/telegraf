FROM consul:latest as consul
FROM concourse/concourse-pipeline-resource:latest as concourse
FROM telegraf:1.8
COPY --from=consul /bin/consul /usr/local/bin/consul
COPY --from=concourse /opt/resource/fly /usr/local/bin/fly
ADD bin/concourse_workers.sh /usr/local/bin/
RUN apt update && apt install -y gawk
