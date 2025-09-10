output "kafka_node_ips" {
  value = aws_instance.kafka_node[*].private_ip
}
