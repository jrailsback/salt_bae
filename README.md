# salt_bae
Skeleton Node JS app with basic user auth functionality

## Setup
Install Terraform locally
```sh
brew install terraform
```

Replace AWS credential placeholders in `setup/config/credentials.json` with access key and secret key bearing sufficient permissions to launch an EC2 instance
```
"aws": {
    "access_key_id": "<YOUR_ACCESS_KEY_ID>",
    "secret_access_key": "<YOUR_SECRET_ACCESS_KEY>"
}
```
