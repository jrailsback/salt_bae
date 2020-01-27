/*
Provider credentials and settings will be passed in
as environment variables from setup/config/credentials.json
and setup/config/settings.json
*/
provider "aws" {}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners      = ["aws-marketplace"]

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/*-18.04-amd64-server-*"]
    }
}

resource "aws_security_group" "salt_bae_default" {
    name        = "salt_bae_default"
    description = "Allow traffic to site"
}

resource "aws_security_group_rule" "allow_ssh" {
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.salt_bae_default.id
}

resource "aws_security_group_rule" "allow_http" {
    type              = "ingress"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.salt_bae_default.id
}

resource "aws_security_group_rule" "allow_postgresql" {
    type              = "ingress"
    from_port         = 5432
    to_port           = 5432
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.salt_bae_default.id
}

resource "aws_security_group_rule" "allow_node" {
    type              = "ingress"
    from_port         = 3000
    to_port           = 3000
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.salt_bae_default.id
}

resource "aws_instance" "web" {
    ami             = data.aws_ami.ubuntu.id
    instance_type   = "t2.micro"
    vpc_security_group_ids = [aws_security_group.salt_bae_default.id]

    tags = {
        Name = "salt_bae"
    }
}