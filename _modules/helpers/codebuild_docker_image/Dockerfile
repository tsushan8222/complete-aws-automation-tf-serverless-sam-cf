FROM "aws/codebuild/standard:4.0"

RUN apt-get update -y
RUN cd /tmp
RUN apt-get remove libssl-dev -y && apt-get update -y
RUN apt-get install -y make build-essential libssl1.0-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl
RUN rm -rf /root/.pyenv
RUN curl https://pyenv.run | bash
RUN CFLAGS=-I/usr/include/openssl LDFLAGS=-L/usr/lib pyenv install -v 2.7.8
RUN pyenv install -v 3.7.8
RUN pyenv global 3.7.8
RUN curl -L "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && unzip awscli-bundle.zip && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
RUN curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o "aws-sam-cli-linux-x86_64.zip" && unzip aws-sam-cli-linux-x86_64.zip -d sam-installation && ./sam-installation/install
RUN pyenv global 2.7.8
RUN ln -sf $(which python) /usr/bin/python
COPY requirements.txt .
RUN pip install -r requirements.txt
RUN npm install --global yarn
