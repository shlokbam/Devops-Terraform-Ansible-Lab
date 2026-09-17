provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "http://<YOUR_VAULT_SERVER_IP>:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = "<YOUR_VAULT_ROLE_ID>"
      secret_id = "<YOUR_VAULT_SECRET_ID>"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test-secret"
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}