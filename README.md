# auto_deploy
auto_deploy

Install

git clone https://github.com/crasshopper/auto_deploy.git


Run



use scp 

./auto_set_sev.sh  -a iplist.txt -t scp  -s /data/go/ -d  /data/go

use pip  

./auto_set_sev.sh  -a iplist.txt -t pip -p pyopenssl

use yum 

./auto_set_sev.sh  -a iplist.txt -t yum -p expect




