# Kubernetes FastAPI App


# USER GUIDE

Clone this Repository and run the script:
```console
$ git clone https://github.com/darenjacobs/k8s_fast_app.git
cd k8s_fast_app
vim script.sh

# Change DOCKER_USERNAME to your docker username.
./script.sh
```

TLDR:
The easiest way to deploy the FastAPI App is to [SET GITHUB ACTIONS SECRETS](#set-secrets) and commit to the main branch.


# ABOUT THE FastAPI APP
Written in Python main.py returns the next given Fibonnaci number in a sequence or returns 'not a Fibonacci number':

### PREREQUISITES
- terraform
- jq

### AUTOMATED TESTING
After deployment Terraform will automatically check the status of the service to validate that it returns a 200 response

The ultimate result from Terraform yields the public IP. Execute a cURL command using that IP.
data.http.my_app_service: Reading...
data.http.my_app_service: Read complete after 0s [id=http://PUBLIC_IP/]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
$ curl http://PUBLIC_IP/
{
status: healthy
}

### USE THE APP
After the Terraform deployment is complete, open your web browser.
Enter http://AWS_URL/fibonacci/5


### CI / CD PIPELINE
Any commits to the branch will start the pipeline which will test the app, deploy the app to Docker Hub, create an EKS cluster in AWS Cloud, and deploy the app to the cluster.
After two minutes the cluster will automatically be destroyed.


### SET SECRETS
- AWS_ACCESS_KEY - Access Key ID to service account with permissions to create an EKS cluster
- AWS_SECRET_KEY - Secret Access key to a service account with permissions to create an EKS  cluster
- DOCKER_NAME - flask-app
- DOCKER_USERNAME - your dockerhub username
- DOCKER_PASSWORD - your dockerhub password
