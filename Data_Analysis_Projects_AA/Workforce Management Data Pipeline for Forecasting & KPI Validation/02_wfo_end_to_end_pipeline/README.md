# WFO End-to-End Data Pipeline

## Overview

This project simulates a real-world Workforce Management (WFO) data pipeline where raw operational data is transformed into a structured, consistent, and analysis-ready dataset.

The pipeline focuses on applying business rules, correcting inconsistencies, and preparing data for reporting, forecasting, and workforce planning.

This implementation is built as a **single end-to-end pipeline script/notebook**, where all steps are executed sequentially.

Mock data generation is handled separately. This pipeline starts after data generation.

---

## Objectives

* Standardize and clean raw WFO data
* Apply real-world business rules used in operations
* Remove inconsistencies across multiple data sources
* Standardize queue names for accurate aggregation
* Prepare dataset for downstream analytics
* Maintain auditability by preserving original data

---

## Project Structure

```id="finalproj2"
WFO_Project/
│
├── 01_data_preparation.py              # Logical corrections (already completed)
├── 02_wfo_end_to_end_pipeline.py       # FINAL PIPELINE (all steps combined)
│
├── data/
│   ├── merged_wfo_data.csv
│   └── wfo_data.csv
│
└── README.md
```

---

## Pipeline Flow

```id="flowfinal2"
Raw Data 
   ↓
Logical Corrections (Pre-done)
   ↓
Data Inspection
   ↓
Data Cleaning & Standardization
   ↓
Queue Standardization
   ↓
(Next: Feature Engineering, SQL, KPI Validation)
```

---

# Data Processing Approach

Two datasets are maintained:

* **df (Original Data)**
  Used only for validation and comparison

* **df_wk (Working Data)**
  All transformations are applied here

This ensures traceability and auditability.

---

# Step 1: Data Inspection

## Purpose

To understand the dataset before applying any transformations.

## What was done

* Viewed sample records (`head`)
* Checked structure (`info`)
* Verified column names
* Checked null values
* Inspected unique values in key columns

## Why

* Prevent incorrect assumptions
* Identify inconsistencies early

## Business Rule Alignment

* Data must be understood before applying transformations

---

# Step 2: Data Cleaning and Standardization

## 2.1 Column Renaming

### What

All columns were renamed to follow business naming standards.

### Rules Applied

* First letter capital
* Words separated using underscore

### Why

* Ensures consistency across systems
* Improves readability and usability

### Business Rules Applied

* Standard naming convention must be followed

---

## 2.2 Date Standardization

### Problem

* Date column stored as string
* Format inconsistency possible

### What

* Converted Date to datetime format

### Why

* Required for time-based operations
* Enables filtering, grouping, and trend analysis

### Business Rules Applied

* Date must be in consistent format across dataset

---

## 2.3 String Standardization

### Problem

* Inconsistent casing
* Extra spaces

### What

* Trimmed spaces
* Converted values to uppercase

### Columns Covered

* Country
* Region
* Site
* Queue_Name
* Channel
* Business_Unit
* Filters

### Business Rules Applied

* Same values must not appear in multiple formats
* Avoid duplication caused by formatting differences

---

## 2.4 Data Validation

### Problem

Logical inconsistencies in numerical data

### What

Validated:

* Handled_Volume ≤ Offered_Volume
* No negative values

### Why

* Ensure data correctness

### Business Rules Applied

* Volume relationships must be logically valid
* Invalid data should not be used in analysis

---

# Step 3: Queue Standardization

## Purpose

To standardize queue names for accurate aggregation and analysis.

---

## 3.1 Problem Identification

Queue names contain:

* Region prefixes (APAC, EMEA, AMER)
* Operational prefixes (INBOUND, OUTBOUND, CUSTOMER, RETENTION)
* Naming inconsistencies
* Tier variations

---

## 3.2 Queue Core Creation

### What

Created a new column:

```id="corelogic2"
Queue_Core
```

by removing the first segment of Queue_Name.

### Why

* Region does not define service
* Helps isolate actual service

### Business Rules Applied

* Region identifiers must be removed

---

## 3.3 Impact Analysis

### What

Compared:

* Unique Queue_Name
* Unique Queue_Core

### Result

* Reduction in duplicate service representations

### Insight

* Same service existed under multiple region-specific names

---

## 3.4 Fuzzy Matching (Analysis Layer)

### What

* Compared queue names using similarity scores

### Why

* Identify similar queue names

### Important

* Used only for analysis
* Not used for final assignment

### Business Rules Applied

