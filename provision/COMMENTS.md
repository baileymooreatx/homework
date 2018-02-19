## My _Provision Vagrant with Ansible_ Adventure 

#### Overview  
- [RTFM](#rtfm)
- [Setup](#setup)  
  - [Fork](#fork) the homework project  
  - [Vagrant](#vagrant)  
  - [Ansible](#ansible)  
  - [Test](#testsetup) setup  
- [The tasks](#tasks)  
  - [Strategy](#strategy) - Fail fast. Fail often.
  - [Part two](#two) - Complete `playbook.yml`
  - [Part one](#one) - Complete the `config/nginx.conf` by writing a server directive(s) that proxies to the upstream application.   
- [Regression](#regression) test 

### Read The Friendly Manual <a name="rtfm"></a>
1. Read the instructions in [adhocteam/homework/README.md](https://github.com/adhocteam/homework/blob/master/README.md)  
1. Read the instructions in [adhocteam/homework/provision/README.md](https://github.com/adhocteam/homework/blob/master/provision/README.md)  
1. Read the files provided in [adhocteam/homework/provision/](https://github.com/adhocteam/homework/blob/master/provision/)  
1. Collect handy resources
    1. [Ansible](http://docs.ansible.com/ansible/latest/playbooks_special_topics.html) documentation
    1. [runit installation](https://packagecloud.io/imeyer/runit/install#manual) instructions
    1. [runit](http://smarden.org/runit/index.html) documentation
    1. [NGINX](https://nginx.org/en/docs/) documentation
    1. [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#links) cheatsheet

### Setup <a name="setup"></a>

#### Fork the Ad Hoc homework project <a name="fork"></a>
1. Create yet another GitHub account to use as a target for the fork.  
1. Fork the [GitHub project](https://github.com/adhocteam/homework/) into your GitHub account.
1. Clone the shiny, new fork into `<some_directory>` created for just this purpose.
1. Open the local clone in a trusty IDE, like IntelliJ or Emacs.

#### Vagrant <a name="vagrant"></a>
Install [Vagrant.](https://www.vagrantup.com/)  
Let's take a sneak peak at `/homework/provision/Vagrantfile` to see what it's up to, being very careful not to modify it in any way.
  ```
   Vagrant.configure("2") do |config|
     config.vm.box = "bento/centos-6.8"
   
     config.vm.network "private_network", type: "dhcp"
     config.vm.network "forwarded_port", guest: 80, host: 8080
   
     config.vm.provision "ansible_local" do |ansible|
       ansible.playbook = "playbook.yml"
     end
   end
   ```
Navigate to [Getting Started](https://www.vagrantup.com/intro/getting-started/index.html) if you installed Vagrant once several years ago to learn Docker, but then learned the sweet, newer versions of Docker for Mac OSX have that magic baked right in.  
Instead of the instructions there, use these to create a target environment.
```shell
$ cd <some_directory>
$ vagrant init bento/centos-6.8
$ vagrant up
```
NOTE: We must do this somewhere other than `homework/provision` because Vagrant will see the `Vagrantfile` already there and spit at you.

#### Ansible <a name="ansible"></a>
 Install [Ansible](https://docs.ansible.com/ansible/intro_installation.html) on the host.  
 NOTE: Ansible is installed dynamically by `/homework/provision/Vagrantfile` which runs `homework/provision/playbook.yml` so our work here is done.

#### Test setup <a name="testsetup"></a>
The README says, "You can test that your playbook works by running `./provision.sh`."    
Let's see what happens.
```shell
Baileys-MacBook-Pro:provision bailey$ pwd
/Users/bailey/temp/homework/provision
Baileys-MacBook-Pro:provision bailey$ ./provision.sh 
==> default: VM not created. Moving on...
==> default: VM not created. Moving on...
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'bento/centos-6.8'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'bento/centos-6.8' is up to date...
==> default: Setting the name of the VM: provision_default_1518835259419_75801
==> default: Fixed port collision for 22 => 2222. Now on port 2200.
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
    default: Adapter 2: hostonly
==> default: Forwarding ports...
    default: 80 (guest) => 8080 (host) (adapter 1)
    default: 22 (guest) => 2200 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2200
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: 
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default: 
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Configuring and enabling network interfaces...
    default: SSH address: 127.0.0.1:2200
    default: SSH username: vagrant
    default: SSH auth method: private key
==> default: Mounting shared folders...
    default: /vagrant => /Users/bailey/temp/homework/provision
==> default: Running provisioner: ansible_local...
    default: Installing Ansible...
Vagrant has automatically selected the compatibility mode '2.0'
according to the Ansible version installed (2.4.2.0).

Alternatively, the compatibility mode can be specified in your Vagrantfile:
https://www.vagrantup.com/docs/provisioning/ansible_common.html#compatibility_mode

    default: Running ansible-playbook...
[DEPRECATION WARNING]: The use of 'include' for tasks has been deprecated. Use 
'import_tasks' for static inclusions or 'include_tasks' for dynamic inclusions.
 This feature will be removed in a future release. Deprecation warnings can be 
disabled by setting deprecation_warnings=False in ansible.cfg.
[DEPRECATION WARNING]: include is kept for backwards compatibility but usage is
 discouraged. The module documentation details page may explain more about this
 rationale.. This feature will be removed in a future release. Deprecation 
warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.

PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [default]

TASK [install dependencies] ****************************************************
changed: [default] => (item=[u'unzip', u'libselinux-python', u'openssl'])

PLAY RECAP *********************************************************************
default                    : ok=2    changed=1    unreachable=0    failed=0   

Fail: status code is 000
Fail: X-Forwarded-For should not be 'None'
Fail: X-Real-IP should not be 'None'
Fail: "It's easier to ask forgiveness than it is to get permission." missing from response
Baileys-MacBook-Pro:provision bailey$ 
```  
Great success! Vagrant and Ansible are working.   
Since all our tests fail, we are all set to write some code.

### The task(s)  <a name="tasks"></a>  
#### Strategy
One must eat an elephant one bite at a time. Ideally, we would like to implement the smallest testable unit of work, test to ensure it works, and take the next bite. So let's tackle the homework in the following order.
1. Copy the web application to the vm, start it using the bash script provided, test that it using vagrant ssh and curl at the remote command line.
1. Install runit, configure a service for the web server, test that runit starts the webserver, test that the webserver is reincarnated when we kill it at the remote command line.
1. Install nginx, configure it as a reverse proxy, test the configuration works as advertised.

NOTE: Use script utility.sh to re-run the playbook on the vm 

#### Part two  <a name="two"></a>
Modify `playbook.yml` and create task files for implementing each part of our evil plan.
```yaml
    ---
    - hosts: all
      become: True
      tasks:
        # replace include with include tasks. include is deprecated.
        - include_tasks: tasks/deps.yml
    
        # your code goes here ...
        - include_tasks: tasks/application.yml
        - include_tasks: tasks/runit.yml
        - include_tasks: tasks/nginx.yml
```

#### Part one <a name="one"></a>  
Configure reverse proxy.
```config
user nginx nginx;
worker_processes 2;
error_log /var/log/nginx/error.log;
worker_rlimit_nofile 8192;

events {
  worker_connections 4096;
}

# See https://www.nginx.com/resources/wiki/start/topics/examples/full/
http {
  upstream pyserver {
    server localhost:8000 fail_timeout=0;
  }

  server {
    listen 80 default_server;
    server_name localhost;
    return 301 https://$host$request_uri;
  }

  server {
    listen 443 ssl default_server;
    server_name localhost;

    ssl_certificate     /etc/nginx/ssl/self-signed.crt;
    ssl_certificate_key /etc/nginx/ssl/self-signed.key;

    location / {
      proxy_set_header        Host $host:$server_port;
      proxy_set_header        X-Real-IP $remote_addr;
      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header        X-Forwarded-Proto $scheme;

      proxy_redirect          http:// https://;
      proxy_pass              http://pyserver;
    }
  }
}
```

### Regression test  <a name="regression"></a>
Run `provision.sh` to test the whole shebang.
```
Baileys-MacBook-Pro:provision bailey$ ./provision.sh 
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'bento/centos-6.8'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'bento/centos-6.8' is up to date...
==> default: Setting the name of the VM: provision_default_1519007028147_92202
==> default: Fixed port collision for 22 => 2222. Now on port 2200.
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
    default: Adapter 2: hostonly
==> default: Forwarding ports...
    default: 80 (guest) => 8080 (host) (adapter 1)
    default: 22 (guest) => 2200 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2200
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: 
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default: 
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Configuring and enabling network interfaces...
    default: SSH address: 127.0.0.1:2200
    default: SSH username: vagrant
    default: SSH auth method: private key
==> default: Mounting shared folders...
    default: /vagrant => /Users/bailey/temp/homework/provision
==> default: Running provisioner: ansible_local...
    default: Installing Ansible...
Vagrant has automatically selected the compatibility mode '2.0'
according to the Ansible version installed (2.4.2.0).

Alternatively, the compatibility mode can be specified in your Vagrantfile:
https://www.vagrantup.com/docs/provisioning/ansible_common.html#compatibility_mode

    default: Running ansible-playbook...

PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [default]

TASK [include_tasks] ***********************************************************
included: /vagrant/tasks/deps.yml for default

TASK [install dependencies] ****************************************************
changed: [default] => (item=[u'unzip', u'libselinux-python', u'openssl'])

TASK [include_tasks] ***********************************************************
included: /vagrant/tasks/application.yml for default

TASK [ensure target directory exists] ******************************************
changed: [default]

TASK [unzip application into opt] **********************************************
changed: [default]

TASK [make scripts executable] *************************************************
changed: [default]

TASK [include_tasks] ***********************************************************
included: /vagrant/tasks/runit.yml for default

TASK [install runit dependencies] **********************************************
ok: [default] => (item=[u'epel-release', u'pygpgme'])

TASK [set directory permissions to allow addition of yum repo] *****************
changed: [default]

TASK [run script to install runit repo] ****************************************
changed: [default]

TASK [install runit] ***********************************************************
changed: [default]

TASK [add runit to inittab] ****************************************************
changed: [default]

TASK [reload init configuration] ***********************************************
changed: [default]

TASK [ensure existence of /etc/service] ****************************************
ok: [default]

TASK [create directory for pyserver (webserver server.py)] *********************
changed: [default]

TASK [create symlink to run script for server.py] ******************************
changed: [default]

TASK [include_tasks] ***********************************************************
included: /vagrant/tasks/nginx.yml for default

TASK [install nginx and dependencies] ******************************************
changed: [default] => (item=[u'epel-release', u'nginx'])

TASK [ensure ssl folder exists] ************************************************
changed: [default]

TASK [copy SSL certifcate and key] *********************************************
changed: [default] => (item=self-signed.crt)
changed: [default] => (item=self-signed.key)

TASK [copy nginx configuration] ************************************************
changed: [default]

TASK [create directories for site specific configurations] *********************
changed: [default] => (item=sites-available)
changed: [default] => (item=sites-enabled)

TASK [restart nginx] ***********************************************************
changed: [default]

PLAY RECAP *********************************************************************
default                    : ok=24   changed=17   unreachable=0    failed=0   

Pass: status code is 200
Pass: X-Forwarded-For is present and not 'None'
Pass: X-Real-IP is present and not 'None'
Pass: found "It's easier to ask forgiveness than it is to get permission." in response
```