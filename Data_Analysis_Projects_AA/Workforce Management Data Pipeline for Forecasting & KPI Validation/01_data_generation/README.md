# WFO Data Pipeline (Mock Data Preparation)

## Overview

After generating data from Mockaroo, we performed a series of structured steps in VS Code to make the dataset logically correct and usable.

Important:
- This phase is only for logical correction after data generation from Mockaroo
- No heavy data cleaning or deletion was done
- We only corrected logical inconsistencies
- All corrections were based on business logic (Date, Queue, Region, etc.)
- Actual data cleaning is still pending and will be handled in a separate step

---

## Requirements (What we wanted to achieve)

From the raw Mockaroo data, we identified the following issues:

- Date-related columns (Weekday, Month, Year, Week_Number) were random
- Queue_Units_Filter was incorrect (static / wrong values)
- Country, Region, and Site were not aligned
- Queue_Name had incorrect or mismatched geo prefixes
- Multiple files needed to be merged into one dataset

Goal:
- Make data logically consistent
- Keep structure intact
- Prepare dataset for analytics (no deletion, only correction)

---

## Step 1: Merge Multiple Files (One-Time Process)

We had multiple CSV files generated from Mockaroo.

What we did:
- Read all WFO CSV files from folder
- Validated schema (all columns must match)
- Appended all files into one dataset
- Validated row counts (no data loss)

Output:
- `merged_wfo_data.csv`

Note:
- This was a one-time process done only to increase data volume

---

## Step 2: Fix Date-Based Columns

Problem:
- Weekday, Week_Number, Month, Year were random

Solution:
- Used Date column as source of truth
- Recalculated:
  - Weekday
  - Week_Number
  - Month
  - Year

Validation:
- No null values
- Row count unchanged
- Values successfully updated

Output:
- `wfo_data.csv`

---

## Step 3: Set Queue Units Based on Queue Name

Problem:
- Queue_Units_Filter had incorrect/static values

Solution:
- Derived Queue_Units_Filter from Queue_Name using business logic

Examples:
- INBOUND → Inbound
- OUTBOUND → Outbound
- TECH → Tech Support
- SALES → Sales
- SUPPORT → Support

Validation:
- No null values
- Proper distribution of categories

---

## Step 4: Fix Country, Region, and Site (Geographic Alignment)

Problem:
- Country, Region, and Site were randomly assigned
- Example: Country = India, Region = AMER (wrong)

Solution:
- Mapped Country → Region (APAC, EMEA, AMER)
- Assigned Site based on Country
- Used fallback for missing mappings (e.g., "Country Hub")

Result:
- All geographic fields are now consistent

---

## Step 5: Fix Queue Name Prefix Using Region

Problem:
- Queue_Name had incorrect geo prefixes

Example:
- APAC_CHAT_SUPPORT_T1 but Country = Sweden (EMEA)

Solution:
- Checked prefix of Queue_Name
- Replaced it with correct Region value
- Restored original underscore format

Example:
- APAC_CHAT_SUPPORT_T1 → EMEA_CHAT_SUPPORT_T1

Validation:
- Rows updated successfully
- No format issues
- Prefix now matches Region

---

## Final Output

Final dataset:
- `wfo_data.csv`

This dataset is now:
- Structurally consistent
- Logically correct
- Ready for analysis / dashboard / SQL

---

## Key Notes

- This phase only focuses on logical correction of Mockaroo-generated data
- No data was deleted
- No aggressive cleaning was done
- Only logical corrections were applied
- Original structure is preserved
- Actual data cleaning is still pending and will be performed separately

---

## Next Steps (Future Work)

- Data cleaning (handling inconsistencies, standardization improvements)
- KPI validation (Service Level, AHT, etc.)
- SQL Server ingestion
- Power BI dashboard creation
