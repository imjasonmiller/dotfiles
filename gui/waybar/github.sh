#!/bin/bash

token=`cat ${HOME}/.config/github/notifications.token`
json=`curl -u imjasonmiller:${token} https://api.github.com/notifications`
notifications=`echo ${json} | jq '. | length'`

if [[ "$notifications" != "0" ]]; then
    echo '{"text":'$notifications',"tooltip":"$tooltip","class":"$class"}'
fi

