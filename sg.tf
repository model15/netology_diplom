# Группа безопасности для балансировщика
resource "yandex_vpc_security_group" "balancer" {
  name        = "balancer-sg"
  network_id  = yandex_vpc_network.main.id

  # Разрешаем HTTP из интернета
  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol          = "ANY"
    description       = "Health checks from ALB"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    predefined_target = "loadbalancer_healthchecks"
  }

  # Разрешаем исходящий трафик к целевым серверам
  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["192.168.0.0/16"]
  }
}


# Группа безопасности для веб-серверов
resource "yandex_vpc_security_group" "web" {
  name        = "web-sg"
  network_id  = yandex_vpc_network.main.id

  # Разрешаем HTTP от балансировщика
  ingress {
    protocol          = "TCP"
    port              = 80
    security_group_id = yandex_vpc_security_group.balancer.id
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    port           = 22
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    protocol       = "TCP"
    description    = "zabbix in"
    port           = 10050
    v4_cidr_blocks = ["192.168.0.0/16"] 
  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


# Группа безопасности бастиона
resource "yandex_vpc_security_group" "bastion" {
  name        = "bastion-sg"
  network_id  = yandex_vpc_network.main.id

  # Разрешаем только SSH
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Разрешаем исходящий трафик
  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

}



resource "yandex_vpc_security_group" "kibana" {
  name        = "kibana-sg"
  description = "kibana"
  network_id  = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "kibana interface"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "zabbix in"
    port           = 10050
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    port           = 22
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "yandex_vpc_security_group" "zabbix" {
  name        = "zabbix-sg"
  description = "zabbix"
  network_id  = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "HTTP in"
    port           = 8080
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "zabbix in"
    port           = 10051
    v4_cidr_blocks = ["192.168.0.0/16"] 
    
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    port           = 22
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "yandex_vpc_security_group" "elastic" {
  name        = "elastic-sg"
  description = "elastic"
  network_id  = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "zabbix in"
    port           = 10050
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    protocol       = "TCP"
    description    = "elastic agent in"
    port           = 9200
    v4_cidr_blocks = ["192.168.0.0/16"] 
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    port           = 22
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

   egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}