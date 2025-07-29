#!/bin/sh

DOMAIN="mikkelsej"
TOKEN="0"

curl -s "https://www.duckdns.org/update?domains=$DOMAIN&token=$TOKEN&ip="
