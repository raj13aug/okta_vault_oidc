
# Enable and configure the Okta provider
terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 3.15"
    }
  }
}

provider "okta" {
  org_name  = var.org_name
  base_url  = var.base_url
  api_token = var.api_token
}



resource "okta_group" "okta-group-vault-admins" {
  name        = "okta-group-vault-admins"
  description = "Users who can access cluster as admins"
}

resource "okta_user" "admin" {
  first_name = "raj"
  last_name  = "ram"
  login      = "raj@gmail.com"
  email      = "raj@gmail.com"
  password   = "M@n2345678"
}

# Assign users to the groups
data "okta_user" "admin" {
  search {
    name  = "profile.email"
    value = "raj@gmail.com"
  }
}

resource "okta_group_memberships" "admin_user" {
  group_id = okta_group.okta-group-vault-admins.id
  users = [
    data.okta_user.admin.id
  ]
}


/* resource "vault_jwt_auth_backend" "okta" {
  # Enable OIDC auth for Okta integration
  description        = "Demo of the OIDC auth backend with Okta"
  path               = "okta"
  type               = "oidc"
  oidc_discovery_url = "https://${var.okta_domain}"
  oidc_client_id     = var.okta_client_id
  oidc_client_secret = var.okta_client_secret
  default_role       = "vault-role-okta-default"
}

resource "vault_jwt_auth_backend_role" "vault-role-okta-default" {
  # default role for okta
  backend               = vault_jwt_auth_backend.okta.path
  role_name             = "vault-role-okta-default"
  user_claim            = "sub"
  role_type             = "oidc"
  bound_audiences       = [var.okta_client_id]
  allowed_redirect_uris = ["${var.vault_addr}/ui/vault/auth/${vault_jwt_auth_backend.okta.path}/oidc/callback", "http://localhost:8250/oidc/callback"]
  token_policies        = ["default"]
  oidc_scopes           = ["groups"]
  groups_claim          = "groups"

} */