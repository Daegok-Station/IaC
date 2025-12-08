resource "aws_s3_bucket" "pipeline_artifact" {
  bucket = "daegok-codepipeline-s3-test1239"
}

resource "aws_s3_bucket_versioning" "pipeline_artifact_versioning" {
  bucket = aws_s3_bucket.pipeline_artifact.id 
  
  versioning_configuration {
    status = "Enabled" # enabled = true 대신 status = "Enabled" 사용
  }
}

resource "aws_codepipeline" "ecs_pipeline" {
  name     = "Daegok-Codepipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifact.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name = "Source"
      category = "Source"
      owner = "AWS"
      provider = "S3"
      output_artifacts = ["source_output"]
      version = "1"
      configuration = {
        S3Bucket = aws_s3_bucket.pipeline_artifact.bucket
        S3ObjectKey = "Daegok-Petclinic-Artifacts/artifact.zip"
        PollForSourceChanges  = "false"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name = "CodeDeploy-ECS"
      category = "Deploy"
      owner = "AWS"
      provider = "CodeDeploy"
      input_artifacts = ["source_output"]
      version = "1"

      configuration = {
        ApplicationName = "Daegok-CodeDeploy"
        DeploymentGroupName = "Daegok-CodeDeploy"
      }
    }
  }
}
