variable "aws_region" {
  description = "Region AWS de deploiement"
  type        = string
  default     = "eu-west-3"
}

variable "project_name" {
  description = "Prefixe de nommage de toutes les ressources"
  type        = string
  default     = "masterclass-devops"
}

variable "github_owner" {
  description = "Proprietaire du depot GitHub (utilisateur ou organisation)"
  type        = string
}

variable "github_repo" {
  description = "Nom du depot GitHub qui contient ce projet"
  type        = string
}

variable "github_branch" {
  description = "Branche suivie par le pipeline"
  type        = string
  default     = "main"
}
