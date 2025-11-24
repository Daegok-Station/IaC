#################################################################################
####################################### S3 ######################################
#################################################################################

resource "aws_s3_bucket" "artifact" {
  bucket = "daegok-codepipeline-s3"
}

resource "aws_s3_bucket_versioning" "artifact" {
  bucket = aws_s3_bucket.artifact.id                # AWS 리소스 ID로 사용

  versioning_configuration {
    status = "Enabled"          # 버전 관리 활성화(아티팩트 덮어쓰기 방지, 필수)
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifact" {
  bucket = aws_s3_bucket.artifact.bucket

  rule {
    apply_server_side_encryption_by_default {       # Amazon S3 관리형 키(SSE-S3)를 사용한 서버 측 암호화
      sse_algorithm = "AES256"
    }
  }
}
