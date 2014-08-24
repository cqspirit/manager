#Stop ALL
supervisorctl stop all

MANAGER_CONFIG=https://gist.githubusercontent.com/xxr3376/452b57d05dae6fc8db9b/raw/073aa75c81e58360da491442e2776272f4c009a2/config.py 
AGENT_CONST=https://gist.githubusercontent.com/xxr3376/5efefe30b01aff86774b/raw/8cb61e2e71ec3c525352d2332034ea3f03339150/const.py


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
