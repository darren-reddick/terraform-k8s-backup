resource "aws_ssm_document" "backupk8s" {
  name          = "backup_k8s_master"
  document_type = "Command"
  document_format = "YAML"

  content = <<DOC
---
schemaVersion: '2.2'
description: Backup K8s Master
parameters: {}
mainSteps:
- action: aws:runShellScript
  name: backupk8s
  inputs:
    runCommand:
    - timestamp=$(TZ='Europe/London' date +%Y-%m-%dT%H%M%SZ)
    - backupdir=/backup/kubernetes/$${timestamp}
    - echo "Creating backup directory $${backupdir}....."
    - mkdir -p $${backupdir}
    - echo "Copying ssl certs to backup dir......" 
    - cp -r /etc/kubernetes/pki $${backupdir}
    - echo "Running an etcd container to backup the etcd database to backup directory..."
    - docker run --rm -v $${backupdir}:/backup
         --network host
         -v /etc/kubernetes/pki/etcd:/etc/kubernetes/pki/etcd
         --env ETCDCTL_API=3
         k8s.gcr.io/etcd-amd64:3.2.18
         etcdctl --endpoints=https://127.0.0.1:2379
         --cacert=/etc/kubernetes/pki/etcd/ca.crt
         --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt
         --key=/etc/kubernetes/pki/etcd/healthcheck-client.key
         snapshot save /backup/etcd-snapshot-latest.db
    - echo "Backing up admin conf for accessing cluster using kubectl..."
    - cp /etc/kubernetes/admin.conf $${backupdir}
    - echo "Copying backup files to S3....."
    - aws s3 cp --recursive $${backupdir} s3://${aws_s3_bucket.k8sbackups.id}/$${timestamp}/$(hostname -f)/
DOC
}