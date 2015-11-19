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

## Screencast

Here is a [link to](https://youtu.be/Jb-lILFToAI) the screencast. It shows the basic installation along with a simple use case.  

---