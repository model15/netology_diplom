locals {
  inventory = {
    web = [for vm in yandex_compute_instance.web : "${vm.name}.ru-central1.internal"]
    bastion    = ["${yandex_compute_instance.bastion.name}.ru-central1.internal"]
    zabbix     = ["${yandex_compute_instance.zabbix.name}.ru-central1.internal"]
    elastic    = ["${yandex_compute_instance.elastic.name}.ru-central1.internal"]
    kibana     = ["${yandex_compute_instance.kibana.name}.ru-central1.internal"]
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("./inventory.tpl", {
    inventory = local.inventory
    bastion_ip = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
  })
  filename = "./ansible/inventory.ini"
}