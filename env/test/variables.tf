###Secret Varibales###
variable "current_branch_name" {
  description = "The name of the branch that triggered the workflow"
  type        = string
}

variable "letsencrypt_cloudflare_api_token" {
  default = "TxuxGYO80XIRS6IjuFDf6fXFCFvdy83OxZn--uMA"
  type      = string
  sensitive = true
}

###Non secrete Variables###
variable "resource_location" {
  default = "West Europe"
}