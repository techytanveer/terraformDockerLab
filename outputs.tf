output "app_url" {
  description = "URL to access the web server"
  value       = "http://localhost:8080"
}

output "container_name" {
  value = docker_container.web_server.name
}
