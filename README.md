# terraform-kafka
Terraform script to run a Kafka Cluster on AWS. This project will create:
- Zookeeper Cluster with 3 instances
- Kafka Cluster with 3 instances
- Monitoring instance using docker:
 - Zookeeper Monitor (http://<monitoring_ip>:8001)
 - Kafka Manager (http://<monitoring_ip>:9000)
 - Kafka Topic UI (http://<monitoring_ip>:8000)
 - Confluent Schema Registry (http://<monitoring_ip>:8081)

## Prerequisites

Required software:
- AWS CLI
- Terraform

AWS credentials configured properly (https://www.terraform.io/docs/providers/aws/index.html)

## Starting the Infrastructure

Got execute init command
```sh
terraform init
```
To Plan and review the changes made in the Cluster:

```sh
terraform plan -out "planfile"  
```

**__Review the Plan of Execution BEFORE executing it__**

To execute the changes:
```sh
terraform apply -input=false "planfile" 
```
The application can be accessed on Load Balancer`s URL.

> To Change the settings edit the file listed on ./terraform.tfvars

## Updating the Infrastructure

To Change the settings edit the file listed on ./terraform.tfvars

To Plan and review the changes made in the Cluster:

```sh
terraform plan -out "planfile"  
```

**__Review the Plan of Execution BEFORE executing it__**

To execute the changes:
```sh
terraform apply -input=false "planfile" 
```

The infrastructure will return the monitoring instance IP for access:
```sh
Apply complete! Resources: 0 added, 2 changed, 0 destroyed.

Outputs:

monitoring_ip = 3.94.78.122
```