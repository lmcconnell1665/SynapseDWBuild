# What is Infrastructure as Code (IAC)

Infrastructure as code is the management of (typically cloud-based) infrastructure through declarative code. [Read more in the Microsoft docs.](https://docs.microsoft.com/en-us/devops/deliver/what-is-infrastructure-as-code)

Key Benefits:
- Source control
- Disaster recovery
- CI/CD & DevOps

Common IAC platforms: 
- [Terraform](https://www.terraform.io/)
- [Pulami](https://www.pulumi.com/)
- [ARM](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/overview)

<br> 

# What is Azure Bicep

[Azure Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview#get-started) is a domain specific language specifically for controlling Azure infrastructure. It is an abstraction of Azure ARM templates (and decompiles to ARM templates) that provides a much more user friendly experience. It is also a declarative langauge that doesn't require you to maintain a "state" file.
