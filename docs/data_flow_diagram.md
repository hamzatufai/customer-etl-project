# Data Flow Architecture

How customer data moves through the pipeline, technology by technology.

## 1. High-Level Data Flow

```
 CSV File ──▶ AWS S3 ──▶ Snowflake RAW ──▶ dbt ──▶ MART ──▶ Analytics
 (source)    (landing)     (RAW_CUSTOMERS)  (3 models)  (DIM_CUSTOMERS)  (BI / SQL)
```

## 2. Detailed Flow (Mermaid)

> Renders on GitHub and in VS Code's Markdown preview.

```mermaid
flowchart TD
    CSV["📄 AdventureWorks Customers CSV<br/>~18.1K rows · dbt/seeds/"]

    subgraph AWS["☁️ AWS"]
        BUCKET["🪣 S3 Bucket<br/>customer-data-bucket-2026<br/>data/customers/"]
        IAM["🔐 IAM Role + Policy<br/>snowflake_role<br/>(S3 read-only for Snowflake)"]
    end

    subgraph SNOWFLAKE["❄️ Snowflake · ETL_PROJECT_DB · Warehouse ETL_WH"]
        STAGE["📁 RAW.S3_STAGE<br/>+ CSV_FORMAT"]
        RAW["🗄️ RAW.RAW_CUSTOMERS<br/>landing table (18,148 rows)"]
        STG["👁️ STAGING.STG_CUSTOMERS<br/>view (cleaning/rename)"]
        INT["⚙️ INTERMEDIATE.INT_CUSTOMER_ENRICHED<br/>ephemeral (age, income bracket)"]
        MART["📊 MART.DIM_CUSTOMERS<br/>table (segments)"]
        TESTS["✅ dbt tests<br/>13/13 passing"]
    end

    BI["📈 Analytics / BI / validations.sql"]

    CSV -- "aws s3 cp" --> BUCKET
    BUCKET -- "COPY INTO via stage" --> STAGE
    STAGE --> RAW
    RAW -- "source('raw_data')" --> STG
    STG -- "ref()" --> INT
    INT -- "ref()" --> MART
    MART --> BI
    TESTS -.-> STG
    TESTS -.-> INT
    TESTS -.-> MART
    IAM -.->|trust relationship| BUCKET
    STAGE -.->|uses integration| IAM
```

## 3. Terraform Control Plane (provisions everything above)

Terraform doesn't touch the data itself — it owns the objects the data flows through:

```mermaid
flowchart LR
    TF["🛠️ Terraform<br/>terraform/"]

    subgraph AWS["☁️ AWS"]
        BUCKET["S3 Bucket"]
        IAM["IAM Role + Policy"]
    end

    subgraph SNOWFLAKE["❄️ Snowflake"]
        DB["Database<br/>ETL_PROJECT_DB"]
        SCH["Schemas<br/>RAW / STAGING /<br/>INTERMEDIATE / MART"]
        WH["Warehouse<br/>ETL_WH"]
        INTEG["Storage Integration<br/>S3_INTEGRATION"]
        OBJ["Stage + File Format<br/>s3_stage · csv_format"]
        ROLE["ETL_ROLE<br/>+ grants"]
    end

    TF --> BUCKET
    TF --> IAM
    TF --> DB
    TF --> SCH
    TF --> WH
    TF --> INTEG
    TF --> OBJ
    TF --> ROLE
    INTEG -.->|trusts| IAM
```

## 4. Alternative Path — Manual SQL Scripts (no dbt)

`snowflake_queries/` provides a parallel load path managed by hand. **Run these before dbt** — they `CREATE OR REPLACE` the mart table with a different schema:

```mermaid
flowchart LR
    RAW["RAW.RAW_CUSTOMERS"] --> STREAM["RAW_CUSTOMERS_STREAM<br/>(append-only)"]
    STREAM --> PROC["STAGING.PROCESS_CUSTOMERS()<br/>stored procedure"]
    TASK["PROCESS_CUSTOMERS_TASK<br/>(scheduled task)"] -.->|calls when stream has data| PROC
    PROC --> STG["STAGING.STG_CUSTOMER"]
    PROC --> MART2["MART.DIM_CUSTOMERS<br/>(income-based segments ⚠️)"]
```

⚠️ This table is periodically overwritten by dbt's `dim_customers` (homeowner-based segments). Order matters: **SQL scripts first, dbt last.**

## 5. End-to-End Sequence (one full run)

```mermaid
sequenceDiagram
    participant E as Engineer
    participant S3 as AWS S3
    participant SF as Snowflake
    participant D as dbt

    E->>S3: aws s3 cp adventure_works_customers.csv
    SF->>S3: read via S3_INTEGRATION (IAM trust)
    SF->>SF: COPY INTO RAW.RAW_CUSTOMERS (18,148 rows)
    D->>SF: build STAGING.STG_CUSTOMERS (view)
    D->>SF: build MART.DIM_CUSTOMERS (table, int inlined)
    D->>SF: run 13 tests (unique, not_null, accepted_values)
    SF-->>E: ✅ all green
```

## Technology Roles Summary

| Technology | Role | Key Objects |
|---|---|---|
| **CSV file** | Data source | `dbt/seeds/adventure_works_customers.csv` |
| **AWS S3** | Raw storage / landing zone | `customer-data-bucket-2026` |
| **AWS IAM** | Access control for Snowflake | `snowflake_role` + S3 policy |
| **Terraform** | Infrastructure as Code (provisioning only) | DB, 4 schemas, warehouse, integration, stage, file format, ETL_ROLE |
| **Snowflake** | Data warehouse: landing + compute | `RAW.RAW_CUSTOMERS`, `ETL_WH` |
| **dbt** | Transformation + data quality tests | `stg_customers` → `int_customer_enriched` → `dim_customers` |
| **SQL scripts** | Alternative manual path + validation queries | `setup.sql`, `procedures.sql`, `validations.sql` |
