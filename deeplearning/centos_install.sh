#1.升级依赖软件包
yum groupinstall "Development tools"
yum install zilb zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel nose
#安装git
wget http://www.codemonkey.org.uk/projects/git-snapshots/git/git-latest.tar.gz
tar xzvf git-latest.tar.gz
cd git-*
autoconf
./configure
make
make install
#2.安装python2.7.3
mkdir -p  /opt/deeplearning
cd /opt/deeplearning
wget http://python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2
tar xf Python-2.7.3.tar.bz2
cd Python-2.7.3
./configure --prefix=/usr/   --enable-shared
make && make altinstall
ln -s /usr/bin/python2.7 /usr/bin/python27
#3.安装依赖软件
cd /opt/deeplearning
wget http://mirror.centos.org/centos/5/os/x86_64/CentOS/blas-3.0-38.el5.x86_64.rpm
rpm -ivh blas-3.0-38.el5.x86_64.rpm
wget ftp://rpmfind.net/linux/centos/5.10/os/x86_64/CentOS/blas-devel-3.0-38.el5.x86_64.rpm
rpm -ivh blas-devel-3.0-38.el5.x86_64.rpm
wget ftp://rpmfind.net/linux/centos/5.10/os/x86_64/CentOS/lapack-3.0-38.el5.x86_64.rpm
rpm -ivh  lapack-3.0-38.el5.x86_64.rpm
wget ftp://rpmfind.net/linux/centos/5.10/os/x86_64/CentOS/lapack-devel-3.0-38.el5.x86_64.rpm
rpm -ivh  lapack-devel-3.0-38.el5.x86_64.rpm
wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz#md5=13951be6711438073fbe50843e7f141f
tar zxvf setuptools-1.4.2.tar.gz 
cd setuptools-1.4.2
python27 setup.py install
cd /opt/deeplearning
wget http://pyyaml.org/download/pyyaml/PyYAML-3.10.tar.gz
tar zxvf PyYAML-3.10.tar.gz 
cd  PyYAML-3.10
python27 setup.py install
cd /opt/deeplearning
wget http://argparse.googlecode.com/files/argparse-1.2.1.tar.gz
tar zxvf argparse-1.2.1.tar.gz
cd argparse-1.2.1
python27 setup.py install
#4.安装numpy
cd /opt/deeplearning
wget http://jaist.dl.sourceforge.net/project/numpy/NumPy/1.8.0/numpy-1.8.0.tar.gz
tar zxvf numpy-1.8.0.tar.gz
cd numpy-1.8.0
python27 setup.py install
#5.、安装scipy
cd /opt/deeplearning
wget http://jaist.dl.sourceforge.net/project/scipy/scipy/0.13.1/scipy-0.13.1.tar.gz
tar zxvf scipy-0.13.1.tar.gz
cd scipy-0.13.1
python27 setup.py install
#6.安装theano
cd /opt/deeplearning
git clone git://github.com/Theano/Theano.git
cd Theano
python27 setup.py install
#7.安装pylearn2
cd /opt/deeplearning
git clone git://github.com/lisa-lab/pylearn2.git
cd pylearn2
python27 setup.py install
echo 'export PYLEARN2_DATA_PATH=/opt/deeplearning/pylearn2/data' >>/etc/profile
source /etc/profile
#8.测试
cd /opt/deeplearning/pylearn2/pylearn2/scripts
python27 train.py  tutorials/dbm_demo/rbm.yaml
