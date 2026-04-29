# Maven Toys Stores — Sales Data Analytics

![Python](https://img.shields.io/badge/Python-3.12-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue)
![dbt](https://img.shields.io/badge/dbt-1.11.8-orange)
![Docker](https://img.shields.io/badge/Docker-29.4.0-blue)
![Airflow](https://img.shields.io/badge/Airflow-2.9.0-green)

## Author
Built by Benas Baranovskis — [LinkedIn](https://www.linkedin.com/in/bbaranovskis/)

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
- **Docker** — containerized pipeline (PostgreSQL + loader + dbt)
- **Apache Airflow** — pipeline orchestration (daily scheduling, task monitoring)
- **Power BI / Excel** — visualisations
- **PowerPoint / PDF** — final report

## Project Limitation
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
├── airflow/
│   └── dags/
│       └── maven_toys_pipeline.py  ← Airflow DAG
├── Dockerfile.loader            ← Docker image for Python loader
├── Dockerfile.dbt               ← Docker image for dbt
├── docker-compose.yml           ← Orchestrates all containers
└── maven_toys_dbt/
├── dbt_project.yml          ← dbt project config
├── models/
│   ├── staging/             ← stg_* views (one per raw table)
│   ├── intermediate/        ← int_sales_enriched (joined table)
│   └── marts/ 
|       ├── fct_sales.sql
│       ├── fct_monthly_revenue.sql
│       ├── fct_store_performance.sql
│       ├── fct_product_performance.sql
│       └── fct_inventory_risk.sql              
└── tests/
└── schema.yml           ← dbt data quality tests
```

## Deliverables

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

### Growth Analysis
- **March 2023** highest YoY revenue growth at **+49.88%**
- **July 2023** second highest at **+48.97%** YoY
- All 2023 months show positive YoY growth

### Product Portfolio Analysis
- **Stars** (high revenue + high margin): Colorbuds, Action Figure
- **Cash Cows** (high revenue + low margin): Lego Bricks — pricing opportunity
- **Hidden Gems** (low revenue + high margin): Electronics category
- Revenue does not always equal profit — margin management critical

### Inventory Value at Risk
- **20 out of 35 products** classified as CRITICAL
- **$210,375** of inventory value at critical risk
- Immediate restocking required before December peak

## Docker Setup

### Prerequisites
- Docker Desktop
- Maven Toys CSV files placed in `data/` folder

### Services
- `postgres` — Maven Toys database (port 5433)
- `airflow-db` — Airflow metadata database (port 5434)
- `airflow-webserver` — Airflow UI (port 8080)
- `airflow-scheduler` — DAG scheduler
- `loader` — Python ingestion container
- `dbt` — dbt transformation container

### Run the full pipeline
```bash
docker-compose up --build
```

This single command will:
- Start PostgreSQL and Airflow
- Load all CSV data into the database
- 11 models total (staging + intermediate + 5 mart models)
- 22 data quality tests passing

### Connect to the database
- Host: `localhost`
- Port: `5433`
- Database: `maven_toys`
- User: `postgres`
- Password: `postgres`

## Airflow Orchestration

Once `docker-compose up --build` is running, open:
http://localhost:8080

Login credentials:
- **Username:** `admin`
- **Password:** `admin`

### The DAG — `maven_toys_pipeline`
The pipeline runs daily and consists of 3 tasks in sequence:
run_loader → run_dbt_run → run_dbt_test

- **run_loader** — loads all CSV data into PostgreSQL
- **run_dbt_run** — builds all 7 dbt models (staging → intermediate → marts)
- **run_dbt_test** — runs all 22 data quality tests

To run manually click the **▶ Play** button on the `maven_toys_pipeline` DAG in the Airflow UI.

## How to Run It

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

### 3 — Start the full stack
```bash
docker-compose up --build
```

### 4 — Monitor the pipeline
Open Airflow UI at `http://localhost:8080` and trigger the `maven_toys_pipeline` DAG.

