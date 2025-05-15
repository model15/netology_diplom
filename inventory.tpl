%{ for group, hosts in inventory ~}

[${group}]
%{ for host in hosts ~}
${host}
%{ endfor ~}
%{ endfor ~}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=../.ssh/id_ed25519
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q ubuntu@${bastion_ip}"'