* Similarity ≥ threshold indicates same service

---

## 3.5 Final Standardization (Rule-Based)

### Why

* Fuzzy matching is not deterministic
* Business requires controlled output

### What

Defined standardized queue categories:

```id="buckets2"
VOICE_TIER1
VOICE_TIER2
CHAT_SUPPORT_TIER1
SUPPORT_EMAIL_TIER3
CORE_EMAIL_TIER2
SALES_TIER2
RETAIL_VOICE_TIER2
```

---

## 3.6 Transformation Rules

* Remove region prefixes
* Remove operational prefixes
* Normalize word order
* Normalize tier format

---

## 3.7 Final Output

New column created:

```id="finalcol2"
Queue_Standardized
```

---

## 3.8 Business Rules Applied

* BR-01: Remove region prefixes
* BR-02: Remove operational prefixes
* BR-03: Service identification
* BR-04: Word normalization
* BR-05: Tier normalization
* BR-06: Similar queue grouping
* BR-08: Controlled output buckets
* BR-11: Similarity threshold
* BR-12: Fallback handling


# Step 4: Holiday Data Integration

## Purpose

To enrich the main dataset with holiday information so that business performance can be analyzed in the context of holidays.

---

## What Was Done

A separate holiday dataset was prepared and integrated into the main working dataset (`df_wk`).

The integration was performed using:

- Date
- Country

A left join was used to merge both datasets.

---

## Data Preparation

The holiday dataset was cleaned before merging:

- Selected only required columns:
  - Date
  - Country
  - Holiday_Name

- Renamed column:
  - Name → Holiday_Name

- Standardized country values to match main dataset format

---

## Country Standardization

Country names in `df_wk` were aligned with the holiday dataset.

Examples:

- UNITED STATES → US  
- UNITED KINGDOM → UK  
- NEW ZEALAND → NEW-ZEALAND  
- SOUTH KOREA → SOUTH-KOREA  

This ensured accurate matching during merge.

---

## Merge Logic

The merge was performed using:

- Date
- Country

Join Type: Left Join

### Why Left Join

- Keeps all records from main dataset
- Only adds holiday information
- No data loss

---

## Columns Added

After merging, the following columns were added:

### Holiday_Name

- Contains name of the holiday
- Null if no holiday exists

### Is_Holiday

- Created using Holiday_Name
- 1 → Holiday  
- 0 → Non-holiday  

### Holiday_Type

- Added as a default column
- Value: Public

---

## Code Logic

```python
df_wk = df_wk.merge(
    holiday_df,
    on=['Date', 'Country'],
    how='left'
)

df_wk['Is_Holiday'] = df_wk['Holiday_Name'].notna().astype(int)

df_wk['Holiday_Type'] = 'Public'
````

---

## Validation Performed

* Verified matching records where holiday exists
* Checked non-holiday rows remain unchanged
* Ensured no row duplication
* Confirmed no data loss after merge

---

## Output Behavior

* Holiday rows → Holiday_Name populated, Is_Holiday = 1
* Non-holiday rows → Holiday_Name = NaN, Is_Holiday = 0

---

## Business Impact

* Explains demand spikes and drops during holidays
* Helps in workforce planning and staffing decisions
* Improves KPI interpretation (Service Level, Utilization, AHT)
* Enables better forecasting models

---

## Design Principles Followed

* No modification to original dataset
* All transformations applied on working dataset
* No data loss due to merge
* Fully traceable transformation logic


---

## Summary

Holiday data was successfully integrated into the dataset using controlled transformations and business rules.

The dataset is now enriched with holiday context and ready for advanced analytics and forecasting.



# Next Steps (Planned)

## Feature Engineering

* Create derived fields required for analytics
* Prepare dataset for aggregation and reporting

---

## SQL Ingestion

* Load cleaned data into SQL Server
* Ensure schema consistency

---

## KPI Validation

* Validate Service Level, AHT, Occupancy, Utilization
* Ensure business logic correctness


---

### Dashboard / Analytics

* Build reporting layer (Power BI / Tableau)


# Key Design Principles

* Original dataset is preserved
* Transformations applied only on working dataset
* No unnecessary data deletion
* All steps are traceable and explainable

---


# Business Impact

* Eliminates duplicate queue definitions
* Ensures accurate aggregation
* Improves reporting consistency
* Prepares data for forecasting and workforce planning

---

# Conclusion

This pipeline transforms raw WFO data into a structured and standardized dataset using business rules and controlled transformations.

It ensures consistency, accuracy, and readiness for analytics while maintaining full traceability.

