
if [ "$#" -ne 3 ]; then
    echo "$0 <jirauser> <password> <usertoadd>"
    exit
fi

login=$1
pwd=$2
user=$3

data="{\"name\":\"$user\"}"


echo adding $user to group jbosstools-cat 

curl -u $login:$pwd -X POST -H "Content-Type: application/json" --data $data "https://issues.jboss.org/rest/api/2/group/user?groupname=JBoss%20Tools%20CAT"


