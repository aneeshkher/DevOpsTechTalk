# CSC DevOps Tech Talk - Puppet  

## Introduction to puppet
Puppet is an open source configuration management tool. On a high level, it consists of one `puppet master` and many `puppet agent`s. The agents are authorized at the puppet using SSL certification. Once the puppet signs the agent's request, the agent receives the configuration from the master at periodic intervals. 

## Setup  
For this demonstration, we used three machines provisioned on AWS. One machine was the master (puppet) and the others were the agents. We configured `puppetmaster` on the master and `puppet` on the agents. Here are the hostnames of the machines.  
* Master - `puppet`
* Agent1 - `agent1`
* Agent2 - `agent2`

All the machines are run using root user. For convenience, we have added the entries of the agents in the master's `/etc/hosts` file and vice versa. This ensures communication.  

## Installation  
#### Master installation  
* Provision a Linux Ubuntu image.
* Log in as `root`.
* Download the `.deb` file from [this](https://apt.puppetlabs.com/?_ga=1.116435790.958851889.1447184049) location.
* Run the command `dpkg -i <package_name>`. In our case, this command was

	`dpkg -i puppetlabs-release-pc1-trusty.deb`

* Run the command `apt-get update`.
* Install the puppet master by running the command `apt-get install puppetmaster`.

To summarize, follow these commands for installing puppet on the master machine.
```
sudo su
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
dpkg -i puppetlabs-release-pc1-trusty.deb
apt-get update
apt-get install puppetmaster
```



