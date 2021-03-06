semafor-parsing
===============

Parse semafor output at scale using AWS, celery, saltstack and more.

## Installation

You only need to manually configure the salt-master that at the same time will have RabbitMQ and a
celery worker waiting for queries. There are a few options to do this.

### Option 1: Dirt and easy

Requirements: vagrant

1. Clone the repo to you local computer and cd to the location
2. `cd master`
3. 'vagrant up —provider aws'

### Option 2: Not that easy

Requirements: None

1. Create instance
2. Install saltstack using: `wget -O - http://bootstrap.saltstack.org | sudo sh`
3. Clone repo to the instance: `git clone https://github.com/danielfrg/semafor-parsing semafor-parsing`
4. Copy salt states to /srv `cd master/salt/roots` and `cp -r * /srv`
5. Provision master using salt `sudo salt-call —local state.highstate` (This takes some time)
6. Run salt-master `service salt-master start`

### Option 3: PRO

If you have another salt box as a master you can create a minion and provision that minion as this
project master using: `salt-call 'MINION_IP' state.sls semafor-master`

## Running

Find the IP of the master you created and ssh to it (if using option 1 you can do `vagrant ssh`)

Set the settings: `cd semafor/master/` edit `settings.py or `local_settings.py`, you need:
```
S3_PATH = 'WHERE THE SEMAFOR FILES WILL BE UPLOADED'
AWS_ACCESS_ID = 'AWS ACCOUNT KEY'
AWS_SECRET_KEY = 'AAWS ACCOUNT SECRET'
READABILITY_TOKEN = 'READABILITY API TOKEN'
SALT_MASTER_PUBLIC_ADDRESS = 'THE IP OF THE MASTER'
LUIGI_CENTRAL_SCHEDULER = 'THE IP OF THE LUIGI SCHEDULER, CAN BE THE SAME SALT MASTER'
```

Start the celery worker, a helper script is provided on: `semafor/master/start_worker.sh`. Note that you need to run this
script with superuser priviliges because is going to call some salt functions.

Call the the celery task, a helper script is provided on: `semafor/master/test.py`

Optional: Start the luigi daemon to see the UI:
`/home/ubunut/venv/bin/luigid`. Add `&` or `--background` to run in the background. The luigi UI can be found in LUIGI_CENTRAL_SCHEDULER:8082



