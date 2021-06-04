resource "aws_iam_role" "codepipeline_build_image" {
  name = "CodePipeline_BuildImage_${local.project_name}"
  tags = local.default_tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_build_image" {
  role = aws_iam_role.codepipeline_build_image.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "*",
      "Effect": "Allow",
      "Condition": {
        "StringEqualsIfExists": {
          "iam:PassedToService": [
            "cloudformation.amazonaws.com",
            "elasticbeanstalk.amazonaws.com",
            "ec2.amazonaws.com",
            "ecs-tasks.amazonaws.com"
          ]
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:UploadArchive",
        "codecommit:GetUploadArchiveStatus",
        "codecommit:CancelUploadArchive"
      ],
      "Resource": "${aws_codecommit_repository.source.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "${aws_s3_bucket.codepipeline_artifacts_bucket.arn}"
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_artifacts_bucket.arn}",
        "${aws_s3_bucket.codepipeline_artifacts_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": [
        "${aws_codebuild_project.build_app1.arn}",
        "${aws_codebuild_project.build_app2.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "codebuild_build_image" {
  name = "CodeBuild_BuildImage_${local.project_name}"
  tags = local.default_tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_build_image" {
  role = aws_iam_role.codebuild_build_image.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:${local.aws_region}:${local.aws_account_id}:log-group:/aws/codebuild/${aws_codebuild_project.build_app1.name}",
        "arn:aws:logs:${local.aws_region}:${local.aws_account_id}:log-group:/aws/codebuild/${aws_codebuild_project.build_app1.name}:*",
        "arn:aws:logs:${local.aws_region}:${local.aws_account_id}:log-group:/aws/codebuild/${aws_codebuild_project.build_app2.name}",
        "arn:aws:logs:${local.aws_region}:${local.aws_account_id}:log-group:/aws/codebuild/${aws_codebuild_project.build_app2.name}:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_artifacts_bucket.arn}",
        "${aws_s3_bucket.git_tree_hash_bucket.arn}"
      ]
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_artifacts_bucket.arn}",
        "${aws_s3_bucket.codepipeline_artifacts_bucket.arn}/*",
        "${aws_s3_bucket.git_tree_hash_bucket.arn}",
        "${aws_s3_bucket.git_tree_hash_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Resource": "${aws_secretsmanager_secret.dockerhub.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role" "cloudwatch_event_main_branch_changed" {
  name = "CloudWatchEvent_MainBranchChanged_${local.project_name}"
  tags = local.default_tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_event_main_branch_changed" {
  role = aws_iam_role.cloudwatch_event_main_branch_changed.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "codepipeline:StartPipelineExecution",
      "Resource": [
        "${aws_codepipeline.build_app1.arn}",
        "${aws_codepipeline.build_app2.arn}"
      ]
    }
  ]
}
EOF
}
