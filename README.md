# Snowflake ETL Project

A complete ETL pipeline using Terraform, dbt, and Snowflake for AdventureWorks customer data.

## Architecture

```
[Data Source] → [S3] → [Snowflake RAW] → [dbt Models]
     ↓           ↓           ↓               ↓
  CSV File    S3 Stage    Staging Layer    Mart Layer
```

## Project Structure

```
snowflake-etl-project/
├── terraform/                 # Infrastructure as Code
│   ├── provider.tf           # Snowflake provider configuration
│   ├── main.tf              # Database, schemas, warehouse resources
│   ├── variables.tf         # Input variables
│   ├── outputs.tf           # Output values
│   └── terraform.tfvars.example
├── dbt/                      # Data transformation
│   ├── dbt_project.yml      # Project configuration
│   ├── profiles.yml         # Connection profiles
│   └── models/
│       ├── staging/         # Raw data cleaning
│       ├── intermediate/    # Business logic
│       └── mart/            # Final tables
├── snowflake_queries/        # SQL scripts
│   ├── setup.sql            # Initial setup
│   ├── procedures.sql       # Stored procedures
│   └── validations.sql      # Data quality checks
├── docs/                     # Documentation
├── .env.example             # Environment template
└── .gitignore
```

## Quick Start

### Prerequisites

- Terraform 1.0+
- dbt-core with Snowflake adapter
- Snowflake account
- AWS account (for S3)

### 1. Environment Setup

```bash
cp .env.example .env
# Edit .env with your credentials
```

### 2. Infrastructure (Terraform)

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 3. Upload Data to S3

Upload `AdventureWorks_Customers.csv` to your S3 bucket.

### 4. Load Data into Snowflake

```bash
snowsql -a YOUR_ACCOUNT -u YOUR_USER -d ETL_PROJECT_DB -f snowflake_queries/setup.sql
snowsql -a YOUR_ACCOUNT -u YOUR_USER -d ETL_PROJECT_DB -f snowflake_queries/procedures.sql
```

### 5. Run dbt Models

```bash
cd dbt
dbt deps
dbt seed
dbt run
dbt test
```

## Data Source

AdventureWorks Customers dataset with fields:
- CustomerKey, Prefix, FirstName, LastName
- BirthDate, MaritalStatus, Gender
- EmailAddress, AnnualIncome, TotalChildren
- EducationLevel, Occupation, HomeOwner

## dbt Models

| Layer | Model | Description |
|-------|-------|-------------|
| Staging | `stg_customers` | Cleaned and standardized raw data |
| Intermediate | `int_customer_enriched` | Enriched with age, income brackets |
| Mart | `dim_customers` | Final dimension table with segments |
