# ─────────────────────────────────────────────
# WAF Policy
# ─────────────────────────────────────────────
resource "azurerm_cdn_frontdoor_firewall_policy" "waf" {
  name                = "${replace(var.app_name, "-", "")}waf"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = azurerm_cdn_frontdoor_profile.fd.sku_name
  enabled             = true

  # Start in Detection so you can review logs before blocking real traffic.
  # Change to "Prevention" once you're satisfied with the rule behaviour.
  mode = "Detection"

  # NOTE: managed_rule blocks (OWASP / BotManager) require Premium_AzureFrontDoor.
  # On Standard we use custom rules instead. Upgrade the SKU below to get
  # full OWASP managed rule sets.

  # Rate-limit rule: block IPs that send more than 1000 requests per minute.
  custom_rule {
    name                           = "RateLimitRule"
    enabled                        = true
    priority                       = 100
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 1000
    type                           = "RateLimitRule"
    action                         = "Block"

    match_condition {
      match_variable = "RemoteAddr"
      operator       = "IPMatch"
      # Invert the match so the rule applies to everyone *except* a trusted range.
      # To restrict to specific IPs instead, set negation_condition = false and
      # list the IPs you want to block.
      negation_condition = false
      match_values       = ["0.0.0.0/0"]
    }
  }

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# ─────────────────────────────────────────────
# Front Door Profile (Standard tier)
# ─────────────────────────────────────────────
resource "azurerm_cdn_frontdoor_profile" "fd" {
  name                = "${var.app_name}-fd"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# ─────────────────────────────────────────────
# Security Policy – attaches WAF to Front Door
# ─────────────────────────────────────────────
resource "azurerm_cdn_frontdoor_security_policy" "waf_attach" {
  name                     = "${var.app_name}-waf-policy"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.waf.id

      association {
        # Apply WAF to all endpoints on this profile
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.main.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}

# ─────────────────────────────────────────────
# Endpoint  (the public-facing hostname)
# ─────────────────────────────────────────────
resource "azurerm_cdn_frontdoor_endpoint" "main" {
  name                     = "${var.app_name}-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# ─────────────────────────────────────────────
# Origin Groups
# ─────────────────────────────────────────────

# Backend (Go API on App Service)
resource "azurerm_cdn_frontdoor_origin_group" "backend" {
  name                     = "backend-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
    additional_latency_in_milliseconds = 50
  }

  health_probe {
    path                = "/health"
    request_type        = "GET"
    protocol            = "Https"
    interval_in_seconds = 30
  }
}

# Frontend (React Static Web App)
resource "azurerm_cdn_frontdoor_origin_group" "frontend" {
  name                     = "frontend-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
    additional_latency_in_milliseconds = 50
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 60
  }
}

# ─────────────────────────────────────────────
# Origins (the actual backend servers)
# ─────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_origin" "backend" {
  name                          = "backend-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.backend.id

  host_name          = azurerm_linux_web_app.backend.default_hostname
  origin_host_header = azurerm_linux_web_app.backend.default_hostname
  https_port         = 443
  http_port          = 80
  priority           = 1
  weight             = 1000
  enabled            = true

  # App Service requires the host header to match the app hostname
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_origin" "frontend" {
  name                          = "frontend-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.frontend.id

  host_name          = azurerm_static_web_app.frontend.default_host_name
  origin_host_header = azurerm_static_web_app.frontend.default_host_name
  https_port         = 443
  http_port          = 80
  priority           = 1
  weight             = 1000
  enabled            = true

  certificate_name_check_enabled = true
}

# ─────────────────────────────────────────────
# Routes
# ─────────────────────────────────────────────

# /api/* → Go backend
resource "azurerm_cdn_frontdoor_route" "backend" {
  name                          = "backend-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.backend.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.backend.id]

  patterns_to_match      = ["/api/*"]
  supported_protocols    = ["Http", "Https"]
  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true

  # Don't cache API responses
  cache {
    query_string_caching_behavior = "IgnoreQueryString"
    compression_enabled           = false
  }
}

# /* → React frontend (catch-all, lower priority)
resource "azurerm_cdn_frontdoor_route" "frontend" {
  name                          = "frontend-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.frontend.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.frontend.id]

  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]
  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true

  # Cache static assets at the edge
  cache {
    query_string_caching_behavior = "IgnoreQueryString"
    compression_enabled           = true
    content_types_to_compress = [
      "text/html",
      "text/css",
      "application/javascript",
      "application/json",
      "image/svg+xml",
    ]
  }
}
