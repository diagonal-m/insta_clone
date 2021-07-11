FROM ruby:2.6.4

ARG WORKDIR=/var/www/insta_clone_app

# デフォルトの locale `C` を `C.UTF-8` に変更する
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# タイムゾーンを日本時間に変更
ENV TZ Asia/Tokyo

RUN apt-get update && apt-get install -y nodejs npm mariadb-client shared-mime-info redis-server imagemagick

RUN gem install rails -v "5.2.6"

RUN npm install -g yarn@1

RUN mkdir -p $WORKDIR

WORKDIR $WORKDIR

EXPOSE 3000