resource "aws_cloudwatch_event_rule" "backupk8s" {
    name = "K8S_Backups"
    description = "Backup Kubernetes Master"
    schedule_expression = "cron(11 9,15 * * ? *)"
}

resource "aws_cloudwatch_event_target" "backupk8s" {
  target_id = "backupk8s"
  arn       = "${aws_ssm_document.backupk8s.arn}"
  rule      = "${aws_cloudwatch_event_rule.backupk8s.name}"
  role_arn  = "${aws_iam_role.backupk8s.arn}"

  run_command_targets {
    key    = "tag:Role"
    values = ["kubemaster"]
  }
}