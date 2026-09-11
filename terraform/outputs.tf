output "site_url" {
  description = "URL publique du site (endpoint S3 website). A ouvrir pendant la demo."
  value       = "http://${aws_s3_bucket_website_configuration.site.website_endpoint}"
}

output "connexion_github_arn" {
  description = "ARN de la connexion GitHub a autoriser une fois dans la console AWS."
  value       = aws_codestarconnections_connection.github.arn
}

output "pipeline_name" {
  description = "Nom du pipeline a suivre dans la console CodePipeline."
  value       = aws_codepipeline.pipeline.name
}
