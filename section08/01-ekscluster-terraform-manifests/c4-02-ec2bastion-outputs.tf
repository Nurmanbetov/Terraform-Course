output "ec2_bastion_public_instance_ids" {
  description = "List of IDs of instances"
  value       = module.ec2_public.id
}

output "ec2_bastion_eip" {
    description = "Elastic IP associated to the Bastion "
    value = aws_eip.bastion_eip.public_ip
}