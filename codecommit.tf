
resource "aws_codecommit_repository" "source" {
  repository_name = "${local.project_name}-apps"
  tags            = local.default_tags
}
