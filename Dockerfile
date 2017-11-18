# The MIT License
#
#  Copyright (c) 2015, CloudBees, Inc.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

FROM jenkinsci/slave
MAINTAINER good.midget@gmail.com

USER root

RUN apt-get -qy update && \
    apt-get -qy install apt-utils \
                        build-essential \
                        devscripts \
                        python-dev \
                        python3 \
                        python3-dev \
                        python3-venv \
                        libbz2-dev \
                        libexpat1-dev \
                        libgconf-2-4 \
                        liblzma-dev \
                        libncurses5-dev \
                        libncursesw5-dev \
                        libreadline-dev \
                        libssl-dev \
                        libsqlite3-dev \
                        libxss1 \
                        tk-dev \
                        xvfb \
                        zlib1g-dev

RUN wget https://www.python.org/ftp/python/3.6.2/Python-3.6.2.tar.xz
RUN tar xf Python-3.6.2.tar.xz && \
    cd Python-3.6.2 && \
    ./configure --enable-optimizations && \
    make -j 8 && \
    make altinstall

# Docker
RUN curl -fsSL get.docker.com -o get-docker.sh
RUN sh get-docker.sh
RUN gpasswd -a jenkins docker

# RUN export CLOUD_SDK_REPO="cloud-sdk-jessie" && \
#     echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
#     curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
#     apt-get -qy install google-cloud-sdk kubectl

RUN wget https://dl-ssl.google.com/linux/linux_signing_key.pub && \
    apt-key add linux_signing_key.pub && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee -a /etc/apt/sources.list && \
    apt-get -qy update && \
    apt-get -qy install google-chrome-stable

RUN apt-get -qy clean
RUN rm -rf /var/lib/apt/lists/*

USER jenkins
COPY jenkins-slave /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]
