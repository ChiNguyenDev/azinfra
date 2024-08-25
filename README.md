This project demonstrates a scalable cloud infrastructure using Azure, designed to host key DevOps components and services. The entire infrastructure—including VMs, load balancer, MS SQL Database, firewall, and other resources—was provisioned using Terraform for automation and consistency. Additionally, Ansible is used to automate the installation, configuration, and management of software components

-------------------------------------------------------------------------------------------------------------------
Key Components:

Git Server: Version control hosted on an Azure VM trough Gitea, providing a centralized repository for all projects

CI/CD Pipeline: Automated deployment and integration using Jenkins, with Jenkins agents containerized for efficient scaling and management

SMTP Server: Email notifications and alerts are managed through a dedicated SMTP server

MS SQL Database: A managed Azure SQL Database is used for secure, reliable data storage

Datadog: Comprehensive monitoring and alerting are integrated via Datadog
