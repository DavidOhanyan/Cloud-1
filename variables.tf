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
