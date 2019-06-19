#!/bin/bash

./cleanup.sh

while true; do
    read -p "Do you wish to remove the Redis Enterprise docker image from your system?" yn
    case $yn in
        [Yy]* ) sudo docker images redislabs/redis; echo "Removing `sudo docker images -a | grep "redislabs" | awk '{print $3}'`.."; sudo docker images -a | grep "redislabs" | awk '{print $3}' | xargs docker rmi; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
