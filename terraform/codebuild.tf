resource "aws_codebuild_project" "app" {
  name         = "${var.project_name}-build"
  description  = "Construit l'application statique de la masterclass"
  service_role = aws_iam_role.codebuild.arn

  # La source et la sortie sont gerees par CodePipeline.
  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}
