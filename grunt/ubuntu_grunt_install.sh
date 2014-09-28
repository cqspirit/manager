#!/bin/bash
#https://kalamuna.atlassian.net/wiki/display/KALA/Install+Grunt+on+Ubuntu
#1.install
sudo apt-get install software-properties-common
sudo apt-get install python-software-properties
sudo apt-add-repository ppa:chris-lea/node.js
sudo apt-get update
#2.install nodejs
sudo apt-get install nodejs
sudo npm -g install grunt
sudo apt-get install npm
#3.install requirejs
sudo npm install grunt-contrib-requirejs
#4.change to your project folder and create a file called package.json
sudo npm install
sudo npm install -g grunt-cli
#5.grunt your project
grunt dev
grunt dist
