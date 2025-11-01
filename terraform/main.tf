terraform {
  required_version = ">= 1.0"

  required_providers {
    render = {
      source  = "render-oss/render"
      version = "~> 0.1"
    }
  }
}

provider "render" {
  api_key  = var.render_api_key
  owner_id = var.owner_id
}

# Render Web Service for the backend API
resource "render_web_service" "backend_api" {
  name           = var.service_name
  plan           = var.plan_id
  region         = var.region
  root_directory = var.root_dir

  # Docker runtime source configuration (required argument)
  runtime_source = {
    docker = {
      repo_url       = var.repo
      branch         = var.branch
      dockerfile_path = "Dockerfile"
      context        = var.root_dir
      auto_deploy    = true
    }
  }

  # Environment variables
  env_vars = merge(
    {
      NODE_ENV = {
        value = var.node_env
      }
      PORT = {
        value = tostring(var.port)
      }
    },
    var.arcjet_key != null ? {
      ARCJET_KEY = {
        value = var.arcjet_key
      }
    } : {}
  )

  # Health check path
  health_check_path = var.health_check_path
}

