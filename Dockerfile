FROM ubuntu

RUN apt-get update && apt-get -y install git make curl  wget gcc docker.io bc zip
RUN apt-get install --yes gnupg
RUN curl --silent --location https://deb.nodesource.com/setup_10.x |  bash -
RUN apt-get install --yes nodejs
RUN apt-get install --yes build-essential
RUN apt-get install -y python-pip


# jq json processor
RUN apt-get install -y jq

# aws cli
RUN pip install awscli

# Configure Go

ENV GOROOT /opt/go
ENV GOPATH /opt/gopath
ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH
ENV GOVERSION 1.11.2


RUN mkdir -p ${GOPATH}/bin
RUN mkdir -p ${GOROOT}

# install go
RUN cd /opt && wget https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz && \
    tar -C /opt -zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz

# install dep 
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

# install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /bin/docker-compose
RUN chmod +x /bin/docker-compose


# install dlv debugger 
RUN go get github.com/derekparker/delve/cmd/dlv

WORKDIR $GOPATH


#yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |  apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" |  tee /etc/apt/sources.list.d/yarn.list
RUN  apt-get update &&  apt-get install yarn

#install some other dependencies
RUN npm install webpack webpack-cli webpack-dev-middleware  webpack-hot-middleware -g

#serverless framework
RUN npm install -g serverless 

CMD service docker start

