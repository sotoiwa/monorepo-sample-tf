resource "aws_s3_bucket" "codepipeline_artifacts_bucket" {
  bucket = "${local.project_name}-codepipeline-artifacts-${local.aws_account_id}"
  tags   = local.default_tags
}

resource "aws_s3_bucket" "git_tree_hash_bucket" {
  bucket = "${local.project_name}-git-tree-hash-${local.aws_account_id}"
  tags   = local.default_tags
}
