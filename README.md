# Terraform Provider sts (Security Token Service)

## Problem this provider solves
The AWS Terraform provider is able to assume roles by passing a role to another aws provider block resources linked to that provider will be created using the credentials from assuming that role.

But when using a null_resource to run a command with the aws cli there isn't a way to do the same thing nicely, it usually involves writing some assume role logic into a shell script before executing the commands you care about. This provider allows you to pass in a role, it will assume the role and return the temporary credentials to set the environment for a local-exec provisioner.

See the [example terraform](examples/main.tf) for a demonstration of my poorly described scenario.

## Contributing

This is my first terraform provider and one of my first Go projects, so improvements or suggestions are welcome and appreciated.