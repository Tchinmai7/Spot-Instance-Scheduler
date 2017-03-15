FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs unzip python-dev
WORKDIR /root
ADD Gemfile /root/Gemfile
ADD Gemfile.lock /root/Gemfile.lock
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
RUN gem install rails 
RUN bundle install
ADD . /root
