# ⚡ End-to-End Cloud ELT Pipeline: AWS S3 &bull; Snowflake &bull; dbt

[![dbt](https://img.shields.io/badge/dbt-Core%20%7C%20Cloud-FF694B?style=for-the-badge&logo=dbt&logoColor=white)](https://www.getdbt.com/)
[![Snowflake](https://img.shields.io/badge/Snowflake-Data%20Cloud-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)](https://www.snowflake.com/)
[![AWS S3](https://img.shields.io/badge/AWS-S3%20Data%20Lake-569A31?style=for-the-badge&logo=amazons3&logoColor=white)](https://aws.amazon.com/s3/)
[![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

An enterprise-grade, end-to-end cloud ELT data pipeline implementing the **Medallion Architecture** (Bronze &rarr; Silver &rarr; Gold) for property listings and booking analytics using **AWS S3**, **Snowflake Data Cloud**, and **dbt (data build tool)**.

---

## 🏗️ Architecture & Data Flow

```
+------------------+      +-------------------+      +-------------------------------------------+
|  Source Data     | ---> |   AWS S3 Bucket   | ---> |          Snowflake Data Warehouse         |
|  (CSV / Parquet) |      |   (Data Lake)     |      |                                           |
+------------------+      +-------------------+      |  +-------------+     +-------------+      |
                                                     |  |   BRONZE    | --> |   SILVER    |      |
                                                     |  |  Raw Data   |     | Cleaned/Cast|      |
                                                     |  +-------------+     +-------------+      |
                                                     |                             |             |
                                                     |                             v             |
                                                     |                      +-------------+      |
                                                     |                      |    GOLD     |      |
                                                     |                      | Marts / OBT |      |
                                                     |                      +-------------+      |
                                                     +-------------------------------------------+
                                                                            |
                                                                            v
                                                                 +--------------------+
                                                                 | BI & Analytics     |
                                                                 | (Power BI/Tableau) |
                                                                 +--------------------+
```

### Pipeline Layers:
1. **Raw Ingestion (AWS S3 &rarr; Snowflake Stage):** Raw transactional data (Bookings, Listings, Hosts) stored securely in S3 buckets and loaded into Snowflake stages.
2. **Bronze Layer (`models/bronze`):** Direct 1:1 raw tables capturing immutable source data with metadata logging (`_ingestion_time`).
3. **Silver Layer (`models/silver`):** Cleaned, deduplicated, and typed data transformations applying business validation rules, column trimming, and standard data types.
4. **Gold Layer (`models/gold`):** Business-ready analytical models, including **Fact Tables**, **One Big Table (OBT)**, and star-schema dimensions for high-performance BI queries.
5. **Snapshots (`snapshots/`):** Slowly Changing Dimensions (**SCD Type 2**) tracking historical state changes for Hosts, Listings, and Bookings over time.

---

## 📂 Project Structure

```
aws-snowflake-dbt-pipeline/
├── aws_snowflake_dbt_project/
│   ├── analyses/                 # Ad-hoc analytical queries and Jinja experiments
│   │   ├── explore.sql
│   │   ├── IF_ELSE.sql
│   │   └── loop.sql
│   ├── macros/                   # Reusable Jinja/SQL macros
│   │   ├── generate_schema_name.sql
│   │   ├── multiply.sql
│   │   ├── tag.sql
│   │   └── trimmer.sql
│   ├── models/                   # dbt transformation models
│   │   ├── source/               # Source definitions and freshness configs
│   │   ├── bronze/               # Raw ingested layer models
│   │   ├── silver/               # Cleansed & validated models
│   │   └── gold/                 # Business-level dimensional & fact models
│   ├── snapshots/                # SCD Type 2 snapshot definitions
│   │   ├── dim_bookings.sql
│   │   ├── dim_hosts.sql
│   │   └── dim_listings.sql
│   ├── tests/                    # Custom singular & generic tests
│   │   └── source_test.sql
│   ├── dbt_project.yml           # Core dbt configuration
│   └── profiles.yml              # Snowflake connection profile template
├── pyproject.toml                # Python project dependencies
├── uv.lock                       # Deterministic lockfile
└── README.md
```

---

## 🛠️ Tech Stack & Features

- **Data Warehouse:** Snowflake (Virtual Warehouses, Multi-cluster compute, Stages, File Formats)
- **Data Transformation:** dbt Core (Jinja templating, Incremental models, Ephemeral CTEs)
- **Data Quality & Testing:** Schema tests (`unique`, `not_null`, `relationships`) and custom SQL assertion tests
- **Package & Env Manager:** `uv` / Python virtual environments

---

## 🚀 Quickstart & Setup

### 1. Prerequisites
- Python `3.11+`
- Active **Snowflake** account with appropriate warehouse and database privileges
- AWS S3 bucket with read access

### 2. Clone Repository & Setup Environment
```bash
git clone https://github.com/naserashraf-alt/aws-snowflake-dbt-pipeline.git
cd aws-snowflake-dbt-pipeline

# Create and activate virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dbt Snowflake adapter
pip install dbt-snowflake
```

### 3. Configure Snowflake Connection
Create or edit `~/.dbt/profiles.yml`:
```yaml
aws_snowflake_dbt_project:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your-snowflake-account-identifier>
      user: <your-username>
      password: <your-password>
      role: <your-role>
      database: <your-database>
      warehouse: <your-warehouse>
      schema: dev
      threads: 4
```

### 4. Run dbt Pipeline
```bash
cd aws_snowflake_dbt_project

# Test connection
dbt debug

# Install dependencies (if any)
dbt deps

# Run snapshots (SCD Type 2)
dbt snapshot

# Run all models (Bronze -> Silver -> Gold)
dbt run

# Execute data quality tests
dbt test

# Generate and view documentation
dbt docs generate
dbt docs serve
```

---

## 🧪 Data Testing & Quality Assurance
- **Source Testing:** Automatic validation of incoming data integrity before bronze transformations.
- **Referential Integrity:** Validating foreign key relationships between bookings, listings, and hosts.
- **Null & Uniqueness:** Ensuring critical keys (e.g. `booking_id`, `listing_id`) are free from duplicates and nulls.

---

## 👤 Author

**Naser Ashraf**
- 🌐 [Portfolio Website](https://naserashraf-alt.github.io/portfolio/)
- 💼 [LinkedIn Profile](https://www.linkedin.com/in/naser-ashraf-742106358)
- 📧 [Email](mailto:naserashraf248@gmail.com)
