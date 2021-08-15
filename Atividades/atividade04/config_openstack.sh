#!/bin/bash

#2 ---------------------------------------CRIADO OS PROJETOS--------------------------------------------------------------------------------
openstack project create UFCQuixada

openstack project create IFCEQuixada

#3---------------------CRIADO USUARIOS E ADICIONANDO ELES A UM PROJETO COM CARGO------------------------------------------------------------

openstack user create josberto --project UFCQuixada --password senha

openstack user create maria --project IFCEQuixada --password senha

openstack role add admin --project UFCQuixada --user josberto

openstack role add admin --project IFCEQuixada --user maria

openstack role add admin --project IFCEQuixada --user admin

openstack role add admin --project UFCQuixada --user admin

#4----------------------------ADICIONANDO IMAGEM VINCULADA A UM PROJETO---------------------------------------------------------------------

openstack image create Cirros --file cirros-0.5.1-x86_64-disk.img --disk-format qcow2 --shared --project UFCQuixada


#5------------------------------------ADICIONANDO OS FLAVORS--------------------------------------------------------------------------------
openstack flavor create m1.tiny --vcpus 1 --disk 1 --ram 512

openstack flavor create m1.small --vcpus 1 --disk 20 --ram 2048

openstack flavor create m1.medium --vcpus 2 --disk 40 --ram 4096

openstack flavor create m1.large --vcpus 4 --disk 80 --ram 8192

openstack flavor create m1.xlarge --vcpus 8 --disk 160 --ram 16384

#6---------------------------------------ADICIONANDO QUOTAS---------------------------------------------------------------------------------

openstack quota show --default

openstack quota set --ram 2048 --instances 2 --key-pairs 2 --cores 2 --class default

openstack quota show --default


#7-----------------------------------------CRIANDO E CONFIGURANDO UMA REDE PARA UM PROJETO--------------------------------------------------

openstack network create ufcnet --project UFCQuixada


openstack subnet create ufcsubnet1 --project UFCQuixada --subnet-range 172.16.100.0/24 --gateway 172.16.100.254 --allocation-pool start=172.16.100.100,end=172.16.100.200 --dns-nameserver 8.8.8.8 --network ufcnet


#8-------------------------------------ENTRANDO EM UM USUARIO CRIADO E CRIANDO UM PAR DE CHAVES---------------------------------------------


OS_USERNAME=josberto
OS_PASSWORD=12345
OS_PROJECT_NAME=UFCQuixada


openstack keypair create ufckey --private-key ufckey

#9-------------------------------------CRIA UM GRUPO DE SEGURANÇA E HBAILITANDO PORTAS DE ENTRADAS------------------------------------------


openstack security group create ufcsecgroup --project UFCQuixada
openstack security group rule create --protocol icmp --ingress ufcsecgroup
openstack security group rule create --protocol tcp --dst-port 22 --ingress ufcsecgroup


#10--------------------------------------------------------CRIANDO INSTANCIAS---------------------------------------------------------------

openstack server create instancia01 --image Cirros --flavor m1.tiny --network ufcnet --security-group ufcsecgroup --key-name ufckey

openstack server create instancia02 --image Cirros --flavor m1.tiny --network ufcnet --security-group ufcsecgroup --key-name ufckey
