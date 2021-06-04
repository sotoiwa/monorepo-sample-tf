resource "aws_ecr_repository" "app1" {
  name = "${local.project_name}-app1"
  tags = local.default_tags
}

resource "aws_ecr_repository" "app2" {
  name = "${local.project_name}-app2"
  tags = local.default_tags
}
