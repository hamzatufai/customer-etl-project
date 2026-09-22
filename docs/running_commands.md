# Running Commands Reference

## Terraform Commands

### Initialize Terraform
```bash
cd terraform
terraform init
```

### Plan Infrastructure Changes
```bash
terraform plan
```

### Apply Infrastructure
```bash
terraform apply
```

### Destroy Infrastructure
```bash
terraform destroy
```

### Show Current State
```bash
terraform show
```

## dbt Commands

### Install Dependencies
```bash
cd dbt
dbt deps
```

### Run Seeds (Load CSV Data)
```bash
dbt seed
```

### Run All Models
```bash
dbt run
```

### Run Specific Model
```bash
dbt run --select stg_customers
dbt run --select int_customer_enriched
dbt run --select dim_customers
```

### Run Models by Layer
```bash
dbt run --select staging
dbt run --select intermediate
dbt run --select mart
```

### Run Tests
```bash
dbt test
```

### Run Specific Test
```bash
dbt test --select stg_customers
```

### Generate Documentation
```bash
dbt docs generate
dbt docs serve
```

### Clean Build
```bash
dbt clean
dbt build
```

## Snowflake SQL Commands

### Connect via SnowSQL
```bash
snowsql -a YOUR_ACCOUNT -u YOUR_USER -d ETL_PROJECT_DB
```

### Run Setup Script
```bash
snowsql -a YOUR_ACCOUNT -u YOUR_USER -d ETL_PROJECT_DB -f snowflake_queries/setup.sql
```

### Run Procedures
```bash
snowsql -a YOUR_ACCOUNT -u YOUR_USER -d ETL_PROJECT_DB -f snowflake_queries/procedures.sql
```

### Run Validations
```bash
snowsql -a YOUR_ACCOUNT -u YOUR_USER -d ETL_PROJECT_DB -f snowflake_queries/validations.sql
```

## Git Commands

### Initialize Repository
```bash
git init
git add .
git commit -m "Initial project setup"
```

### Push to Remote
```bash
git remote add origin YOUR_REPO_URL
git push -u origin main
```

## Environment Variables

### Set Variables (Linux/Mac)
```bash
export SNOWFLAKE_ACCOUNT=your_account
export SNOWFLAKE_USER=your_user
export SNOWFLAKE_PASSWORD=your_password
export S3_BUCKET=your_bucket
```

### Set Variables (Windows PowerShell)
```powershell
$env:SNOWFLAKE_ACCOUNT="your_account"
$env:SNOWFLAKE_USER="your_user"
$env:SNOWFLAKE_PASSWORD="your_password"
$env:S3_BUCKET="your_bucket"
```
