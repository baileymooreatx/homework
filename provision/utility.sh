#! /bin/bash
# 'vagrant ssh' is equivlent to
# ssh vagrant@127.0.0.1 -p2200 -i $HOME/temp/homework/provision/.vagrant/machines/default/virtualbox/private_key

# copy files from vm to host
# scp -P 2200 -i $HOME/temp/homework/provision/.vagrant/machines/default/virtualbox/private_key vagrant@127.0.0.1:~/runitdoc.tar .

# ad hoc command to execute ping on the remote host
# See https://ansible-tips-and-tricks.readthedocs.io/en/latest/ansible/commands/
# ansible all -i "127.0.0.1," -u vagrant -e ansible_ssh_port=2200 --private-key $HOME/temp/homework/provision/.vagrant/machines/default/virtualbox/private_key -m ping

# Rerun the playbook on the vm
ansible-playbook -i "127.0.0.1," -u vagrant -e ansible_ssh_port=2200 --private-key $HOME/temp/homework/provision/.vagrant/machines/default/virtualbox/private_key playbook.yml
