## A 3 node Redis Enterprise cluster setup in Docker containers (For Development purpose only)

### Prerequisites

Docker compatible OS and Docker installed.
  - (I have it setup on my MacBook Pro but you can run it on any OS with Docker as long as you tweak the script based on runtime requirements.)
Update Docker resources with 4 CPUs and 6-10GB RAM as shown here, <a href="https://github.com/viragtripathi/redis-enterprise-docker/blob/master/Screen%20Shot%202019-06-19%20at%2011.55.53%20AM.png">Docker Preferences...</a>

## Steps

1. Execute create_redis_enterprise_3_node_cluster.sh to create a 3 node(server) Redis Enterprise cluster and a database.

2. Execute create_multimodel_db.sh to create a multi-model database. Currently, you can create <a href="https://redislabs.com/multi-model/search/">RediSearch (ft)</a>, <a href="https://redislabs.com/multi-model/document-json/">ReJSON (rejson)</a>, <a href="https://redislabs.com/blog/rebloom-bloom-filter-datatype-redis/">RedisBloom (rebloom)</a>,  <a href="https://redislabs.com/redis-enterprise/redis-modules/redis-enterprise-modules/redisgraph/">RedisGraph (graph)</a> and <a href="https://redislabs.com/blog/redistimeseries-ga-making-4th-dimension-truly-immersive/">RedisTimeSeries (TS)</a> module enabled databases with this script. [OPTIONAL]

3. Execute cleanup.sh to kill and remove the 3 docker containers. [OPTIONAL]

4. Execute destroy.sh to remove the containers and also delete the <a href="https://hub.docker.com/r/redislabs/redis">redislabs/redis</a> images. [OPTIONAL]

## Additional info

* <a href="https://hub.docker.com/r/redislabs/redis">Redis Labs Docker image</a>

* <a href="https://oss.redislabs.com/redisearch/index.html">RediSearch Documentation</a>

* <a href="https://oss.redislabs.com/redisjson/">ReJSON Documentation</a>

* <a href="https://oss.redislabs.com/redisbloom/">RedisBloom Documentation</a>

* <a href="https://oss.redislabs.com/redisgraph/">RedisGraph Documentation</a>

* <a href="https://oss.redislabs.com/redistimeseries/">RedisTimeSeries Documentation</a>
