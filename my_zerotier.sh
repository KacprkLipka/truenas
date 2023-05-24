#!bin/sh
# Kacper Lipka 2023
# my-zerotier

ZEROTIER=zerotier_id
API_TOKEN=api_token
API_TOKEN=$(cat $API_TOKEN)
HOST=TrueNAS
TOKEN=/var/lib/zerotier-one/authtoken.secret

Install_script_secure() {
    curl -sL 'https://raw.githubusercontent.com/zerotier \
    /ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg -v --import
    if z=$(curl -sL 'https://install.zerotier.com/' | gpg); then echo "$z" | bash -v; fi
}

Get_MyId() { # Set MEMBER
    MEMBER=$(zerotier-cli info)
    MEMBER=${MEMBER#200 info }
    MEMBER=${MEMBER%% *}
}
set -xe

# install
Install_script_secure
zerotier-cli status
zerotier-cli listnetworks

# config
chmod go+r $TOKEN # Używanie bez sudo
zerotier-cli join $ZEROTIER
Get_MyId

curl -v POST "https://my.zerotier.com/api/network/$ZEROTIER/member/$MEMBER" \
    -H "Content-Type: application/json" \
    -H "Authorization: bearer $API_TOKEN" \
    -d '{"name": "'$HOST'", "config": {"authorized": true} }'

zerotier-cli status
zerotier-cli listnetworks

exit
