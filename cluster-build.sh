#!/bin/bash
PORT=6379


foobar=`kubectl get pods -n redis -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379' | sed 's/637910/6379 10/g' | sed 's/:6379//g'|sed s'/%//g' |sed 's/ /,/g'`
IFS=',' read -r -a array <<< "$foobar"

for x in "${array[@]}"
do 
  echo   "$x"

done

echo "\n\n"
echo "${array[0]}"

for i in {0..5459}; do  kubectl exec -it -n redis  redis-cluster-0 -- redis-cli -h ${array[0]} -p 6379 CLUSTER ADDSLOTS $i > /dev/null; done
for i in {5460..10919}; do  kubectl exec -it -n redis  redis-cluster-0 -- redis-cli -h ${array[1]}  -p 6379 CLUSTER ADDSLOTS $i > /dev/null; done
for i in {10920..16383}; do  kubectl exec -it -n redis  redis-cluster-0 -- redis-cli -h ${array[2]} -p 6379 CLUSTER ADDSLOTS $i > /dev/null; done


for y in 1 2 3 4 5
do 
 kubectl exec -it -n redis  redis-cluster-0 -- redis-cli -h ${array[0]} CLUSTER MEET ${array[y]} $PORT
done

#redis-cli -h ${array[0]} CLUSTER MEET ${array[2]} $PORT
#redis-cli -h ${array[0]} CLUSTER MEET ${array[3]} $PORT
#redis-cli -h ${array[0]} CLUSTER MEET ${array[4]} $PORT
#redis-cli -h ${array[0]} CLUSTER MEET ${array[5]} $PORT

kubectl exec -it -n redis  redis-cluster-0 -- redis-cli -c -p 6379 cluster nodes | awk '{print $1}' >> /tmp/temp
nodes=`awk '{printf("%s,",$1)}' temp`

IFS=',' read -r -a nodearray <<< "$nodes"

kubectl exec -it -n redis  redis-cluster-0 -- redis-cli -h ${array[4]} -p 6379 cluster replicate ${nodearray[0]}
kubectl exec -it -n redis  redis-cluster-0 -- redis-cli -h ${array[5]} -p 6379 cluster replicate ${nodearray[1]}
kubectl exec -it -n redis  redis-cluster-0 -- redis-cli -h ${array[3]} -p 6379 cluster replicate ${nodearray[2]}

