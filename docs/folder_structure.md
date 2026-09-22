# Folder Structure

```
snowflake-etl-project/
│
├── terraform/                          # Infrastructure as Code
│   ├── provider.tf                    # Snowflake provider setup
│   ├── main.tf                        # Core resources (DB, schemas, warehouse)
│   ├── variables.tf                   # Configurable input variables
│   ├── outputs.tf                     # Output values after apply
│   └── terraform.tfvars.example       # Example variable values
│
├── dbt/                                # Data Transformation Layer
│   ├── dbt_project.yml                # dbt project configuration
│   ├── profiles.yml                   # Connection profiles for environments
│   │
│   └── models/
│       ├── staging/                    # Stage 1: Raw data cleaning
│       │   ├── _staging__sources.yml  # Source definitions
│       │   └── stg_customers.sql      # Customer staging model
│       │
│       ├── intermediate/              # Stage 2: Business logic
│       │   └── int_customer_enriched.sql  # Enriched customer data
│       │
│       └── mart/                      # Stage 3: Analytics-ready
│           └── dim_customers.sql      # Customer dimension table
│
├── snowflake_queries/                  # SQL Scripts
│   ├── setup.sql                      # Initial Snowflake setup
│   ├── procedures.sql                 # Stored procedures
│   └── validations.sql                # Data quality checks
│
├── docs/                               # Documentation
│   ├── folder_structure.md            # This file
│   └── running_commands.md            # Command reference
│
├── .env.example                       # Environment variables template
├── .gitignore                         # Git ignore rules
└── README.md                          # Project overview
```

## Directory Descriptions

### `/terraform`
Contains all Terraform configuration files for provisioning Snowflake infrastructure including databases, schemas, warehouses, stages, and storage integrations.

### `/dbt`
dbt project for data transformations. Models are organized in three layers:
- **staging**: Direct mappings from source tables with minimal transformations
- **intermediate**: Business logic and calculated fields
- **mart**: Final analytics-ready tables

### `/snowflake_queries`
SQL scripts for Snowflake operations, stored procedures, and data quality validations.

### `/docs`
Project documentation including this structure guide and command references.
