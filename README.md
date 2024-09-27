# Power Apps VNET integration with Azure

Power Apps private connection to Azure SQL Server following the VNET support [documetation][1] and the [setup guidelines][2].

## Requirements

- Power Apps license (E.g.: Power Apps Premium)
- Use [managed environments][1]. Make sure to enable it after the environment creation.

Follow the steps in the [setup guidelines][2], such as registering the `Microsoft.PowerPlatform` provider.

## Setup

Identify the IP address that will be administering the resources:

```sh
curl ifconfig.me
```

Create the `.auto.tfvars` file:

```sh
cp config/template.tfvars .auto.tfvars
```

Set the required variables:

```terraform
subscription_id    = "<subscriptionId>"
allowed_public_ips = ["<your ip>"]
```

Create the resources:

```sh
terraform init
terraform apply -auto-approve
```


[1]: https://learn.microsoft.com/en-in/power-platform/admin/vnet-support-overview
[2]: https://learn.microsoft.com/en-in/power-platform/admin/vnet-support-setup-configure
[3]: https://learn.microsoft.com/en-in/power-platform/admin/managed-environment-overview
