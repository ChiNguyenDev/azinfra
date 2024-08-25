This project demonstrates a scalable cloud infrastructure using Azure, designed to host key DevOps components and services. The setup includes:

Git Server: Version control hosted on an Azure VM, providing a centralized repository for all projects.

CI/CD Pipeline: Automated deployment and integration using Jenkins. Jenkins agents are containerized for efficient scaling and management.

SMTP Server: Email notifications and alerts are managed through a dedicated SMTP server.

MS SQL Database: A managed Azure SQL Database is used for data storage.

Datadog: monitoring and alerting are integrated via Datadog, replacing the need for an extra monitoring VM.

This infrastructure is designed for scalability, ensuring efficient resource usage while maintaining high availability across all services.
