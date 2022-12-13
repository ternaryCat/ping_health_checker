FROM ruby:3.1.3-slim

ENV LANG C.UTF-8

# build-essential libpq-dev - for pg
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev\
                       && rm -rf /var/lib/apt/lists/*\
                       && gem install bundler -v 2.3.26

WORKDIR /home/project

COPY docker/web/docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
