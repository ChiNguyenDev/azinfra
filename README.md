This project demonstrates a scalable cloud infrastructure using Azure, designed to host key DevOps components and services. 

Key Components:

Git Server: Version control hosted on an Azure VM, providing a centralized repository for all projects. Ansible automates the installation and configuration of Gitea on the VM.

CI/CD Pipeline: Automated deployment and integration using Jenkins, with Jenkins agents containerized for efficient scaling and management. Ansible handles the setup of Jenkins and its plugins, as well as the configuration of CI/CD pipelines.

SMTP Server: Email notifications and alerts are managed through a dedicated SMTP server. Ansible is used to automate the installation and configuration of the SMTP server software.

MS SQL Database: A managed Azure SQL Database is used for secure, reliable data storage. Terraform provisions the database, and Ansible can be used for managing database configurations if needed.

Datadog: Comprehensive monitoring and alerting are integrated via Datadog. Ansible automates the installation and configuration of Datadog agents on the VMs, ensuring that monitoring is consistently applied across the infrastructure.

Key Technologies Used:

Terraform: Provisioning of infrastructure resources including VMs, load balancer, firewall, and Azure SQL Database.

Ansible: Configuration management and software installation for Git server (Gitea), CI/CD pipeline (Jenkins), SMTP server, and Datadog monitoring.
