#/bin/bash
  
# Create a multi-model demo database
echo "Creating multi-model demo-db database..."
rm list_modules.sh
sudo docker exec --user root -it re-node1 bash -c "rm /opt/list_modules.sh"
tee -a list_modules.sh <<EOF
curl -s -k -L -u REDemo@redislabs.com:redis123 --location-trusted -H "Content-Type: application/json" -X GET https://localhost:9443/v1/modules | python -c 'import sys, json; modules = json.load(sys.stdin);
modulelist = open("./module_list.txt", "a")
for i in modules:
     lines = i["display_name"], " ", i["module_name"], " ", i["uid"], " ", i["semantic_version"], "\n"
     modulelist.writelines(lines)
modulelist.close()'
EOF
sudo docker exec --user root -it re-node1 bash -c "rm /opt/module_list.txt"
sudo docker cp list_modules.sh re-node1:/opt/list_modules.sh
sudo docker exec --user root -it re-node1 bash -c "chmod 777 /opt/list_modules.sh"
sudo docker exec --user root -it re-node1 bash -c "/opt/list_modules.sh"

ft_module_name=`sudo docker exec --user root -it re-node1 bash -c "grep -i ft /opt/module_list.txt | cut -d ' ' -f 2"`
ft_uid=`sudo docker exec --user root -it re-node1 bash -c "grep -i ft /opt/module_list.txt | cut -d ' ' -f 3"`
ft_semantic_version=`sudo docker exec --user root -it re-node1 bash -c "grep -i ft /opt/module_list.txt | cut -d ' ' -f 4"`
echo "module id: $ft_uid"
echo "module name: $ft_module_name"
echo "semantic_version: $ft_semantic_version"
rm create_multimodeldb.sh
tee -a create_multimodeldb.sh <<EOF
curl -k -L -u REDemo@redislabs.com:redis123 --location-trusted -X POST https://localhost:9443/v1/bdbs -H "Content-type:application/json" -d '{"name":"RedisSearch-db","type":"redis","memory_size":1073741824,"port":12005, "module_list": [{"module_args": "PARTITIONS AUTO", "module_id": "'"$ft_uid"'", "module_name": "'"$ft_module_name"'", "semantic_version": "'"$ft_semantic_version"'"}]}'
EOF

sudo docker exec --user root -it re-node1 bash -c "rm /opt/temp_multimodeldb.sh /opt/create_multimodeldb.sh"
sudo docker cp create_multimodeldb.sh re-node1:/opt/temp_multimodeldb.sh
sudo docker exec --user root -it re-node1 bash -c "sed -e 's/^M//g' /opt/temp_multimodeldb.sh > /opt/create_multimodeldb.sh"
sudo docker exec --user root -it re-node1 bash -c "chmod 777 /opt/create_multimodeldb.sh"
sudo docker exec --user root -it re-node1 bash -c "/opt/create_multimodeldb.sh"
sudo docker exec -it re-node1 bash -c "redis-cli -h redis-12005.cluster1.local -p 12005 PING"
sudo docker exec -it re-node1 bash -c "rladmin status databases"
sudo docker port re-node1 | grep 12005
