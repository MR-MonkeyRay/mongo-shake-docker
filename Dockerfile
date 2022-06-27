FROM golang:1.18.3-alpine3.16 AS builder

WORKDIR /app

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
&&  apk --no-cache add tzdata ca-certificates musl curl bash make git zip gcc musl-dev

ENV GOPROXY=https://goproxy.cn

ARG VERSION=release-v2.6.6-20220323

RUN git clone https://github.com/alibaba/MongoShake.git -b ${VERSION} \
&&  cd MongoShake \
&&  go get gopkg.in/yaml.v3 \
&&  make linux

FROM alpine:3.16.0

RUN addgroup -g 1000 -S monkeyray \
&&  adduser -G monkeyray -u 1000 --disabled-password monkeyray \
&&  mkdir -p /opt/mongo-shake \
&&  curl -oL https://raw.githubusercontent.com/alibaba/MongoShake/${VERSION}/conf/collector.conf /opt/mongo-shake/\
&&  curl -oL https://raw.githubusercontent.com/alibaba/MongoShake/${VERSION}/conf/receiver.conf /opt/mongo-shake/ \
&&  chown monkeyray:monkeyray -R /opt/mongo-shake

WORKDIR /opt/mongo-shake

COPY --chown=monkeyray:monkeyray --from=builder /app/MongoShake/bin/ /opt/mongo-shake/

USER monkeyray

# incr_sync.http_port
# full_sync.http_port
# system_profile_port
EXPOSE 9100 9101 9200

ENTRYPOINT ["./collector"]
CMD ["-conf=/opt/mongo-shake/collector.conf", "-verbose=2"]
