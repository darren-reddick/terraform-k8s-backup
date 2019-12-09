resource "aws_iam_role" "backupk8s" {
  name               = "backupk8s"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "backupk8s" {
  name   = "backupk8s"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:SendCommand"
            ],
            "Resource": ["arn:aws:ec2:eu-west-1::instance/*"]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:SendCommand"
            ],
            "Resource": ["${aws_ssm_document.backupk8s.arn}"]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "backupk8s" {
    role       = "${aws_iam_role.backupk8s.name}"
    policy_arn = "${aws_iam_policy.backupk8s.arn}"
}