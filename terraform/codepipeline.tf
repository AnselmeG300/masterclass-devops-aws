# ============================================================
#  Connexion GitHub (CodeStar Connections)
#
#  ATTENTION : apres le premier "terraform apply", cette connexion
#  est creee au statut PENDING. Il faut aller une seule fois dans la
#  console AWS (Developer Tools > Connections), cliquer sur la connexion,
#  puis "Update pending connection" pour autoriser GitHub.
#  Tant que ce n'est pas fait, le pipeline ne peut pas lire le depot.
# ============================================================
resource "aws_codestarconnections_connection" "github" {
  name          = "${var.project_name}-gh"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.project_name}-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.artifacts.bucket
    type     = "S3"
  }

  # ---------- Etape 1 : Source ----------
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "${var.github_owner}/${var.github_repo}"
        BranchName       = var.github_branch
      }
    }
  }

  # ---------- Etape 2 : Build ----------
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.app.name
      }
    }
  }

  # ---------- Etape 3 : Deploy ----------
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        BucketName = aws_s3_bucket.site.bucket
        Extract    = "true"
      }
    }
  }
}
