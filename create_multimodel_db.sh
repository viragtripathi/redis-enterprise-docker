#/bin/bash

echo -n "Enter the name of the module: "
read module
if [ $module == "graph" ] ||  [ $module == "ft" ] || [ $module == "rebloom" ] || [ $module == "rejson" ]; then
# Create a multi-model demo database
echo "Creating Redis Enterprise database with $module module "
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

ft_db_name="RedisSearch-db"
ft_module_args="PARTITIONS AUTO"
rejson_db_name="RedisJSON-db"
rejson_module_args=""
graph_db_name="RedisGraph-db"
graph_module_args=""
bf_db_name="RedisBloom-db"
bf_module_args=""
module_name=`sudo docker exec --user root -it re-node1 bash -c "grep -i $module /opt/module_list.txt | cut -d ' ' -f 2"`
uid=`sudo docker exec --user root -it re-node1 bash -c "grep -i $module /opt/module_list.txt | cut -d ' ' -f 3"`
semantic_version=`sudo docker exec --user root -it re-node1 bash -c "grep -i $module /opt/module_list.txt | cut -d ' ' -f 4"`
echo "module id: $uid"
echo "module name: $module_name"
echo "semantic_version: $semantic_version"
rm create_multimodeldb.sh

case $module in
ft)
   tee -a create_multimodeldb.sh <<EOF
curl -k -L -u REDemo@redislabs.com:redis123 --location-trusted -X POST https://localhost:9443/v1/bdbs -H "Content-type:application/json" -d '{"name": "'"$ft_db_name"'", "type":"redis", "memory_size":1073741824, "port":12005, "module_list": [{"module_args": "'"$ft_module_args"'", "module_id": "'"$uid"'", "module_name": "'"$module_name"'", "semantic_version": "'"$semantic_version"'"}]}'
EOF
   ;;
rejson)
   tee -a create_multimodeldb.sh <<EOF
curl -k -L -u REDemo@redislabs.com:redis123 --location-trusted -X POST https://localhost:9443/v1/bdbs -H "Content-type:application/json" -d '{"name": "'"$rejson_db_name"'", "type":"redis", "memory_size":1073741824, "port":12005, "module_list": [{"module_args": "'"$rejson_module_args"'", "module_id": "'"$uid"'", "module_name": "'"$module_name"'", "semantic_version": "'"$semantic_version"'"}]}'
EOF
   ;;
graph)
   tee -a create_multimodeldb.sh <<EOF
curl -k -L -u REDemo@redislabs.com:redis123 --location-trusted -X POST https://localhost:9443/v1/bdbs -H "Content-type:application/json" -d '{"name": "'"$graph_db_name"'", "type":"redis", "memory_size":1073741824, "port":12005, "module_list": [{"module_args": "'"$rejson_module_args"'", "module_id": "'"$uid"'", "module_name": "'"$module_name"'", "semantic_version": "'"$semantic_version"'"}]}'
EOF
   ;;
rebloom)
   tee -a create_multimodeldb.sh <<EOF
curl -k -L -u REDemo@redislabs.com:redis123 --location-trusted -X POST https://localhost:9443/v1/bdbs -H "Content-type:application/json" -d '{"name": "'"$bf_db_name"'", "type":"redis", "memory_size":1073741824, "port":12005, "module_list": [{"module_args": "'"$bf_module_args"'", "module_id": "'"$uid"'", "module_name": "'"$module_name"'", "semantic_version": "'"$semantic_version"'"}]}'
EOF
   ;;
*)
    echo "Unknown Module! Valid modules are: graph, ft, rejson and rebloom"
    ;;
esac

sed -e 's///g' create_multimodeldb.sh > temp_multimodeldb.sh
sudo docker cp temp_multimodeldb.sh re-node1:/opt/create_multimodeldb.sh
sudo docker exec --user root -it re-node1 bash -c "chmod 777 /opt/create_multimodeldb.sh"
sudo docker exec --user root -it re-node1 bash -c "/opt/create_multimodeldb.sh"
sudo docker exec --user root -it re-node1 bash -c "rm /opt/create_multimodeldb.sh"
sudo docker exec -it re-node1 bash -c "redis-cli -h redis-12005.cluster1.local -p 12005 PING"
sudo docker exec -it re-node1 bash -c "rladmin status databases"
sudo docker port re-node1 | grep 12005
else
echo "Unknown Module $module! Valid modules are: graph, ft, rejson and rebloom"
exit 0
fi
