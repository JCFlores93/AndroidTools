FROM ubuntu:18.04

LABEL nogala.android-docker.flavour="ubuntu-standalone"

ARG GLIBC_VERSION="2.28-r0"

ENV ANDROID_SDK_HOME /opt/android-sdk-linux
ENV ANDROID_SDK_ROOT /opt/android-sdk-linux
ENV ANDROID_HOME /opt/android-sdk-linux
ENV ANDROID_SDK /opt/android-sdk-linux
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

# Install Required Tools
RUN apk -U update && apk -U add \
  bash \
  ca-certificates \
  curl \
  expect \
  fontconfig \
  git \
  make \
  libstdc++ \
  libgcc \
  mesa-dev \
  nodejs \
  npm \
  openjdk8 \
  pulseaudio-dev \
  su-exec \
  ncurses \
  unzip \
  wget \
  zlib \
  maven \
  ruby-full \
  && wget https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -O /etc/apk/keys/sgerrand.rsa.pub \
	&& wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk -O /tmp/glibc.apk \
	&& wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk -O /tmp/glibc-bin.apk \
	&& apk add /tmp/glibc.apk /tmp/glibc-bin.apk \
  && rm -rf /tmp/* \
	&& rm -rf /var/cache/apk/*

# Create android User
RUN mkdir -p /opt/android-sdk-linux \
  && addgroup android \
  && adduser android -D -G android -h /opt/android-sdk-linux -u 1000

# Copy Tools
COPY tools /opt/tools

# Copy Licenses
COPY licenses /opt/licenses

# Working Directory
WORKDIR /opt/android-sdk-linux

RUN /opt/tools/entrypoint.sh built-in
CMD /opt/tools/entrypoint.sh built-in
