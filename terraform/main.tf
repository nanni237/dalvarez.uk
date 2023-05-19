resource "digitalocean_project" "site_project" {
  name        = "dalvarezuk-project"
  description = "one"
  purpose     = "Web Application"
  environment = "Production"
  resources   = [digitalocean_app.site_app.urn]
  is_default  = false
}

resource "digitalocean_app" "site_app" {
  spec {
    name   = "dalvarezuk-app"
    region = "lon"
    domain {
      name = "dalvarez.uk"
    }
    static_site {
      name          = "dalvarezuk-main"
      source_dir    = "hugo"
      output_dir    = "public"
      build_command = "hugo -d public"
      github {
        repo           = "nanni237/dalvarez.uk"
        branch         = "main"
        deploy_on_push = true
      }
      routes {
        path = "/"
      }
    }
  }
}

resource "cloudflare_record" "root_record" {
  zone_id = var.cloudflare_zone_id
  name    = "dalvarez.uk"
  value   = replace(digitalocean_app.site_app.default_ingress, "/(https://)|(/)/", "")
  type    = "CNAME"
}

resource "cloudflare_record" "www_record" {
  zone_id = var.cloudflare_zone_id
  name    = "www.dalvarez.uk"
  value   = replace(digitalocean_app.site_app.default_ingress, "/(https://)|(/)/", "")
  type    = "CNAME"
}
