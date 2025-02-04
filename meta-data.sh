METADATA_URL="http://169.254.169.254/latest/meta-data"
OUTPUT_FILE="instance_metadata.txt"
S3_BUCKET="s3://applicant-task/r5d4/"
IAM_ROLE="r5d4-role"

# Pobieranie metadanych
INSTANCE_ID=$(curl -s $METADATA_URL/instance-id)
PUBLIC_IP=$(curl -s $METADATA_URL/public-ipv4)
PRIVATE_IP=$(curl -s $METADATA_URL/local-ipv4)
SECURITY_GROUPS=$(curl -s $METADATA_URL/network/interfaces/macs/$(curl -s $METADATA_URL/mac)/security-groups)
OS_INFO=$(cat /etc/os-release | grep -E "NAME|VERSION" | tr '\n' ' ')
USERS=$(cat /etc/passwd | grep -E "/bin/bash|/bin/sh" | cut -d':' -f1)

# Zapis danych do pliku
echo "Instance ID: $INSTANCE_ID" > $OUTPUT_FILE
echo "Public IP: $PUBLIC_IP" >> $OUTPUT_FILE
echo "Private IP: $PRIVATE_IP" >> $OUTPUT_FILE
echo "Security Groups: $SECURITY_GROUPS" >> $OUTPUT_FILE
echo "Operating System: $OS_INFO" >> $OUTPUT_FILE
echo "Users with bash/sh access: $USERS" >> $OUTPUT_FILE

# Przesyłanie do S3
aws s3 cp $OUTPUT_FILE $S3_BUCKET

# Informacja o zakończeniu
echo "Meta-data have been saved to $OUTPUT_FILE and sent to S3 bucket"
