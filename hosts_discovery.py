#!/usr/bin/env python

import nmap
import os
import sys

envarray=[]
hostarray=[]
todosarray=[]
procpath="/tmp/hostdiscovery"

def todos(host):
        todosarray.append(host)

def proc(host):
        hostentry = host + "\n"
        separator = "-"
        sequence = (env, host)
        entry = separator.join(sequence)
        hostarray.append(entry)

def write(path):
        file = open(procpath, 'w+')
        for environment in envarray:
                file.write("[" + environment + "]\n")
                for hostentry in hostarray:
                        if hostentry.find(environment) == 0:
                                drop,ip = hostentry.split("-", 1);
                                file.write(ip + "\n")
                file.write("\n")
        file.close()

nm = nmap.PortScanner()
test = sys.argv[1]
nm.scan(hosts=test, arguments='-sn')

for host in nm.all_hosts():
        state = nm[host].state()
        if state in 'up':
                hostname = nm[host].hostname()
                if hostname:
                        env,rest = hostname.split("-", 1);
                        if env not in envarray:
                                envarray.append(env)
                        proc(host)
                        write(procpath)
                else:
                        todos(host)

print("Those hosts have no discoverable names: ")
for todolist in todosarray:
        print(todolist)
print("Please add them manually if you'd like to add them to '/etc/ansible/hosts'\n")
