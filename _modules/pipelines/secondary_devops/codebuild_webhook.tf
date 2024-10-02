locals {
  events_filter   = "PUSH"
  head_ref_filter = (var.env == "dev" && var.multi_branch == true) || var.env == "prod" ? "^refs/heads/.*" : "^refs/heads/${var.git_branch}$"
}
resource "aws_codebuild_webhook" "this" {
  count        = var.env == "prod" ? 0 : 1
  project_name = aws_codebuild_project.this.name

  filter_group {
    filter {
      type                    = "EVENT"
      pattern                 = local.events_filter
      exclude_matched_pattern = false
    }

    filter {
      type                    = "HEAD_REF"
      pattern                 = local.head_ref_filter
      exclude_matched_pattern = var.env == "prod" ? true : false
    }
    filter {
      type                    = "HEAD_REF"
      pattern                 = "^refs/tags/.*"
      exclude_matched_pattern = true
    }
  }
}
