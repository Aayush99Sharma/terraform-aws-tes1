# Outputs (add backend instance outputs)
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet1_id" {
  description = "Public Subnet 1 ID"
  value       = aws_subnet.public1.id
}

output "public_subnet2_id" {
  description = "Public Subnet 2 ID"
  value       = aws_subnet.public2.id
}

output "private_subnet1_id" {
  description = "Private Subnet 1 ID"
  value       = aws_subnet.private1.id
}

output "private_subnet2_id" {
  description = "Private Subnet 2 ID"
  value       = aws_subnet.private2.id
}

output "backend_instance_id" {
  description = "Backend EC2 Instance ID"
  value       = aws_instance.backend.id
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance."
  value       = aws_db_instance.rds_instance.endpoint
}

# Output for the frontend load balancer DNS name
output "frontend_load_balancer_dns" {
  value = aws_lb.frontend.dns_name
  description = "The DNS name of the frontend load balancer"
}

# Output for the backend load balancer DNS name
output "backend_load_balancer_dns" {
  value = aws_lb.backend.dns_name
  description = "The DNS name of the backend load balancer"
}

# Output for the frontend Auto Scaling Group name
output "frontend_asg_name" {
  value = aws_autoscaling_group.frontend.name
  description = "The name of the frontend Auto Scaling group"
}

# Output for the backend Auto Scaling Group name
output "backend_asg_name" {
  value = aws_autoscaling_group.backend.name
  description = "The name of the backend Auto Scaling group"
}

# Output for the frontend load balancer security group ID
output "frontend_load_balancer_sg_id" {
  value = aws_security_group.frontend_load_balancer.id
  description = "The ID of the frontend load balancer security group"
}

# Output for the backend load balancer security group ID
output "backend_load_balancer_sg_id" {
  value = aws_security_group.backend_load_balancer.id
  description = "The ID of the backend load balancer security group"
}

# Output for the frontend launch template ID
output "frontend_launch_template_id" {
  value = aws_launch_template.frontend.id
  description = "The ID of the frontend launch template"
}

# Output for the backend launch template ID
output "backend_launch_template_id" {
  value = aws_launch_template.backend.id
  description = "The ID of the backend launch template"
}

# Output for the frontend target group ARN
output "frontend_target_group_arn" {
  value = aws_lb_target_group.frontend.arn
  description = "The ARN of the frontend target group"
}

# Output for the backend target group ARN
output "backend_target_group_arn" {
  value = aws_lb_target_group.backend.arn
  description = "The ARN of the backend target group"
}

# Output for the frontend scaling policy name
output "frontend_scaling_policy_name" {
  value = aws_autoscaling_policy.frontend.name
  description = "The name of the frontend scaling policy"
}

# Output for the backend scaling policy name
output "backend_scaling_policy_name" {
  value = aws_autoscaling_policy.backend.name
  description = "The name of the backend scaling policy"
}
