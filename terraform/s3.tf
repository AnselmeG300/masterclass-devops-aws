# ============================================================
#  Bucket 1 : le site web statique (public en lecture)
# ============================================================
resource "aws_s3_bucket" "site" {
  bucket        = "${var.project_name}-site-${local.suffix}"
  force_destroy = true # permet un terraform destroy propre en fin de demo
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Par defaut AWS bloque tout acces public. On leve ce blocage
# uniquement pour ce bucket, car c'est un site web public.
resource "aws_s3_bucket_public_access_block" "site" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Politique qui autorise la lecture publique des objets (les pages du site).
resource "aws_s3_bucket_policy" "site" {
  bucket     = aws_s3_bucket.site.id
  depends_on = [aws_s3_bucket_public_access_block.site]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.site.arn}/*"
    }]
  })
}

# ============================================================
#  Bucket 2 : les artefacts du pipeline (prive)
# ============================================================
resource "aws_s3_bucket" "artifacts" {
  bucket        = "${var.project_name}-artifacts-${local.suffix}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket                  = aws_s3_bucket.artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
