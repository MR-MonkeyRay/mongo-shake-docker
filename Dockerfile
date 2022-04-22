FROM golang:alpine3.15 AS builder

WORKDIR /app

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
&&  apk --no-cache add tzdata ca-certificates musl curl bash make git zip gcc musl-dev

ENV GOPROXY=https://goproxy.cn

ARG VERSION=release-v2.6.6-20220323

RUN git clone https://github.com/alibaba/MongoShake.git -b ${VERSION} \
&&  cd MongoShake \
&&  make linux

FROM alpine:3.15.4

ENV DIRPATH=/opt/mongo-shake
WORKDIR ${DIRPATH}

RUN addgroup -g 1000 -S monkeyray \
&&  adduser -G monkeyray -u 1000 --disabled-password monkeyray \
&&  mkdir -p ${DIRPATH} \
&&  chown monkeyray:monkeyray -R ${DIRPATH}

COPY --chown=monkeyray:monkeyray --from=builder /app/MongoShake/bin/ ${DIRPATH}/
COPY --chown=monkeyray:monkeyray ./collector.conf ${DIRPATH}/

USER monkeyray

# incr_sync.http_port
EXPOSE 9100
# full_sync.http_port
EXPOSE 9101
# system_profile_port
EXPOSE 9200

CMD ["${DIRPATH}/collector", "-conf=${DIRPATH}/collector.conf", "-verbose=2"]
