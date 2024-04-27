if [[ -d "modules/s3_backend" ]]; then
  cd modules/s3_backend
  terraform destroy -auto-approve
  cd ../..
  ln -sf main.tf.default main.tf
fi
