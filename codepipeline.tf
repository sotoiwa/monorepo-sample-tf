resource "aws_codepipeline" "build_app1" {
  name     = "${local.project_name}-build-app1"
  tags     = local.default_tags
  role_arn = aws_iam_role.codepipeline_build_image.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.codepipeline_artifacts_bucket.bucket
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      name     = "Source"
      owner    = "AWS"
      provider = "CodeCommit"
      version  = "1"

      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = aws_codecommit_repository.source.id
        BranchName           = "main"
        PollForSourceChanges = false
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      category         = "Build"
      name             = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build_app1.name
      }
    }
  }
}

resource "aws_codebuild_project" "build_app1" {
  name         = "${local.project_name}-build-app1"
  tags         = local.default_tags
  service_role = aws_iam_role.codebuild_build_image.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "app1/buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    image                       = "aws/codebuild/standard:5.0"
    privileged_mode             = true
    compute_type                = "BUILD_GENERAL1_SMALL"

    environment_variable {
      name  = "DOCKERHUB_USERNAME"
      value = "${aws_secretsmanager_secret.dockerhub.name}:username"
      type  = "SECRETS_MANAGER"
    }

    environment_variable {
      name  = "DOCKERHUB_PASSWORD"
      value = "${aws_secretsmanager_secret.dockerhub.name}:password"
      type  = "SECRETS_MANAGER"
    }

    environment_variable {
      name  = "APP_NAME"
      value = "app1"
    }

    environment_variable {
      name  = "ECR_REPOSITORY_NAME"
      value = aws_ecr_repository.app1.name
    }

    environment_variable {
      name  = "GIT_TREE_HASH_BUCKET"
      value = aws_s3_bucket.git_tree_hash_bucket.id
    }
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE"]
  }
}

resource "aws_codepipeline" "build_app2" {
  name     = "${local.project_name}-build-app2"
  tags     = local.default_tags
  role_arn = aws_iam_role.codepipeline_build_image.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.codepipeline_artifacts_bucket.bucket
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      name     = "Source"
      owner    = "AWS"
      provider = "CodeCommit"
      version  = "1"

      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = aws_codecommit_repository.source.id
        BranchName           = "main"
        PollForSourceChanges = false
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      category         = "Build"
      name             = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build_app2.name
      }
    }
  }
}

resource "aws_codebuild_project" "build_app2" {
  name         = "${local.project_name}-build-app2"
  tags         = local.default_tags
  service_role = aws_iam_role.codebuild_build_image.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "app2/buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    image                       = "aws/codebuild/standard:5.0"
    privileged_mode             = true
    compute_type                = "BUILD_GENERAL1_SMALL"

    environment_variable {
      name  = "DOCKERHUB_USERNAME"
      value = "${aws_secretsmanager_secret.dockerhub.name}:username"
      type  = "SECRETS_MANAGER"
    }

    environment_variable {
      name  = "DOCKERHUB_PASSWORD"
      value = "${aws_secretsmanager_secret.dockerhub.name}:password"
      type  = "SECRETS_MANAGER"
    }

    environment_variable {
      name  = "APP_NAME"
      value = "app2"
    }

    environment_variable {
      name  = "ECR_REPOSITORY_NAME"
      value = aws_ecr_repository.app2.name
    }

    environment_variable {
      name  = "GIT_TREE_HASH_BUCKET"
      value = aws_s3_bucket.git_tree_hash_bucket.id
    }
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE"]
  }
}
