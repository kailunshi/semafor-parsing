#!bin/bash
USER=""
if id -u "vagrant" > /dev/null 2>&1; then
  USER="vagrant"
elif id -u "ubuntu" > /dev/null 2>&1; then
  USER="ubuntu"
else
  echo "No 'vagrant' or 'ubuntu' users found, stoping"
  exit 1
fi

export PYTHONPATH=/home/$(echo $USER)/semafor/app:$PYTHONPATH

/home/$(echo $USER)/venv/bin/celery worker --app=semafor.master.worker.celery -l info -Q semafor.master
