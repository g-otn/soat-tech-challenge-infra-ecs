# terraform-computing

[![Terraform Apply](https://github.com/soat-tech-challenge/terraform-computing/actions/workflows/main.yml/badge.svg)](https://github.com/soat-tech-challenge/terraform-computing/actions/workflows/main.yml)

Part of a group course project of a self service and kitchen management system for a fictional fast food restaurant.

Currently responsible for managing computing-related resources of the project.

### Service

#### ECS Exec

Requires: AWS CLI, Session Manager plugin

Enter ECS task container shell using ECS Exec:

```
aws ecs execute-command \
  --region us-east-1 \
  --cluster SOAT_Tech_Challenge_ECS_Cluster \
  --task task-id \
  --container SOAT-TC_ECS_<service>_SVC_Main_Container \
  --interactive \
  --command "/usr/bin/sh"
```

Read more: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html#ecs-exec-enabling-and-using
