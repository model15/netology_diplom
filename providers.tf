terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.87.0" 
    }
  }
}

provider "yandex" {
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  service_account_key_file = var.sa_key_file
  zone                     = "ru-central1-a" 
}

# Объявление переменных
variable "yc_cloud_id" {
  description = "Yandex Cloud Cloud ID"
  type        = string
}

variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "sa_key_file" {
  description = "Path to service account key file"
  type        = string
}