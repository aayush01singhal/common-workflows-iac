terraform init `
  -backend-config="subscription_id=$env:BACKEND_SUB_ID" `
  -backend-config="storage_account_name=$env:STG_NAME" `
  -backend-config="container_name=$env:STG_CONT" `
  -backend-config="resource_group_name=$env:RG_NAME" `
  -reconfigure
