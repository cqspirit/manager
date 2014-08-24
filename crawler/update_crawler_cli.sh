#Stop ALL
supervisorctl stop all

MANAGER_CONFIG=https://raw.githubusercontent.com/cqspirit/manager/master/crawler/config.py 
AGENT_CONST=https://raw.githubusercontent.com/cqspirit/manager/master/crawler/const.py


BASE_DIR=/opt/crawl
AGENT_DIR=$BASE_DIR/agent
MANAGER_DIR=$BASE_DIR/manager
DC_USER=dc-agent

cd $MANAGER_DIR
git pull
curl $MANAGER_CONFIG > $MANAGER_DIR/config.py


cd $AGENT_DIR
git pull
curl $AGENT_CONST > $AGENT_DIR/const.py

supervisorctl start manager
