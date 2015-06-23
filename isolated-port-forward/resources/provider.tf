provider "cloudstack" {
    api_url   = "${var.cs_api_url}"
    api_key = "${var.cs_api_key}"
    secret_key = "${var.cs_secret_key}"
}
