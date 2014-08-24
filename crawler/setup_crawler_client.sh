#!/bin/sh
set -e
PASSWORD='crawler@next'

# Setup Python 2.7.6
cd /tmp
yum -y update
yum groupinstall -y development
yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel wget
yum install xz-libs -y

wget http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tar.xz
xz -d Python-2.7.6.tar.xz
tar -xvf Python-2.7.6.tar
cd Python-2.7.6
./configure --prefix=/usr/local
make && make install

# Setup Setuptools
cd /tmp
wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz
tar -xvf setuptools-1.4.2.tar.gz
cd setuptools-1.4.2
python setup.py install

# Setup PIP
yum install -y curl
curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | python -

# Setup virtualenv
pip install virtualenv

# Setup supervisor
pip install supervisor
echo_supervisord_conf > /etc/supervisord.conf
mkdir -p /etc/supervisord.d/

cat >> /etc/supervisord.conf << EOF
[include]
files=/etc/supervisord.d/*.conf
[inet_http_server]
port=127.0.0.1:9001
EOF
curl https://raw.githubusercontent.com/cqspirit/manager/master/crawler/supervisord.sh > /etc/rc.d/init.d/supervisord

chmod +x /etc/rc.d/init.d/supervisord
chkconfig --add supervisord
chkconfig supervisord on
service supervisord start

# setup phantomJS
cd /tmp
yum install -y fontconfig freetype libfreetype.so.6 libfontconfig.so.1 libstdc++.so.6
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2 -O phantomjs.tar.bz2
bunzip2 phantomjs.tar.bz2
tar xvf phantomjs.tar
mv phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/bin/

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
curl https://gist.githubusercontent.com/xxr3376/452b57d05dae6fc8db9b/raw/073aa75c81e58360da491442e2776272f4c009a2/config.py > $MANAGER_DIR/config.py

chown -R dc-agent:dc-agent $MANAGER_DIR

touch /etc/supervisord.d/agent.conf
chown dc-agent:dc-agent /etc/supervisord.d/agent.conf
cat > /etc/supervisord.d/manager.conf << EOF
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
pip install -r requirement.txt


cd $BASE_DIR
# Setup Agent
git clone https://github.com/xxr3376/Distribute-Crawler-Agent $AGENT_DIR
curl https://gist.githubusercontent.com/xxr3376/5efefe30b01aff86774b/raw/8cb61e2e71ec3c525352d2332034ea3f03339150/const.py > $AGENT_DIR/const.py

chown -R dc-agent:dc-agent $AGENT_DIR

cd $AGENT_DIR
virtualenv .env
. .env/bin/activate
yum install libxslt-devel -y
pip install -r requirement.txt

supervisorctl reload
