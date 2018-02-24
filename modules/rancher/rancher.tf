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

resource "rancher_stack" "letsChat-5" {
  name            = "lets-chat-5"
  description     = "This is a chat app"
  environment_id  = "${data.rancher_environment.default.id}"
  start_on_create = 1
  finish_upgrade  = 1
  docker_compose  =  <<EOF
version: '2'
services:
  database:
    image: mongo
    stdin_open: true
    tty: true
    labels:
      io.rancher.container.pull_image: always
  website:
    image: rancher/lb-service-haproxy:v0.7.5
    ports:
    - 80:80/tcp
    labels:
      io.rancher.container.agent.role: environmentAdmin
      io.rancher.container.create_agent: 'true'
      io.rancher.scheduler.global: 'true'
  web:
    image: sdelements/lets-chat
    stdin_open: true
    tty: true
    links:
    - database:mongo
    labels:
      io.rancher.container.pull_image: always
EOF

  rancher_compose = <<EOF
version: '2'
services:
  database:
    scale: 1
    start_on_create: true
    health_check:
      response_timeout: 2000
      healthy_threshold: 2
      strategy: recreate
      port: 27017
      unhealthy_threshold: 3
      initializing_timeout: 60000
      interval: 2000
      reinitializing_timeout: 60000
  website:
    start_on_create: true
    lb_config:
      certs: []
      port_rules:
      - hostname: ''
        priority: 1
        protocol: http
        service: web
        source_port: 80
        target_port: 8080
    health_check:
      response_timeout: 2000
      healthy_threshold: 2
      port: 42
      unhealthy_threshold: 3
      strategy: recreate
      initializing_timeout: 60000
      interval: 2000
      reinitializing_timeout: 60000
  web:
    scale: 1
    start_on_create: true
    health_check:
      response_timeout: 2000
      healthy_threshold: 2
      strategy: recreate
      port: 8080
      unhealthy_threshold: 3
      initializing_timeout: 60000
      interval: 2000
      reinitializing_timeout: 60000
EOF

}

resource "rancher_stack" "external-dns" {
  name           = "route53"
  description    = "Route53 stack"
  environment_id = "${data.rancher_environment.default.id}"
  catalog_id     = "library:route53:7"
  scope          = "system"
  start_on_create = 1
  finish_upgrade  = 1

  environment {
    AWS_ACCESS_KEY        = ""
    AWS_SECRET_KEY        = ""
    AWS_REGION            = "us-west-1"
    TTL                   = "60"
    ROOT_DOMAIN           = ""
    ROUTE53_ZONE_ID       = ""
    HEALTH_CHECK_INTERVAL = "15"
  }
}