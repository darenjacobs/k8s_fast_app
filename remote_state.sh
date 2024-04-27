if [[ -d "modules/s3_backend" ]]; then
  cd modules/s3_backend
  terraform init
  terraform plan
  terraform apply -auto-approve
  cd ../..
  ln -sf main.tf.remote_state main.tf
fi
