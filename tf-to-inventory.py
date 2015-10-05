#!/usr/bin/env python
import json

hosts = {}
groups = {}

with open("terraform.tfstate") as fp:
    state = json.load(fp)

for module in state["modules"]:
    for key, resource in module["resources"].iteritems():
        if resource["type"] == "aws_instance":
            resource_type, group_name, index = key.split(".")

            index = int(index)
            attributes = resource["primary"]["attributes"]
            name = attributes["public_dns"]

            if resource_type == "aws_instance":
                hosts[name] = attributes["public_dns"]
                groups.setdefault(group_name, {})[name] = {
                    "zoo_id": index + 1
                }

with open("hosts", "w") as fp:
    for host, ip_address in hosts.iteritems():
        fp.write("{} ansible_ssh_host={} ansible_ssh_user=centos\n".format(host, ip_address))

    for group, hosts in groups.iteritems():
        fp.write("\n")
        fp.write("[{}]\n".format(group))
        for host, variables in hosts.iteritems():
            fp.write(host)
            if group == "control_nodes":
                for k, v in variables.iteritems():
                    fp.write(" {}={}".format(k, v))

            fp.write("\n")