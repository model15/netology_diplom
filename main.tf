# Веб-сервера
resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "web-${count.index}"
  hostname    = "web-${count.index}" 
  platform_id = "standard-v3" #Intel Ice Lake
  zone        = count.index % 2 == 0 ? "ru-central1-a" : "ru-central1-b"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = false # Прерываемость
  }

  boot_disk {
    initialize_params {
      image_id = "fd8q8tjpq11liqgdprah" # Ubuntu 24
      size = 10
    }
  }

  network_interface {
    subnet_id = count.index % 2 == 0 ? yandex_vpc_subnet.private_a.id : yandex_vpc_subnet.private_b.id
    security_group_ids = [yandex_vpc_security_group.web.id]
    nat = false
  }

  metadata = {
    #ssh-keys = "ubuntu:${file("./.ssh/id_ed25519.pub")}"
    user-data = file("cloud-init.yml")
  }
}




# Бастион хост
resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion" # FQDN: bastion.ru-central1.internal
  platform_id = "standard-v3" #Intel Ice Lake
  
  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = false # Прерываемость
  }

  boot_disk {
    initialize_params {
      image_id = "fd8q8tjpq11liqgdprah" # Ubuntu 24
      size = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.bastion.id]
  }

  metadata = {
    #ssh-keys = "ubuntu:${file("./.ssh/id_ed25519.pub")}"
    user-data = file("cloud-init.yml")
  }
}





# Zabbix 
resource "yandex_compute_instance" "zabbix" {
  name        = "zabbix"
  hostname    = "zabbix" # FQDN: zabbix.ru-central1.internal
  platform_id = "standard-v3" #Intel Ice Lake
  
  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = false # Прерываемость
  }

  boot_disk {
    initialize_params {
      image_id = "fd8q8tjpq11liqgdprah" # Ubuntu 24
      size = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.zabbix.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("./.ssh/id_ed25519.pub")}"
  }
}





# Elastic 
resource "yandex_compute_instance" "elastic" {
  name        = "elastic"
  hostname    = "elastic" # FQDN: elastic.ru-central1.internal
  platform_id = "standard-v3" #Intel Ice Lake
  
  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = false # Прерываемость
  }

  boot_disk {
    initialize_params {
      image_id = "fd8q8tjpq11liqgdprah" # Ubuntu 24
      size = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_a.id
    nat = false
    security_group_ids = [yandex_vpc_security_group.elastic.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("./.ssh/id_ed25519.pub")}"
  }
}





# Kibana 
resource "yandex_compute_instance" "kibana" {
  name        = "kibana"
  hostname    = "kibana" # FQDN: kibana.ru-central1.internal
  platform_id = "standard-v3" #Intel Ice Lake
  
  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = false # Прерываемость
  }

  boot_disk {
    initialize_params {
      image_id = "fd8q8tjpq11liqgdprah" # Ubuntu 24
      size = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.kibana.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("./.ssh/id_ed25519.pub")}"
  }
}
