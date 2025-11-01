output "service_url" {
  description = "URL of the deployed Render service"
  value       = render_web_service.backend_api.url
}

output "service_id" {
  description = "ID of the Render service"
  value       = render_web_service.backend_api.id
}

output "service_name" {
  description = "Name of the Render service"
  value       = render_web_service.backend_api.name
}

