# Export credentials and settings for AWS provider
echo "Fetching AWS credentials and settings..."
export AWS_ACCESS_KEY_ID=$( \
    cat setup/config/credentials.json \
    | jq --raw-output '.aws.access_key_id')
export AWS_SECRET_ACCESS_KEY=$( \
    cat setup/config/credentials.json \
    | jq --raw-output '.aws.secret_access_key')
export AWS_DEFAULT_REGION=$( \
    cat setup/config/settings.json \
    | jq --raw-output '.aws.default_region')

# Check if env variables are set to example values
echo "Checking if AWS credentials settings and settings have been configured..."
if [[ $AWS_ACCESS_KEY_ID = "<YOUR_ACCESS_KEY_ID>" ]] \
    && [[ $AWS_SECRET_ACCESS_KEY == "<YOUR_SECRET_ACCESS_KEY>" ]] \
    && [[ $AWS_DEFAULT_REGION == "<YOUR_DEFAULT_REGION>" ]]; then
    # Check if dev configs exist
    if [[ -f "private_local/config/credentials.json" ]] \
        && [[ -f "private_local/config/settings.json" ]]; then
        # Set env variables from dev configs
        export AWS_ACCESS_KEY_ID=$( \
            cat private_local/config/credentials.json \
            | jq --raw-output '.aws.access_key_id')
        export AWS_SECRET_ACCESS_KEY=$( \
            cat private_local/config/credentials.json \
            | jq --raw-output '.aws.secret_access_key')
        export AWS_DEFAULT_REGION=$( \
            cat private_local/config/settings.json \
            | jq --raw-output '.aws.default_region')
        echo "Using dev credentials and settings"
    # Instruct user to populate config fields and exit
    else
        echo "Credentials and/or settings not configured"
        echo "Please enter your own personal AWS credentials and settings in the appropriate locations in accordance with the README"
        echo "Quitting..."
        exit
    fi
fi

echo "Initializing Terraform configuration..."
terraform init setup/terraform
# terraform plan setup/terraform
terraform apply setup/terraform

# Retain empty line at end of file
