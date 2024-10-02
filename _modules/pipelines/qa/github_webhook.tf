provider "github" {
  token        = var.github_pat
  organization = var.git_hub_organization
}

resource "github_repository_webhook" "this" {
  repository = replace(replace(var.git_repo_url, "https://github.com/hlexperts/", ""), ".git", "")
  configuration {
    url          = var.webhook_endpoint
    content_type = "json"
    insecure_ssl = false
    secret       = var.github_shared_secret
  }
  active = true
  events = ["delete"]
}
