output "rancher_host_registration_url" {
    value = "${rancher_registration_token.default.registration_url}"
}