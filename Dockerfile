FROM ruby:3.2.2

RUN apt update \
    && apt install -y nodejs postgresql-client npm \
    && rm -rf /var/lib/apt/lists/* \
    && npm install --global yarn \
    && apt install -y imagemagick
RUN mkdir /everydayrails-rspec-jp-2022
WORKDIR /everydayrails-rspec-jp-2022
COPY Gemfile /everydayrails-rspec-jp-2022/Gemfile
COPY Gemfile.lock /everydayrails-rspec-jp-2022/Gemfile.lock
COPY . /everydayrails-rspec-jp-2022

# Japanese
RUN apt-get update && apt-get install -y locales task-japanese && \
    locale-gen ja_JP.UTF-8 && \
    localedef -f UTF-8 -i ja_JP ja_JP && \
    apt-get -qqy --no-install-recommends install -y fonts-takao-gothic fonts-takao-mincho && \
    dpkg-reconfigure --frontend noninteractive locales && \
    fc-cache -fv
ENV LANG ja_JP.UTF-8

# Chromeをインストール
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable

# ChromeDriverをインストール
RUN apt-get update && apt-get install -y unzip graphviz && \
    CHROME_VERSION=$(google-chrome-stable --version | cut -d " " -f3) && \
    echo "Chrome_Version: ${CHROME_VERSION}" && \
    curl -sS -o /root/chromedriver_linux64.zip https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$CHROME_VERSION/linux64/chromedriver-linux64.zip &&\
    unzip ~/chromedriver_linux64.zip -d ~/ && \
    rm ~/chromedriver_linux64.zip && \
    chown root:root ~/chromedriver-linux64/chromedriver && \
    chmod 755 ~/chromedriver-linux64/chromedriver && \
    mv ~/chromedriver-linux64/chromedriver /usr/bin/chromedriver