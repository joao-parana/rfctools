#
# rfctools Docker File
#

FROM fedora:25
MAINTAINER Paul E. Jones <paulej@packetizer.com>

# Install binaries from Fedora needed for golang, python, xml2rfc, and mmark
RUN dnf -y install python python-lxml golang golang-github-BurntSushi-toml \
        golang-github-BurntSushi-toml-devel git && \
    dnf clean all

# Update pip and install xml2rfc, creating the default cache directory
RUN pip install --upgrade pip && \
    pip install xml2rfc && \
    mkdir -p /var/cache/xml2rfc

# Clone the mmark repository and build the mmark binary
ENV GOPATH /usr/share/gocode
RUN git clone --depth=1 --branch=master https://github.com/miekg/mmark.git \
        /usr/share/gocode/src/github.com/miekg/mmark && \
    rm -fr /usr/share/gocode/src/github.com/miekg/mmark/.git && \
    cd /usr/share/gocode/src/github.com/miekg/mmark/mmark/ && \
    go build && \
    ln -s /usr/share/gocode/src/github.com/miekg/mmark/mmark/mmark \
        /usr/bin/mmark

# Put the md2rfc script in place
COPY bin/md2rfc /usr/bin/

# Specify the working directory when a container is started
WORKDIR /rfc
