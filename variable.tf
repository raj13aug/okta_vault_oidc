variable "base_url" {
  description = "The Okta base URL. Example: okta.com, oktapreview.com, etc. This is the domain part of your Okta org URL"
  default     = "trial-9871177-admin.okta.com"
}
variable "org_name" {
  description = "The Okta org name. This is the part before the domain in your Okta org URL"
  default     = "trial-9871177"
}
variable "api_token" {
  type        = string
  description = "The Okta API token, this will be read from environment variable (TF_VAR_api_token) for security"
  sensitive   = true
}

variable "vault_addr" {
  type        = string
  description = "Vault address in the form of https://domain:8200"
  default     = "vault.robofarming.link"
}


variable "okta_domain" {
  type    = string
  default = "trial-9871177-admin.okta.com"
}

variable "okta_client_id" {
  type = string
}

variable "okta_client_secret" {
  type = string
}
