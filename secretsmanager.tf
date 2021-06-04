resource "aws_secretsmanager_secret" "dockerhub" {
  name = "${local.project_name}-dockerhub"
  tags = local.default_tags
}
