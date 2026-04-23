

![Python](https://img.shields.io/badge/Python-3.12-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-blue)
![dbt](https://img.shields.io/badge/dbt-1.11.8-orange)
![Docker](https://img.shields.io/badge/Docker-29.4.0-blue)

## Author
Built by Benas Baranovskis — https://www.linkedin.com/in/bbaranovskis/

# Maven Toys Stores — Sales Data Analytics

> **GitHub Repository:** https://github.com/BenatrixB/data-portfolio-projects

## Description
This project builds a full end-to-end data pipeline for Maven Toys — a 
fictional Mexican toy store chain with 50 stores across 29 cities. Raw 
sales data covering January 2022 to September 2023 is ingested into 
PostgreSQL, transformed using dbt, and analysed to uncover revenue trends, 
product performance, store efficiency, and inventory risk.

## Tech Stack
- **Python** — data ingestion scripts (pandas, SQLAlchemy)
- **PostgreSQL** — local database hosting
- **dbt** — data modelling (staging → intermediate → marts)
- **Power BI / Excel** — visualisations
- **PowerPoint / PDF** — final report 

## Project limitation
We do not have store operating cost data, therefore some business decision proposals might be adjusted.

## Data Source
Data sourced from [Maven Analytics](https://www.mavenanalytics.io/) — free to use for personal and portfolio projects.

The dataset contains 5 tables:

| Table | Description | Rows |
|-------|-------------|------|
| sales | Individual transactions across all stores | 829,262 |
| products | Product catalogue with cost and price | 35 |
| stores | Store details including city and location type | 50 |
| inventory | Current stock on hand per store/product | 1,593 |
| calendar | Date spine from Jan 2022 to Sep 2023 | 638 |

## Project Structure
```
maven_toys_analytics/
├── data/                        ← raw CSV files (not tracked in git)
├── scripts/
│   └── loader.py                ← Python ingestion script (CSV → PostgreSQL)
├── sql/
│   ├── raw_schema_table_creation.sql  ← DDL for raw schema and tables
│   ├── load_validation.sql            ← post-load sanity checks
│   ├── metric_01_revenue_by_month.sql
│   ├── metric_02_top10_products_by_profit.sql
│   ├── metric_03_store_performance_by_location.sql
│   ├── metric_04_city_performance.sql
│   └── metric_05_inventory_risk.sql
├── deliverables/
│   ├── maven_toys_report.pptx   ← PowerPoint report
│   ├── maven_toys_report.pdf    ← PDF version
│   └── maven_toys_dashboard.pbix ← Power BI dashboard
└── maven_toys_dbt/
    ├── dbt_project.yml          ← dbt project config
    ├── models/
    │   ├── staging/             ← stg_* views (one per raw table)
    │   ├── intermediate/        ← int_sales_enriched (joined table)
    │   └── marts/               ← fct_sales (final analytical table)
    └── tests/
        └── schema.yml           ← dbt data quality tests
```

## Deliverables

| Deliverable | Description |
|-------------|-------------|
| `deliverables/maven_toys_report.pptx` | PowerPoint report with key findings and business recommendations |
| `deliverables/maven_toys_report.pdf` | PDF version of the report |
| `deliverables/maven_toys_dashboard.pbix` | Power BI dashboard (requires Power BI Desktop) |
| `maven_toys_dbt/` | Full dbt project with staging, intermediate and mart models |
| `scripts/loader.py` | Python ingestion script |
| `sql/` | Business metric queries |

## Key Findings

### Revenue & Profitability
- Total revenue across all stores: **$14.4M** (Jan 2022 — Sep 2023)
- **December 2022** was the strongest month at $877k revenue — clear Christmas seasonality
- Revenue grew consistently into 2023, with Q1 2023 averaging $784k/month vs $558k in Q1 2022

### Product Performance
- **Colorbuds** is the standout product — $834k total profit with a 45.86% margin
- Electronics category has the highest average margin (45.86%) despite being 2nd in total revenue
- **Toys** leads in total revenue ($5.09M) but has the lowest margin (25.05%)

### Store Performance
- **Airport stores** generate the highest average revenue per store ($429k) despite only 3 locations
- **Ciudad de Mexico** is the top performing city with $1.64M total revenue across 4 stores
- **Toluca and Xalapa** are hidden gems — 2 stores each but competing with 4-store cities on per-store revenue

### Inventory Risk
- **Action Figure and Colorbuds** are critically low — only 0.2 months of stock remaining
- All top 10 best-selling products have less than 0.5 months of stock
- Immediate restocking recommended for top sellers before next peak season

### Prerequisites
- Python 3.12
- Docker Desktop (recommended) OR PostgreSQL 14+ (local)
- dbt-postgres 1.7+

## Docker Setup

The project includes a `docker-compose.yml` file to run PostgreSQL in a container — no local PostgreSQL installation needed.

### Start the database
```bash
docker-compose up -d
```

### Stop the database
```bash
docker-compose down
```

### Connection details
- Host: `localhost`
- Port: `5433`
- Database: `maven_toys`
- User: `postgres`
- Password: `postgres`

## How to Run It

### Prerequisites
- Python 3.12
- Docker Desktop
- dbt-postgres 1.7+

### 1 — Clone the repository
```bash
git clone https://github.com/BenatrixB/data-portfolio-projects.git
cd maven_toys_analytics
```

### 2 — Add the CSV data files
Place the Maven Toys CSV files in the `data/` folder:
- sales.csv
- products.csv
- stores.csv
- inventory.csv
- calendar.csv

Data source: [Maven Analytics](https://www.mavenanalytics.io/)

### 3 — Run the full pipeline
```bash
docker-compose up --build
```

This single command will:
- Start PostgreSQL in a container
- Load all CSV data into the database
- Run all dbt models (staging → intermediate → marts)

### 4 — Connect to the database
- Host: `localhost`
- Port: `5433`
- Database: `maven_toys`
- User: `postgres`
- Password: `postgres`

### 5 — Run dbt tests
```bash
cd maven_toys_dbt
dbt test
```
All 13 tests should pass.