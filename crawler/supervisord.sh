#!/bin/sh
#
# /etc/rc.d/init.d/supervisord
#
# Supervisor is a client/server system that
# allows its users to monitor and control a
# number of processes on UNIX-like operating
# systems.
#
# chkconfig: - 64 36
# description: Supervisor Server
# processname: supervisord

# Source init functions
. /etc/rc.d/init.d/functions

prog="supervisord"

prefix="/usr/local/"
exec_prefix="${prefix}"
prog_bin="${exec_prefix}/bin/supervisord"
PIDFILE="/var/run/$prog.pid"

start()
{
        echo -n $"Starting $prog: "
        daemon $prog_bin --pidfile $PIDFILE
        retval=$?
        echo
        [ $retval -eq 0 ] && [ -f $PIDFILE ]
        return $retval
}

stop()
{
        echo -n $"Shutting down $prog: "
        [ -f $PIDFILE ] && killproc $prog || success $"$prog shutdown"
        echo
}

case "$1" in

  start)
    start
  ;;

  stop)
    stop
  ;;

  status)
        status $prog
  ;;

  restart)
    stop
    start
  ;;

  *)
    echo "Usage: $0 {start|stop|restart|status}"
  ;;

esac
