variable "render_api_key" {
  description = "Render API key for authentication"
  type        = string
  sensitive   = true
}

variable "service_name" {
  description = "Name of the Render service"
  type        = string
  default     = "backend-challenge-api"
}

variable "owner_id" {
  description = "Owner ID (team or user ID) in Render"
  type        = string
}

variable "repo" {
  description = "https://github.com/juliofihdeldev/DevopsChallenge.git"
  type        = string
}

variable "branch" {
  description = "Git branch to deploy from"
  type        = string
  default     = "main"
}

variable "root_dir" {
  description = "Root directory of the application in the repository"
  type        = string
  default     = "."
}

variable "region" {
  description = "Render region (e.g., oregon, frankfurt, singapore)"
  type        = string
  default     = "oregon"
}

variable "plan_id" {
  description = "Render service plan ID (e.g., starter, standard, pro)"
  type        = string
  default     = "starter"
}

variable "node_env" {
  description = "Node environment (production, development, etc.)"
  type        = string
  default     = "production"
}

variable "port" {
  description = "Port number for the application"
  type        = number
  default     = 3001
}

variable "arcjet_key" {
  description = "Arcjet API key (optional)"
  type        = string
  default     = null
  sensitive   = true
}

variable "health_check_path" {
  description = "Health check endpoint path"
  type        = string
  default     = "/healthz"
}

