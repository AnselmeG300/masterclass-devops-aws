provider "aws" {
  region = var.aws_region
}

# Recupere l'ID du compte AWS courant.
# On l'utilise comme suffixe pour garantir des noms de bucket S3 uniques
# (les noms de bucket sont uniques au niveau mondial).
data "aws_caller_identity" "current" {}

locals {
  suffix = data.aws_caller_identity.current.account_id
}
