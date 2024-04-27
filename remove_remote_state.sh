this_bucket="terraform-remote-state-pb0005888"
log_file="../../deletion_log.txt"

if [[ ! -d "modules/s3_backend" ]]; then
  echo "Backend S3 Modules directory not found"
  exit 1
fi

# Terraform destroy, doesn't delete the bucket
cd modules/s3_backend
terraform destroy -auto-approve
cd ../..
ln -sf main.tf.default main.tf

# Errors on execution of Deleting object versions
echo "DONT WORRY ABOUT THIS: 'Error: deleting S3 Bucket'"
echo "Or this: jq: error (at <stdin>:1):"

# Deleting object versions
echo "Deleting object versions..." >> "$log_file"
aws s3api list-object-versions --bucket "$this_bucket" \
--query 'Versions[].{Key:Key,VersionId:VersionId}' --output json | \
jq -c '.[]' | while read -r obj; do
    key=$(echo $obj | jq -r .Key)
    versionId=$(echo $obj | jq -r .VersionId)
    echo "Deleting $key with version $versionId" >> "$log_file"
    aws s3api delete-object --bucket "$this_bucket" --key "$key" --version-id "$versionId" >> "$log_file" 2>&1
done

# Deleting delete markers
echo "Deleting delete markers..." >> "$log_file"
aws s3api list-object-versions --bucket "$this_bucket" \
--query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output json | \
jq -c '.[]' | while read -r obj; do
    key=$(echo $obj | jq -r .Key)
    versionId=$(echo $obj | jq -r .VersionId)
    echo "Deleting delete marker for $key with version $versionId" >> "$log_file"
    aws s3api delete-object --bucket "$this_bucket" --key "$key" --version-id "$versionId" >> "$log_file" 2>&1
done

echo "Removing bucket..." >> "$log_file"
aws s3 rb s3://$this_bucket --force >> "$log_file" 2>&1
