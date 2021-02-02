credentials = "../../credentials.json"
project = "organic-boulder-284215"
machine_type = "n1-standard-2"
image = "centos-cloud/centos-7"
instance1 = "elastic-01"
instance2 = "elastic-02"
instance3 = "elastic-03"
hostname1 = "elastic-01.srv"
hostname2 = "elastic-02.srv"
hostname3 = "elastic-03.srv"
ip1 = "10.150.0.15"
ip2 = "10.150.0.16"
ip3 = "10.150.0.17"
zone1 = "us-east4-a"
zone2 = "us-east4-b"
zone3 = "us-east4-c"
region = "us-east4"
disk_size = "30"
user = "silveira"
bastion_ip = "34.122.0.195"
bastion_user = "silveira"
bastion_private_key = "~/.ssh/silveira"
ansible_private_key = "/tmp/silveira"
ansible_home = "/home/silveira/elastic-terraform-gcp/ansible"
private_key = "~/.ssh/silveira"
ssh_key = "~/.ssh/silveira.pub"
network = "default"
cluster_name = "silveira"
es_heap_size = "4g"
es_version = "7.9.2"
