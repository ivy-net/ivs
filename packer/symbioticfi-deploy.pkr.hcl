packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

variable "account" {
  type        = string
  default     = "0x123463a4b065722e99115d6c222f267d9cabb524"
  description = "Address of the account to use to publish smart contracts"
}

variable "commit" {
  type        = string
  default     = "cb5de4659250d56929e2d7013553465d5dd2627e"
  description = "Commit in EigenLayer-contracts matchin the one used by the AVS"
}

variable "version" {
  type        = string
  description = "Version of the image"
}

source "docker" "symbioticfi" {
  changes = [
    "ENTRYPOINT [\"forge\", \"script\"]",
    "WORKDIR /symbioticfi",
  ]
  commit   = true
  image    = "ghcr.io/foundry-rs/foundry:nightly-c2e529786c07ee7069cefcd4fe2db41f0e46cef6"
  platform = "linux/amd64"
}

build {
  sources = ["source.docker.symbioticfi"]
  provisioner "shell" {
    inline = [
      "apk update --no-cache && apk upgrade --no-cache",
      "apk add --update --no-cache git",
      "mkdir /symbioticfi",
      "cd /symbioticfi",
      "git clone https://github.com/symbioticfi/core.git",
      "cd core",
      "echo ETH_RPC_URL=http://geth:8545 > .env",
      "echo ETHERSCAN_API_KEY= >> .env",
      "forge install",
      "forge build",
    ]
  }
  post-processors {
    post-processor "docker-tag" {
      repository = "public.ecr.aws/ivynet/iv1-symbioticfi" # (comment it out for local deployment)
      tags       = [var.version, "latest"]
    }
    post-processor "docker-push" {
      ecr_login    = true
      aws_profile  = "ivy-test"
      login_server = "public.ecr.aws/ivynet/iv1-symbioticfi"
    }
  }
}
