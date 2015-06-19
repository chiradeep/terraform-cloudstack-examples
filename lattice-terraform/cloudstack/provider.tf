provider "cloudstack" {
    api_url   = "http://10.220.135.12:8080/client/api"
    api_key = "${var.cs_api_key}"
    secret_key = "${var.cs_secret_key}"
}
