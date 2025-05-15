//
// Create a new Compute Snapshot.
//

resource "yandex_compute_snapshot_schedule" "snapshot" {
  name = "snapshot"
  description    = "full snapshot"

    schedule_policy {
    expression = "0 0 * * *"
  }

  retention_period = "168h"

  snapshot_spec {
    description = "retention-snapshot"

  }

  disk_ids = concat(              
    yandex_compute_instance.web[*].boot_disk[0].disk_id,
    [
    yandex_compute_instance.bastion.boot_disk[0].disk_id,
    yandex_compute_instance.zabbix.boot_disk[0].disk_id,
    yandex_compute_instance.elastic.boot_disk[0].disk_id,
    yandex_compute_instance.kibana.boot_disk[0].disk_id
    ]  
    )


  depends_on = [
    yandex_compute_instance.web,
    yandex_compute_instance.bastion,
    yandex_compute_instance.zabbix,
    yandex_compute_instance.elastic,
    yandex_compute_instance.kibana
  ]

}