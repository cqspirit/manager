#!/bin/bash
check_os_release()
{
  while true
  do
    os_release=$(grep "Red Hat Enterprise Linux Server release" /etc/issue 2>/dev/null)
    os_release_2=$(grep "Red Hat Enterprise Linux Server release" /etc/redhat-release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "release 5" >/dev/null 2>&1
      then
        os_release=redhat5
        echo "$os_release"
      elif echo "$os_release"|grep "release 6" >/dev/null 2>&1
      then
        os_release=redhat6
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    os_release=$(grep "CentOS release" /etc/issue 2>/dev/null)
    os_release_2=$(grep "CentOS release" /etc/*release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "release 5" >/dev/null 2>&1
      then
        os_release=centos5
        echo "$os_release"
      elif echo "$os_release"|grep "release 6" >/dev/null 2>&1
      then
        os_release=centos6
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    os_release=$(grep -i "ubuntu" /etc/issue 2>/dev/null)
    os_release_2=$(grep -i "ubuntu" /etc/lsb-release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "Ubuntu 10" >/dev/null 2>&1
      then
        os_release=ubuntu10
        echo "$os_release"
      elif echo "$os_release"|grep "Ubuntu 12" >/dev/null 2>&1
      then
        os_release=ubuntu12
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    os_release=$(grep -i "debian" /etc/issue 2>/dev/null)
    os_release_2=$(grep -i "debian" /proc/version 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "Linux 6" >/dev/null 2>&1
      then
        os_release=debian6
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    break
    done
}

modify_rhel5_yum()
{
  rpm --import http://mirrors.163.com/centos/RPM-GPG-KEY-CentOS-5
  cd /etc/yum.repos.d/
  wget http://mirrors.163.com/.help/CentOS-Base-163.repo -O CentOS-Base-163.repo
  sed -i '/mirrorlist/d' CentOS-Base-163.repo
  sed -i 's/\$releasever/5/' CentOS-Base-163.repo
  yum clean metadata
  yum makecache
  cd ~
}

modify_rhel6_yum()
{
  rpm --import http://mirrors.163.com/centos/RPM-GPG-KEY-CentOS-6
  cd /etc/yum.repos.d/
  echo -e "\033wget http://mirrors.163.com/.help/CentOS-Base-163.repo -O CentOS-Base-163.repo.\n\033[0m"
  wget http://mirrors.163.com/.help/CentOS-Base-163.repo -O CentOS-Base-163.repo
  sed -i '/mirrorlist/d' CentOS-Base-163.repo
  sed -i '/\[addons\]/,/^$/d' CentOS-Base-163.repo
  sed -i 's/\$releasever/6/' CentOS-Base-163.repo
  sed -i 's/RPM-GPG-KEY-CentOS-5/RPM-GPG-KEY-CentOS-6/' CentOS-Base-163.repo
  yum clean metadata
  yum makecache
  cd ~
}

install_php() {
    # install gcc
    yum install gcc -y
    # install zlib
    yum install zlib -y
    # install libxml2
    yum install libxml2-devel -y
    # install openssl
    yum install openssl-devel -y
    # install curl
    yum install curl-devel -y
    # install libjpeg
    yum install libjpeg-devel -y
    # install libpng
    yum install libpng-devel -y
    # install libxpm
    yum install libXpm-devel -y
    yum install freetype-devel -y
    yum install libc-client-devel -y
    yum install libmcrypt-devel -y
    yum install mhash-devel -y
    yum install mysql-devel -y
    yum install pspell-devel -y
    yum install libtidy libtidy-devel -y
    yum install expat-devel -y
    yum install libxslt-devel -y
    yum install mysql mysql-devel -y
    ln -s /usr/lib64/mysql/libmysqlclient.so.15.0.0 /usr/lib/libmysqlclient.so
    
    # instlal 
    # download PHP source
    wget 'http://cn2.php.net/get/php-5.3.28.tar.bz2/from/this/mirror'
    tar jxvf php-5.3.28.tar.bz2
    cd php-5.3.28
    ./configure --prefix=/usr/local/php5.3 --with-config-file-path=/usr/local/php5.3/etc --with-mysql --with-mcrypt --with-zlib --with-curl
    make && make install
    cp php.ini-production /usr/local/php5.3/etc/php.ini
    cd ..
}

install_libmemcached() {
    yum install gcc44-c++ gcc44 libstdc++44-devel -y
    yum install cyrus-sasl-plain -y
    yum install cyrus-sasl-lib -y
    yum install cyrus-sasl-devel -y
    yum install cyrus-sasl -y
    yum install autoconf -y
    wget 'https://launchpad.net/libmemcached/1.0/1.0.16/+download/libmemcached-1.0.16.tar.gz'
    tar xvzf libmemcached-1.0.16.tar.gz
    cd libmemcached-1.0.16
    ./configure --prefix=/usr/local/libmemcached --enable-sasl
    make && make install
    cd ..
}

install_php_memcached() {
    wget 'http://pecl.php.net/get/memcached-2.1.0.tgz'
    tar xvzf memcached-2.1.0.tgz
    cd memcached-2.1.0
    /usr/local/php5.3/bin/phpize
    ./configure --with-php-config=/usr/local/php5.3/bin/php-config --with-libmemcached-dir=/usr/local/libmemcached/ --enable-memcached-sasl
    make && make install
    mod_line=`sed -nr '/Module Settings/=' /usr/local/php5.3/etc/php.ini`
    mod_line_next=$[$mod_line + 1]
    sed -inr "${mod_line_next}a\extension_dir=/usr/local/php5.3/lib/php/extensions/no-debug-non-zts-20090626/" /usr/local/php5.3/etc/php.ini
    mod_line_next=$[$mod_line_next + 1]
    sed -inr "${mod_line_next}a\extension=memcached.so" /usr/local/php5.3/etc/php.ini
    cd ../
}

####################Start###################
#check lock file ,one time only let the script run one time
LOCKfile=/tmp/.$(basename $0)
if [ -f "$LOCKfile" ]
then
  echo -e "\033[1;40;31mThe script is already exist,please next time to run this script.\n\033[0m"
  exit
else
  echo -e "\033[40;32mStep 1.No lock file,begin to create lock file and continue.\n\033[40;37m"
  touch $LOCKfile
fi

#check user
if [ $(id -u) != "0" ]
then
  echo -e "\033[1;40;31mError: You must be root to run this script, please use root to install this script.\n\033[0m"
  rm -rf $LOCKfile
  exit 1
fi
echo -e "\033[40;32mStep 2.Begen to check the OS issue.\n\033[40;37m"
os_release=$(check_os_release)
if [ "X$os_release" == "X" ]
then
  echo -e "\033[1;40;31mThe OS does not identify,So this script is not executede.\n\033[0m"
  rm -rf $LOCKfile
  exit 0
else
  echo -e "\033[40;32mThis OS is $os_release.\n\033[40;37m"
fi

echo -e "\033[40;32mStep 3.Begen to modify the source configration file and update.\n\033[40;37m"
case "$os_release" in
redhat5|centos5)
  #modify_rhel5_yum
  install_php
  install_libmemcached
  install_php_memcached
  ;;
redhat6|centos6)
  #modify_rhel6_yum
  install_php
  install_libmemcached
  install_php_memcached
  ;;
esac

echo -e "\033[40;32mSuccess,exit now!\n\033[40;37m"
echo -e "\033[40;32mPHP Binary Path: /usr/local/php5.3/bin/php!\n\033[40;37m"
echo -e "\033[40;32mPHP Config File  Path: /usr/local/php5.3/etc/php.ini!\n\033[40;37m"
rm -rf $LOCKfile

