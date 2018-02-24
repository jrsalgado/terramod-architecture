provider "rancher" {
  api_url    = "${var.api_url}"
#   TODO: set access key
#   access_key = "${var.rancher_access_key}"
#   secret_key = "${var.rancher_secret_key}"
}

data "rancher_environment" "default" {
  name = "Default"
}

resource "rancher_registration_token" "default" {
  name           = "staging_token"
  description    = "Registration token for the staging environment"
  environment_id = "${data.rancher_environment.default.id}"
}

# resource "rancher_stack" "letsChat" {
#   name            = "lets-chat-2"
#   description     = "This is a chat app"
#   environment_id  = "${data.rancher_environment.default.id}"
#   start_on_create = 1
#   finish_upgrade  = 1
#   docker_compose  =  <<EOF
# version: '2'
# services:
#   database:
#     image: mongo
#     stdin_open: true
#     tty: true
#     labels:
#       io.rancher.container.pull_image: always
#   website:
#     image: rancher/lb-service-haproxy:v0.7.5
#     ports:
#     - 80:80/tcp
#     labels:
#       io.rancher.container.agent.role: environmentAdmin
#       io.rancher.container.create_agent: 'true'
#       io.rancher.scheduler.global: 'true'
#   web:
#     image: sdelements/lets-chat
#     stdin_open: true
#     tty: true
#     links:
#     - database:mongo
#     labels:
#       io.rancher.container.pull_image: always
# EOF

#   rancher_compose = <<EOF
# version: '2'
# services:
#   database:
#     scale: 1
#     start_on_create: true
#   website:
#     start_on_create: true
#     lb_config:
#       certs: []
#       port_rules:
#       - hostname: ''
#         priority: 1
#         protocol: http
#         service: web
#         source_port: 80
#         target_port: 8080
#     health_check:
#       response_timeout: 2000
#       healthy_threshold: 2
#       port: 42
#       unhealthy_threshold: 3
#       initializing_timeout: 60000
#       interval: 2000
#       reinitializing_timeout: 60000
#   web:
#     scale: 1
#     start_on_create: true
# EOF

# }

# # TODO: Add Route53
# resource "rancher_stack" "Route53" {
#   name            = "route53-1"
#   description     = "external dns"
#   environment_id  = "${data.rancher_environment.default.id}"
#   start_on_create = 0
#   finish_upgrade  = 1
#   docker_compose  =  <<EOF
# version: '2'
# services:
#   route53:
#     image: rancher/external-dns:v0.7.0
#     environment:
#       AWS_ACCESS_KEY: 
#       AWS_SECRET_KEY: 
#       NAME_TEMPLATE: '%{{service_name}}.%{{stack_name}}.%{{environment_name}}'
#       ROOT_DOMAIN: 
#       ROUTE53_ZONE_ID: 
#       TTL: '60'
#     volumes:
#     - /var/lib/rancher:/var/lib/rancher
#     expose:
#     - '1000'
#     command:
#     - -provider=route53
#     labels:
#       io.rancher.container.agent.role: external-dns
#       io.rancher.container.create_agent: 'true'
# EOF
#   rancher_compose = <<EOF
# version: '2'
# services:
#   route53:
#     scale: 1
#     start_on_create: true
#     health_check:
#       healthy_threshold: 2
#       response_timeout: 5000
#       port: 1000
#       unhealthy_threshold: 2
#       interval: 10000
#       strategy: recreate
#       request_line: GET / HTTP/1.0

# EOF

# }
