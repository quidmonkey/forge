FROM mhart/alpine-node:6

MAINTAINER quidmonkey <quidmonkey@gmail.com>

# Bash function to alias forge command to run in Docker container:
#     forge() {
#         docker run -it --rm \
#             -v $(pwd):/data \
#             --name forge \
#             quidmonkey/forge:latest "$@"
#     }

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

# RUN git clone --depth 1 https://github.com/quidmonkey/forge.git /forge
COPY . /forge

VOLUME /data
WORKDIR /data

ENTRYPOINT ["/forge/forge"]
