FROM alpine:latest

RUN apk add --no-cache ruby ruby-bigdecimal ruby-etc ruby-json make aws-cli jq git bash
RUN apk add --no-cache -t build g++ curl ruby-dev
RUN gem install krane
# This can be used as the version once aws cli is fixed for kubectl 1.24:
# $(curl -L -s https://dl.k8s.io/release/stable.txt)
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl"
RUN chmod ugo+x kubectl
RUN mv kubectl /usr/bin
RUN apk del build
RUN mkdir /root/.kube
COPY kube-config /root/.kube/config
ENV KUBECONFIG /root/.kube/config

RUN mkdir -p /github/workspace
VOLUME /github/workspace
WORKDIR /github/workspace

ENTRYPOINT ["make", "deploy"]
