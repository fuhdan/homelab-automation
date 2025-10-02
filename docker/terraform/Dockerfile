FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERRAFORM_VERSION=1.9.8

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform.zip

RUN terraform --version

WORKDIR /workspace

CMD ["/bin/bash"]