#!/bin/bash
PASSWORD='crawler@next'
PIP_ARGS='-i http://pypi.douban.com/simple/'

#apt-get update
set -e
apt-get install git curl -y
apt-get install python-virtualenv -y
apt-get install supervisor -y
apt-get install phantomjs -y
apt-get install python-dev -y

set +e
useradd dc-agent -M -p $PASSWORD
set -e

cat >> /etc/supervisor/supervisord.conf << EOF
[inet_http_server]
port=127.0.0.1:9001
EOF

BASE_DIR=/opt/crawl
AGENT_DIR=$BASE_DIR/agent
MANAGER_DIR=$BASE_DIR/manager


rm -rf $BASE_DIR
mkdir -p $BASE_DIR

cd $BASE_DIR
# Setup Manager
git clone https://github.com/cqspirit/Distribute-Crawler-Manager $MANAGER_DIR
curl https://gist.githubusercontent.com/xxr3376/1ed626fa9c79598ba904/raw/5e4af499381867582991dcdd998bf3c81ce6c6b0/config.py > $MANAGER_DIR/config.py

chown -R dc-agent:dc-agent $MANAGER_DIR

touch /etc/supervisor/conf.d/agent.conf
chown dc-agent:dc-agent /etc/supervisor/conf.d/agent.conf
cat > /etc/supervisor/conf.d/manager.conf << EOF
[program:manager]
command=$MANAGER_DIR/run.sh
numprocs=1
user=dc-agent
directory=$MANAGER_DIR
stopsignal=TERM
autostart=true
autorestart=true
redirect_stderr=true
EOF

cd $MANAGER_DIR
virtualenv .env
. .env/bin/activate
pip install -r requirement.txt $PIP_ARGS


cd $BASE_DIR
# Setup Agent
git clone https://github.com/cqspirit/Distribute-Crawler-Agent $AGENT_DIR
curl https://raw.githubusercontent.com/cqspirit/manager/master/crawler/const.py > $AGENT_DIR/const.py

chown -R dc-agent:dc-agent $AGENT_DIR

cd $AGENT_DIR
virtualenv .env
. .env/bin/activate
apt-get install libxslt-dev -y
apt-get install libxml2-dev libxslt1-dev python-dev
pip install -r requirement.txt $PIP_ARGS

supervisorctl reload
