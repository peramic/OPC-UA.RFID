#!/bin/sh

. /etc/profile

NAME=$(basename $(realpath $0))

PID=/var/run/${NAME}.pid
DAEMON=/opt/havis.opc-ua/Server.sh

do_start()
{
  start-stop-daemon -S -m -p $PID -b -x $DAEMON -- $ARGS
}

do_stop()
{
  start-stop-daemon -K -s CONT -p $PID
}

case "$1" in
  start)
    echo -n "Starting $NAME: "
    do_start
    ;;
  stop)
    echo -n "Stopping $NAME: "
    do_stop
    ;;
  status)
    read PID < $PID
    test -d /proc/$PID
    exit $?
    ;;
  restart)
    echo -n "Restarting $NAME: "
    do_stop
    sleep 1
    do_start
    ;;
  *)
    echo "Usage: $NAME {start|stop|status|restart}"
    exit 1
    ;;
esac

exit 0