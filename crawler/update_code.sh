#!/bin/bash
# setup users
set +e
useradd dc-agent -M -p $PASSWORD
set -e

BASE_DIR=/opt/crawl
AGENT_DIR=$BASE_DIR/agent
MANAGER_DIR=$BASE_DIR/manager

rm -rf $BASE_DIR
mkdir -p $BASE_DIR

cd $BASE_DIR
# Setup Manager
git clone https://github.com/xxr3376/Distribute-Crawler-Manager $MANAGER_DIR
curl https://raw.githubusercontent.com/cqspirit/manager/master/crawler/config.py > $MANAGER_DIR/config.py

chown -R dc-agent:dc-agent $MANAGER_DIR


cd $MANAGER_DIR
virtualenv .env
. .env/bin/activate
pip install -r requirement.txt


cd $BASE_DIR
# Setup Agent
git clone https://github.com/xxr3376/Distribute-Crawler-Agent $AGENT_DIR
curl https://raw.githubusercontent.com/cqspirit/manager/master/crawler/const.py > $AGENT_DIR/const.py

chown -R dc-agent:dc-agent $AGENT_DIR

cd $AGENT_DIR
virtualenv .env
. .env/bin/activate
yum install libxslt-devel -y
pip install -r requirement.txt

supervisorctl reload
