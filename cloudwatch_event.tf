resource "aws_cloudwatch_event_rule" "main_branch_changed" {
  name = "${local.project_name}-main-branch-changed"
  tags = local.default_tags

  event_pattern = <<EOF
{
  "source": [
    "aws.codecommit"
  ],
  "detail-type": [
    "CodeCommit Repository State Change"
  ],
  "resources": [
    "${aws_codecommit_repository.source.arn}"
  ],
  "detail": {
    "event": [
      "referenceCreated",
      "referenceUpdated"
    ],
    "referenceType": [
      "branch"
    ],
    "referenceName": [
      "main"
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "main_branch_changed_build_app1" {
  rule     = aws_cloudwatch_event_rule.main_branch_changed.name
  arn      = aws_codepipeline.build_app1.arn
  role_arn = aws_iam_role.cloudwatch_event_main_branch_changed.arn
}

resource "aws_cloudwatch_event_target" "main_branch_changed_build_app2" {
  rule     = aws_cloudwatch_event_rule.main_branch_changed.name
  arn      = aws_codepipeline.build_app2.arn
  role_arn = aws_iam_role.cloudwatch_event_main_branch_changed.arn
}
