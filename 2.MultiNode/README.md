opscenter on node0, 3 blanks on node1-3
explain how use opscenter to install


add note pointing to ./parallel.sh
name: base

go thru:

installs, point to docs
cassandra tar

dsc apt-get
opscenter + agent

simple walk-thru with
- nodetool status
- cqlsh
  create keyspace
  create table
  insert data
  select data

point to walk-thru docs

mention adjust total memory based on size of host machine


after install, node0 has opscenter, node1-3 have just java

connect with Opscenter running on node0
browse to: http://node0:8888/

click Create Brand New Cluster

DSE:
Name: you pick
Package: DataStax Enterprise 4.0.3

DataStax credentials: from reg email

Nodes:
node1
node2
node3
Solr nodes: 0
Hadoop Nodes: 1
Node credentials:
user: vagrant
password: vagrant
No private key needed
mention advanced options
click Build Cluster
click Accept Fingerprints
watch Build in Progress page

Community
Name:
Package: DataStax Community 2.0.7
resume above


vagrant ssh node1

like 1.base but cqlsh node1, then create keyspace rf=3

CREATE KEYSPACE usertest WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 2 };
like 1.base, write several values
turn off one node - reads still work
turn off 2 nodes - should fail


play with cassandra-stress

cassandra-stress -d node1 -n 200000
cassandra-stress -d node3 -n 200000 -o read

run without the -n to do 1M by default

vagrant destroy /node[0-3]/ -f

clean shutting down
for i in {0..3}; do vagrant ssh node$i -c 'sudo shutdown -h now'; done
