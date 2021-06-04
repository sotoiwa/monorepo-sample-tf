locals {
  aws_region     = data.aws_region.current.name
  aws_account_id = data.aws_caller_identity.current.account_id

  project_name = "monorepo-sample"

  default_tags = {
    "terraform:project" = local.project_name
  }
}
