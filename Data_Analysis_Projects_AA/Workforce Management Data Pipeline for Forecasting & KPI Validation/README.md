# Workforce Management Data Pipeline for Forecasting & KPI Validation

---

## Disclaimer

This project reflects the type of data automation, data preparation, and KPI validation workflows that I work on in my professional role as an Associate Solutions Engineer – Data Analyst at Aligned Automation Ltd.

The implementation in this repository is a **recreated and generalized version** built strictly for learning, demonstration, and portfolio purposes.

* No proprietary data
* No internal systems
* No client information
* No confidential business logic

All datasets used in this project are either:

* Synthetically generated using external tools (Mockaroo), or
* Sourced from publicly available online resources

This project demonstrates **technical approach, system design, and workflow patterns only**, while fully maintaining organizational data privacy and confidentiality.

---

## Project Overview

This project represents an **enterprise-style Workforce Management (WFM) data pipeline** designed to replicate real-world analytics workflows used for:

* Forecasting preparation
* KPI and SLA validation
* Operational reporting
* Automation readiness

The goal of this project is **not to build a forecasting model** at this stage.

Instead, the goal is to build a **forecasting-ready, SQL-based master dataset** by transforming raw, messy, multi-source WFM operational data into a clean, standardized, and automation-ready form.

---

## Why This Project Exists

In real enterprise WFM environments, the following challenges are very common:

* Data arrives from **multiple sources** (Excel files, tools, systems)

* Queue names are **inconsistent and messy**

* Demand is affected by **country-level holidays**

* Manual Excel-based workflows are:

  * Slow
  * Error-prone
  * Not scalable

* Forecasting and KPI validation require a **trusted historical dataset**

### Problem Statement

> How can raw, messy Workforce Management operational data be converted into a single, standardized, SQL-based dataset that supports forecasting, KPI validation, and automation — without relying on manual Excel processes

---

## What This Project Builds

This project builds a **forecasting-ready, enterprise-grade data pipeline**.

### Final Goal

Produce a **single master WFM dataset and push it to SQL Server using PySpark** that can later be used for:

* Demand forecasting
* SLA and KPI validation
* Power BI dashboards
* Automated weekly data refresh

---

## Technology Stack and Reasoning

* **Python** – Core data processing logic
* **PySpark** – Scalable data ingestion and transformation
* **SQL Server** – System of record and historical storage
* **Mockaroo / Excel** – Synthetic data generation and input simulation
* **Web Scraping** – Public holiday reference data
* **Power BI** – Reporting and visualization (future stage)

---

## Data Sources Used

### 1. Synthetic Operational Data (Mockaroo)

🔗 https://www.mockaroo.com/

* Multi-column WFM-style dataset
* Simulates real contact center operations
* Includes volumes, channels, queues, and performance metrics

Purpose:

* Replicate real enterprise input data
* Enable pipeline testing and transformation logic

---

### 2. Holiday Data (Web Scraping)

🔗 https://www.timeanddate.com/holidays/

* Global public holiday data
* Multiple countries
* Multi-year coverage
* Scraped using Python (BeautifulSoup) and stored as a reusable dataset

---

## Holiday Data Integration Workflow

Holiday data is prepared as a **one-time preprocessing step** and stored as a reference dataset.

During pipeline execution:

1. Holiday dataset is loaded into the processing environment
2. A left join is performed with the main dataset using:

```
Date + Country
```

3. The following columns are added:

* Is_Holiday (0 = No, 1 = Yes)
* Holiday_Name
* Holiday_Type

This enrichment helps explain demand variations, improves KPI interpretation, and supports forecasting adjustments.

---

## Web Scraping Implementation Notes

* Data is scraped using:

```python
requests
BeautifulSoup
pandas
```
For year 2021-2040 for 52 countries


---

### 3. Business Queue and KPI Logic

Enterprise WFM systems rely on:

* Canonical queue structures
* Business unit groupings
* Tier-based SLA logic

Applied using:

* Fuzzy matching
* Rule-based mappings

---

## Core Transformations (High-Level)

### Queue Standardization

Raw queue names such as:

```
IN_CORE_EMAIL_T2
IN CORE EMAIL TIER2
US_RETAIL_VOICE_T2
```

Are standardized into:

```
Core Email
Retail Voice
```

Using fuzzy matching (`rapidfuzz`).

---

### Business Filters and Tiering

* **All_Units_Filter** – Business grouping
* **Queue_Units_Filter** – Channel grouping
* **ASU_Tier_Filter** – Tier classification

---

### Derived Metrics

Key metrics are computed using business logic:

```
Service_Level = (Handled_Volume / Offered_Volume) * 100
Backlog_Volume = Offered_Volume - Handled_Volume
Planned_Volume = Offered_Volume * 1.05
```

---

## Final Dataset (Locked Schema)

### Table: `wfm_forecasting_base`

Total Columns: **32**

---

### Time Dimension

| Column      |
| ----------- |
| Date        |
| Weekday     |
| Week_Number |
| Month       |
| Year        |
| Hour        |

---

### Geography

| Column  |
| ------- |
| Country |
| Region  |
| Site    |

---

### Queue Metadata

| Column             |
| ------------------ |
| Queue_Name         |
| Channel            |
| All_Units_Filter   |
| Queue_Units_Filter |
| ASU_Tier_Filter    |
| Business_Unit      |

---

### Volume Metrics

| Column           |
| ---------------- |
| Planned_Volume   |
| Offered_Volume   |
| Handled_Volume   |
| Abandoned_Volume |
| Backlog_Volume   |

---

### Performance Metrics

| Column            |
| ----------------- |
| AHT_Seconds       |
| Handle_Time_Total |
| Wait_Time_Avg     |
| Service_Level     |
| ASA_Seconds       |

---

### Workforce Metrics

| Column         |
| -------------- |
| Agent_Count    |
| Active_Agents  |
| Occupancy_Rate |
| Shrinkage_Rate |

---

### Holiday Columns

| Column       |
| ------------ |
| Is_Holiday   |
| Holiday_Name |
| Holiday_Type |

---

## Metadata Tracking (Enterprise Design)

### Table: `processed_files`

| Column              |
| ------------------- |
| file_name           |
| processed_timestamp |

### Logic

* Read files from input folder
* Compare with `processed_files`
* Process only new files
* Log processed files into SQL

---

## Pipeline Structure

```
01_ingestion
02_cleaning
03_queue_standardization
04_feature_engineering
05_sql_ingestion
06_kpi_validation
powerbi
```

---

## SQL Server Role

SQL Server acts as the **system of record**:

* Stores historical data (append-only)
* Supports KPI validation queries
* Enables reporting via Power BI
* Tracks processed file metadata

---

## Automation Design

The pipeline is designed for **automated execution**:

* Reads new files dynamically
* Applies transformation logic
* Loads into SQL Server
* Supports scheduled execution (weekly refresh)

---

## Final Pipeline Flow

```
Mockaroo / Excel Files
        ↓
PySpark Ingestion
        ↓
Metadata Tracking (SQL)
        ↓
Data Cleaning
        ↓
Fuzzy Queue Standardization
        ↓
Holiday Data Join (Date + Country)
        ↓
Feature Engineering
        ↓
SQL Server (wfm_forecasting_base)
        ↓
KPI Validation
        ↓
Power BI
```

---

## Outcome

This project demonstrates:

* End-to-end ETL pipeline design
* Data cleaning and transformation
* Synthetic data simulation
* KPI validation logic
* Holiday-based demand enrichment
* Scalable data processing using PySpark
* Real-world WFM data engineering concepts

---
