#!/bin/bash

# Commit changes to GitHub
echo "Committing changes to GitHub with commit message: $2"
git add .
git commit -m "$2"
git tag -a $1 HEAD -m "$2"
git push

# Create GitHub release
echo "Creating GitHub release"
GH_TOKEN=$(cat ~/Downloads/github-token.txt)
GH_REPO="rhysctf/devopsblog"
GH_API="https://api.github.com/repos/$GH_REPO"
TAG_NAME="$1"
curl -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: token $GH_TOKEN" \
    -d "{\"tag_name\": \"$TAG_NAME\"}" \
    "$GH_API/releases"

# Build new Docker Image
echo "Building new Docker Image with Image Tag: $1"
docker build -t rhys7homas/devopsblog-image:$1 .
docker push rhys7homas/devopsblog-image:$1

# Initialize Terraform
echo "Initializing Terraform"
terraform init

# Provision infrastructure using Terraform
echo "Provisioning infrastructure using Terraform"
terraform apply -auto-approve

# Extract public IP of the EC2 instance
echo "Extracting public IP of the EC2 instance"
EC2_PUBLIC_IP=$(terraform output -json | jq -r '.ec2_instance_public_ip.value')

# Wait for SSH to be available
echo "Waiting for SSH to be available"
until ssh -i ~/Downloads/devops.pem ec2-user@"$EC2_PUBLIC_IP" exit; do
    echo "SSH is not available yet. Waiting..."
    sleep 5
done

# Run Ansible playbook to configure the EC2 instance
echo "Running Ansible playbook to configure the EC2 instance"
ansible-playbook -i "$EC2_PUBLIC_IP," -u ec2-user --private-key=~/Downloads/devops.pem playbook.yml

# Clean up Terraform resources
echo "Destroying Terraform resources"
terraform destroy -auto-approve

echo "Done"

# ./build.sh v1.0.0 "this is the github commit code"