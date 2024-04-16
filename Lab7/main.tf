provider "vault" {
  address = "http://0.0.0.0:8200"
  skip_child_token = true
 
  auth_login {
    path = "auth/approle/login"
 
    parameters = {
      role_id = "your role id here"
      secret_id = "your secret id here"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "secret"
  name  = "data"
}


resource "aws_instance" "instance" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  tags = {
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }

}