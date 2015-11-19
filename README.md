# CSC DevOps Tech Talk - Puppet  

## Introduction to puppet
Puppet is an open source configuration management tool. On a high level, it consists of one `puppet master` and many `puppet agent`s. The agents are authorized at the puppet using SSL certification. Once the puppet signs the agent's request, the agent receives the configuration from the master at periodic intervals. 

## Setup  
For this demonstration, we used three machines provisioned on AWS. One machine was the master (puppet) and the others were the agents. We configured `puppetmaster` on the master and `puppet` on the agents. Here are the hostnames of the machines.  
* Master - `puppet`
* Agent1 - `agent1`
* Agent2 - `agent2`

All the machines are run using root user. For convenience, we have added the entries of the agents in the master's `/etc/hosts` file and vice versa. Confirm your connection by running `ping`. For convenience, you might want to name your master as `puppet` and agents as `agent1`, `agent2` and so on.  

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

#### Create manifest file on master
* Once puppet has installed on the master, navigate to `/etc/puppet/manifests`.
* Create a new `site.pp` file in that directory.
* Add the following lines in that file
* Here is an [internal link]() to this file.

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


