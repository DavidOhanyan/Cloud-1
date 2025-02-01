variable "ssh_user" {
  description = "my ssh user"
  type        = string
  default     = "dohanyan"
}

variable "ansible_param" {
    description = "this is ansible parametrs for configure hosts"
    type = list(string)
    default = ["ansible_user", "ansible_host"]
}

variable "ansible_group" {
    description = "gropu for ansible"
    type = string
    default = "gcp_servers"
}

variable "server_nick" {
  description = "nickname for asnible host"
  type        = string
  default     = "server1"
}

variable "docker_repo" {
  description = "URL for Docker repository"
  type        = string
  default     = "https://download.docker.com/linux/ubuntu"
}

variable "GPG_key" {
  description = "URL for the GPG key of the Docker repository"
  type        = string
  default     = "https://download.docker.com/linux/ubuntu/gpg"
}

