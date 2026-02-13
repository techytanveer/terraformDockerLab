resource "docker_image" "nginx_img" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "web_server" {
  name  = "terraform-docker-guide"
  image = docker_image.nginx_img.image_id
  
  ports {
    internal = 80
    external = 8080
  }
}
