resource "okta_group" "okta-group-vault-admins" {
  name        = "okta-group-vault-admins"
  description = "Users who can access cluster as admins"
  depends_on  = [okta_user.admin]
}

resource "okta_user" "admin" {
  first_name = "raj"
  last_name  = "ram"
  login      = "raj@gmail.com"
  email      = "raj@gmail.com"
  password   = "M@n2345678"
}

resource "time_sleep" "wait_3_seconds" {
  create_duration = "4s"
}


# Assign users to the groups
data "okta_user" "admin" {
  search {
    name       = "profile.email"
    value      = "raj@gmail.com"
    comparison = "sw"
  }
  depends_on = [time_sleep.wait_3_seconds, okta_user.admin]
}

resource "okta_group_memberships" "admin_user" {
  group_id = okta_group.okta-group-vault-admins.id
  users = [
    data.okta_user.admin.id
  ]
  depends_on = [okta_user.admin]
}



resource "okta_app_oauth" "oidc" {
  label = "Vault_OIDC"
  type  = "web" # this is important

  grant_types = [
    "authorization_code",
    "implicit",
  ]
  response_types = ["code", "token", "id_token"]
  redirect_uris = [
    "https://vault.robofarming.link/ui/vault/auth/okta/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
}


resource "okta_app_group_assignments" "oidc_group" {
  app_id = okta_app_oauth.oidc.id
  group {
    id = okta_group.okta-group-vault-admins.id
  }
}


resource "okta_app_oauth_api_scope" "scopes" {
  app_id = okta_app_oauth.oidc.id
  issuer = "https://trial-9871177.okta.com"
  scopes = ["okta.groups.read", "okta.users.read.self"]
}


data "okta_auth_server" "oidc_auth_server" {
  name = "default"
}

resource "okta_auth_server_claim" "auth_claim" {
  name                    = "groups"
  auth_server_id          = data.okta_auth_server.oidc_auth_server.id
  always_include_in_token = true
  claim_type              = "IDENTITY"
  group_filter_type       = "STARTS_WITH"
  value                   = "okta-group-vault"
  value_type              = "GROUPS"
}