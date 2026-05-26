ARG IMG_VER_TAG=${IMG_VER_TAG:-24.04}

FROM ubuntu:${IMG_VER_TAG}

ARG GITHUB_USERNAME
ARG HOST_USER
ARG HOST_UID=1000
ARG HOST_GID=1000

ENV HOME=/home/${HOST_USER} \
    USER=${HOST_USER} \
    DEBIAN_FRONTEND=noninteractive \
    CHEZMOI_USERNAME=${HOST_USER}

RUN apt-get update -y && \
    apt-get install -y curl && \
    groupmod -n ${HOST_USER} ubuntu && \
    usermod -l ${HOST_USER} -d /home/${HOST_USER} -m -u ${HOST_UID} -g ${HOST_GID} ubuntu && \
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init $GITHUB_USERNAME && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/${HOST_USER}
USER ${HOST_USER}

CMD ["/bin/bash"]
