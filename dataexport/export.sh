#!/bin/sh
java -Xms512M -Xmx1500M -XX:PermSize=256m -XX:MaxPermSize=1024m -classpath /public/app/dataexport-1.0.0-all.jar dataexport.dataexport.ExportTwitterData >twitter.log &
