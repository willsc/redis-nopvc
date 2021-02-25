# redis-nopvc
```
k get pods -n redis
NAME              READY   STATUS    RESTARTS   AGE
redis-cluster-0   1/1     Running   7          14m
redis-cluster-1   1/1     Running   0          2m54s
redis-cluster-2   1/1     Running   0          2m27s
redis-cluster-3   1/1     Running   0          2m5s
redis-cluster-4   1/1     Running   0          103s
redis-cluster-5   1/1     Running   0          82s

❯ kubectl get pods -n redis -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379' | sed 's/637910/6379 10/g'
10.104.2.25:6379 10.104.0.25:6379 10.104.1.28:6379 10.104.0.26:6379 10.104.1.29:6379 10.104.2.26:6379%



❯ kubectl get pods -n redis -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379' | sed 's/637910/6379 10/g'
❯ kubectl exec -it -n redis redis-cluster-0 -- redis-cli cluster info
cluster_state:fail
cluster_slots_assigned:0
cluster_slots_ok:0
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:1
cluster_size:0
cluster_current_epoch:0
cluster_my_epoch:0
cluster_stats_messages_sent:0
cluster_stats_messages_received:0


kubectl exec -it -n redis  redis-cluster-0 -- redis-cli cluster info
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:1
cluster_stats_messages_ping_sent:11927
cluster_stats_messages_pong_sent:11882
cluster_stats_messages_sent:23809
cluster_stats_messages_ping_received:11877
cluster_stats_messages_pong_received:11927
cluster_stats_messages_meet_received:5
cluster_stats_messages_received:23809



❯ kubectl get pods -n redis  -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379' | sed 's/637910/6379 10/g'
10.104.2.25:6379 10.104.0.25:6379 10.104.1.28:6379 10.104.0.26:6379 10.104.1.29:6379 10.104.2.26:6379%


❯ kubectl exec -it -n redis redis-cluster-0 -- redis-cli --cluster create 10.104.2.25:6379 10.104.0.25:6379 10.104.1.28:6379 10.104.0.26:6379 10.104.1.29:6379 10.104.2.26:6379 --cluster-replicas 1
>>> Performing hash slots allocation on 6 nodes...
Master[0] -> Slots 0 - 5460
Master[1] -> Slots 5461 - 10922
Master[2] -> Slots 10923 - 16383
Adding replica 10.104.1.29:6379 to 10.104.2.25:6379
Adding replica 10.104.2.26:6379 to 10.104.0.25:6379
Adding replica 10.104.0.26:6379 to 10.104.1.28:6379
M: 718a1005498485a22906ff10089455e84ac078d3 10.104.2.25:6379
   slots:[0-5460] (5461 slots) master
M: 56bca772a270fcd5481219e746c99bce4440e297 10.104.0.25:6379
   slots:[5461-10922] (5462 slots) master
M: 52ed0636c2242a89725720e67d2c558763c689c6 10.104.1.28:6379
   slots:[10923-16383] (5461 slots) master
S: b4b9480cdcb38d937f35a2153e730185e0e5936f 10.104.0.26:6379
   replicates 52ed0636c2242a89725720e67d2c558763c689c6
S: ba354d46d12d213de0b8d598a9954c13d53944ae 10.104.1.29:6379
   replicates 718a1005498485a22906ff10089455e84ac078d3
S: 736c3175f3afdfc0f97c351c4550877c7ad4958b 10.104.2.26:6379
   replicates 56bca772a270fcd5481219e746c99bce4440e297
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join
.
>>> Performing Cluster Check (using node 10.104.2.25:6379)
M: 718a1005498485a22906ff10089455e84ac078d3 10.104.2.25:6379
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
M: 56bca772a270fcd5481219e746c99bce4440e297 10.104.0.25:6379
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
S: b4b9480cdcb38d937f35a2153e730185e0e5936f 10.104.0.26:6379
   slots: (0 slots) slave
   replicates 52ed0636c2242a89725720e67d2c558763c689c6
S: ba354d46d12d213de0b8d598a9954c13d53944ae 10.104.1.29:6379
   slots: (0 slots) slave
   replicates 718a1005498485a22906ff10089455e84ac078d3
M: 52ed0636c2242a89725720e67d2c558763c689c6 10.104.1.28:6379
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
S: 736c3175f3afdfc0f97c351c4550877c7ad4958b 10.104.2.26:6379
   slots: (0 slots) slave
   replicates 56bca772a270fcd5481219e746c99bce4440e297
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
❯ kubectl exec -it -n redis  redis-cluster-0 -- redis-cli cluster info
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:1
cluster_stats_messages_ping_sent:234
cluster_stats_messages_pong_sent:228
cluster_stats_messages_sent:462
cluster_stats_messages_ping_received:223
cluster_stats_messages_pong_received:234
cluster_stats_messages_meet_received:5
cluster_stats_messages_received:462
❯ ls
Dockerfile       redis.conf       service.yaml     statefulset.yaml
❯
❯
❯ k logs -n redis redis-cluster-0
1:C 25 Feb 2021 22:52:14.360 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
1:C 25 Feb 2021 22:52:14.360 # Redis version=5.0.7, bits=64, commit=00000000, modified=0, pid=1, just started
1:C 25 Feb 2021 22:52:14.360 # Configuration loaded
1:M 25 Feb 2021 22:52:14.362 * No cluster configuration found, I'm 718a1005498485a22906ff10089455e84ac078d3
1:M 25 Feb 2021 22:52:14.367 * Running mode=cluster, port=6379.
1:M 25 Feb 2021 22:52:14.367 # Server initialized
1:M 25 Feb 2021 22:52:14.367 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
1:M 25 Feb 2021 22:52:14.367 * Ready to accept connections
1:M 25 Feb 2021 23:02:28.677 # configEpoch set to 1 via CLUSTER SET-CONFIG-EPOCH
1:M 25 Feb 2021 23:02:28.727 # IP address for this node updated to 10.104.2.25
1:M 25 Feb 2021 23:02:29.661 # Cluster state changed: ok
1:M 25 Feb 2021 23:02:30.881 * Replica 10.104.1.29:6379 asks for synchronization
1:M 25 Feb 2021 23:02:30.881 * Partial resynchronization not accepted: Replication ID mismatch (Replica asked for '05691d0c3258f803185333a5c8c6a3b976620c28', my replication IDs are 'b3e730159f6e2781d37dda62ace7521e6a758717' and '0000000000000000000000000000000000000000')
1:M 25 Feb 2021 23:02:30.881 * Starting BGSAVE for SYNC with target: disk
1:M 25 Feb 2021 23:02:30.881 * Background saving started by pid 1947
1947:C 25 Feb 2021 23:02:30.885 * DB saved on disk
1947:C 25 Feb 2021 23:02:30.886 * RDB: 0 MB of memory used by copy-on-write
1:M 25 Feb 2021 23:02:30.965 * Background saving terminated with success
1:M 25 Feb 2021 23:02:30.966 * Synchronization with replica 10.104.1.29:6379 succeeded
```
