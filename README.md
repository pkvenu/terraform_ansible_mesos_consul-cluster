# terraform_ansible_mesos_consul-cluster
Create a AWS HA Cluster with ansible, terraform , mesos, zk, consul, marathon , chronos and docker in CentOS 7

To Launch this cluster:

**Pre Launch: Install terraform and ansible**

1. Create a terraform.tfvars file with the following attributes and save. 
```
access_key = ""
secret_key = ""
key_path = ""
key_name = ""
```

2. call `terraform apply` to launch the cluster .   
3. `python tf-to-inventory.py` will creare a host file for ansible to use. 
4. `ansible-playbook -i hosts init.yml --private-key privatekeyfile`

This will launch your cluster in AWS EC2. You could then browse the mesos, marathon, chronos url in the following port 
```
https://ec2-xx-xxx-xxx-xxx.us-west-1.compute.amazonaws.com:5050
https://ec2-xx-xxx-xxx-xxx.us-west-1.compute.amazonaws.com:8080
```

For viewing the consul url you would have to create a tunnel to one of the masters: 
```
ssh -i pathtoprivatekey -N -f -L 8500:localhost:8500 centos@ec2-xx-xxx-xxx-xxx.us-west-1.compute.amazonaws.com
```
Once the tunnel is created you could view the consul ui from your laptop at 
[localhost](http://localhost:8500)

You can now test adding a docker container to marathon using the information provided below. 
[launch-docker-container-on-mesosphere](http://panda.mesosphere.io.s3-website-us-east-1.amazonaws.com/docs/tutorials/launch-docker-container-on-mesosphere/)

You can now check the status of the container from the consul UI. 

##Component Installed:##
** Control Nodes ** ( Default 3 )
* Mesos Master
* Zookeeper
* Consul Server
* Consul UI
* Marathon 
* Chronos

** Worker Nodes ** (Default 2)
* Mesos Slave
* Consul agent (client)
* Docker engine 

## TO DO ##
1. Add ngnix or haproxy for load balancing 
2. Add consul template to update load balancers
3. Add ELK stack for docker aggregation logs 
4. Add security to harden the system 


 











