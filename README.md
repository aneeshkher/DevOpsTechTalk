# CSC DevOps Tech Talk - Puppet  

## Team members
1. Aneesh Kher (aakher)
2. Gauri Naik (gnaik2)
3. Krishna Teja Dinavahi (kdinava)
4. Arvind Telharkar (adtelhar)  

---

## Introduction to puppet
Puppet is an open source configuration management tool. On a high level, it consists of one `puppet master` and many `puppet agent`s. The agents are authorized at the puppet using SSL certification. Once the puppet signs the agent's request, the agent receives the configuration from the master at periodic intervals.  

---

#### Puppet architecture
Users describe system resources and their state in files called ‘Puppet manifests’. Configuration can be described in high-level terms without using OS specific commands such as yum, apt. ‘Puppet manifests’ are compiled and applied against the target system directly or distributed using the client server paradigm. 

##### Agent/Master architecture
Puppet uses an agent/master (client/server) architecture for configuring systems, using the Puppet agent and Puppet master applications. Agents never see the manifests that comprise their configuration. Instead, the Puppet master compiles the manifests down into a document called a catalog, and serves the catalog to the agent node. 
Catalog is a document that describes the desired system state for one specific computer. It lists all of the resources that need to be managed, as well as any dependencies between those resources. Puppet master server controls important configuration information and managed agent nodes request only their own configuration catalogs. In this architecture, managed nodes run the Puppet agent application, usually as a background service. One or more servers run the Puppet master application. Periodically, Puppet agent sends facts to the Puppet master and requests a catalog. The master compiles and returns that node’s catalog, using several sources of information it has access to. Once it receives a catalog, Puppet agent applies it by checking each resource the catalog describes. If it finds any resources that are not in their desired state, it makes any changes necessary to correct them. 

##### Standalone architecture
Puppet can run in a stand-alone architecture, where each managed server has its own complete copy of its configuration information and compiles its own catalog. In this architecture, managed nodes run the Puppet apply application, usually as a scheduled task or cron job. Like the Puppet master application, Puppet apply needs access to several sources of configuration data, which it uses to compile a catalog for the node it is managing. After Puppet apply compiles the catalog, it immediately applies it by checking each resource the catalog describes. If it finds any resources that are not in their desired state, it will make any changes necessary to correct them. 

---

## Setup  
For this demonstration, we used three machines provisioned on AWS. One machine was the master (puppet) and the others were the agents. We configured `puppetmaster` on the master and `puppet` on the agents. Here are the hostnames of the machines.  
* Master - `puppet`
* Agent1 - `agent1`
* Agent2 - `agent2`

All the machines are run using root user. For convenience, we have added the entries of the agents in the master's `/etc/hosts` file and vice versa. Confirm your connection by running `ping`. For convenience, you might want to name your master as `puppet` and agents as `agent1`, `agent2` and so on. By default, the agent tries to communicate with the master called `puppet`. If you want to change this, map that new name to the master's IP Address, and make sure you can connect using `ping <new_host>`.  

---

## Installation  
#### Master installation  
* Provision a Linux Ubuntu image.
* Log in as `root`.
* Download the `.deb` file from [this](https://apt.puppetlabs.com/?_ga=1.116435790.958851889.1447184049) location.
* Run the command `wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb`
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

#### Agent installation
* Provision one or more Linux Ubuntu images.
* Log in as `root`.
* Download the `.deb` file from [this](https://apt.puppetlabs.com/?_ga=1.116435790.958851889.1447184049) location.
* Run the command `wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb`
* Run the command `dpkg -i <package_name>`. In our case, this command was

	`dpkg -i puppetlabs-release-pc1-trusty.deb`

* Run the command `apt-get update`.
* Install the puppet agent by running the command `apt-get install puppet`. Notice the difference in the agent installation. Here, we are using `puppet` as opposed to `puppetmaster` for installing at the master.

To Summarize, follow the command to install puppet on the agent machines.
```
sudo su
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
dpkg -i puppetlabs-release-pc1-trusty.deb
apt-get update
apt-get install puppet
```

As soon as the agent has installed, a request to the master will be sent with the agent's SSL certificate. The agent cannot download the configuration from the master until the master signs this certificate.

#### Create manifest file on master
* Once puppet has installed on the master, navigate to `/etc/puppet/manifests`.
* Create a new `site.pp` file in that directory.
* Add the following lines in that file
* Here is an [internal link](https://github.com/aneeshkher/DevOpsTechTalk/blob/master/site.pp) to this file.

```
package {'git':
	ensure => 'present'
}

file {'/root/test_file.txt':
	ensure => 'present',
    mode => '0644',
    content => 'Test file created using manifest\n'
}

group {'devops':
	ensure => 'present',
    gid => 456
}

user {'testuser1':
	ensure => 'present',
    gid => 'devops',
    home => '/home/testuser1',
    managehome => true
}
```
---
## Getting configuration from master  
#### Signing agent's request  
On the master, run the command `puppet cert --list`. You will get a list of certificate requests from the agents which have puppet installed. The output will look something like this
```
"agent1.us-west-2.compute.internal" (SHA256) B4:D3:F2:....
"agent2.us-west-2.compute.internal" (SHA256) 04:BD:01:....
```

To approve an agent's request, type the command  

`puppet cert sign agent1.us-west-2.compute.internal`  

After this, the agent can communicate with the master.  

#### Testing the agent
After the request has been signed, go to any agent whose request has been signed, and type the following commands.  
```
puppet agent --enable
puppet agent --test
```  

This command will  perform a test download of the `site.pp` manifest from the master, and apply the configuration. If the test succeeds, the agent and master are now connected, and the agent will receive configuration information from the master at regular intervals.  

---

## Configuring agent
#### Timeout
On the agent, open the file `/etc/puppet/puppet.conf` and add the following line to configure your timeout.  

`runinterval=2m`  

This will configure the run interval to be 2 minutes. Restart the puppet by typing `service puppet restart`. This will ensure that the puppe received configuration every 2 minutes.  

#### Changing master name 
On the agent, in the same `/etc/puppet/puppet.conf` file, in the `[main]` section, add the following line to change the master to the name you want.  

`server=<Your_server>`  

Ensure that you can ping `Your_server` from the puppet agent.  

---

## Advantages
* automates the provisioning, configuration and management of machines and software running on them
* allows rapid, repeatable changes
* define once and apply to many machines
* automatically apply configuration changes
* enforce consistency across systems
* can define configuration using few lines of code
* good extensibility and open source license

---

## Limitations
* while applying the configuration, if one of the tasks fails then it still continues with the other tasks
* when nodes are added and removed frequently, it becomes tedious to manage the certificates on the puppet master server

---

## Screencast

Here is a [link to](https://youtu.be/Jb-lILFToAI) the screencast. It shows the basic installation along with a simple use case.  

---
