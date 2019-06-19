#!/bin/bash

while true; do
    read -p "Do you wish to uninstall Redis Enterprise from your system?" yn
    case $yn in
        [Yy]* ) sudo docker kill re-node1;sudo docker rm re-node1;sudo docker kill re-node2;sudo docker rm re-node2;sudo docker kill re-node3;sudo docker rm re-node3; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
