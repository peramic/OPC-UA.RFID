#!/usr/bin/env sh

. /etc/profile

LOCK=/var/lock/opc-ua.lock
ROOT=$(dirname $(realpath $0))

cd $ROOT

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:lib

if [ ! -d /var/log/opc-ua ]; then
  mkdir /var/log/opc-ua
fi

init() {
  while [ -f $LOCK ]; do
    ./Server > /dev/null 2>&1
  done
}

quit() {
  rm $LOCK
  killall Server
}

touch $LOCK
trap quit CONT
init &

kill -STOP $$

wait $!