resource "aws_codestarnotifications_notification_rule" "this" {
  detail_type    = "FULL"
  event_type_ids = ["codebuild-project-build-state-failed", "codebuild-project-build-state-succeeded", "codebuild-project-build-state-in-progress", "codebuild-project-build-state-stopped", "codebuild-project-build-phase-failure", "codebuild-project-build-phase-success"]

  name     = "${var.env}-${var.application_name}-notifications"
  resource = aws_codebuild_project.this.arn

  target {
    address = var.sns_arn
  }
}
