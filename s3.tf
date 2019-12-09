resource "aws_s3_bucket" "k8sbackups" {
  acl    = "private"
  bucket = "k8sbackups.mydomain.co.uk"
  tags = {
    Name        = "K8S backups bucket"
  }
  versioning {
    enabled = true
  }
}