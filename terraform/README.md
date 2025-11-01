# Terraform Configuration for Render

This directory contains Terraform configuration files to deploy the backend challenge application to Render.

## Prerequisites

1. **Terraform**: Install Terraform (version >= 1.0)

   ```bash
   # macOS
   brew install terraform

   # Or download from https://www.terraform.io/downloads
   ```

2. **Render API Key**: Get your API key from [Render Dashboard](https://dashboard.render.com/account/api-keys)

3. **Owner ID**: Get your owner ID (team or user ID) from the Render dashboard
   - Navigate to your Render dashboard
   - The owner ID can be found in your account settings or in the URL when viewing services

## Provider Information

This configuration uses the official Render Terraform provider (`render-oss/render`).

**Note**: The Render Terraform provider is currently in early access, so some attributes may change. If you encounter issues, please check the latest documentation at:

- [Terraform Registry](https://registry.terraform.io/providers/render-oss/render/latest/docs)
- [Render Documentation](https://render.com/docs/terraform-provider)

## Setup

1. **Copy the example variables file**:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit `terraform.tfvars`** with your actual values:
   - `render_api_key`: Your Render API key
   - `owner_id`: Your Render owner/team ID
   - `repo`: Your GitHub repository URL
   - Other configuration as needed

3. **Initialize Terraform**:

   ```bash
   cd terraform
   terraform init
   ```

4. **Review the plan**:

   ```bash
   terraform plan
   ```

5. **Apply the configuration**:
   ```bash
   terraform apply
   ```

## Configuration Options

### Service Plans

- `starter`: Free tier (for development/testing)
- `standard`: Standard tier
- `pro`: Pro tier

### Regions

- `oregon`: US West (Oregon)
- `frankfurt`: EU (Frankfurt)
- `singapore`: Asia Pacific (Singapore)

### Environment Variables

The configuration automatically sets:

- `NODE_ENV`: Set to production by default
- `PORT`: Set to 3001 by default
- `ARCJET_KEY`: Optional, only set if provided

You can add more environment variables by modifying `main.tf`.

## Health Checks

The service is configured to use `/healthz` as the health check endpoint. Make sure your application implements this endpoint (which it does based on the Kubernetes deployment configuration).

## Outputs

After deployment, Terraform will output:

- `service_url`: The public URL of your deployed service
- `service_id`: The Render service ID
- `service_name`: The service name

## Destroying Resources

To remove all resources created by Terraform:

```bash
terraform destroy
```

## Notes

- The service uses Docker deployment (via Dockerfile)
- Auto-deploy is enabled by default when you push to the specified branch
- Make sure your Dockerfile is properly configured (which it is in the root directory)
