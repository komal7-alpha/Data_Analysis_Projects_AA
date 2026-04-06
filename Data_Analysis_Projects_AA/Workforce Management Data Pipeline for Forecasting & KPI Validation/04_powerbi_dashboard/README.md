# Power BI Dashboard (WFM Analytics)

---

## Overview

This section of the project focuses on building a Power BI dashboard on top of the processed Workforce Management dataset.

The data used here is already cleaned, standardized, enriched with holiday information, and validated through the pipeline.

The goal of this step is to convert the dataset into meaningful business insights using Power BI.

---

## Dataset Source

The dataset is loaded from SQL Server:

* Database: WFM
* Table: wfm_forecasting_base

---

## Understanding the Dataset (Important for New Users)

Before building the dashboard, it is important to understand what the data represents.

This dataset simulates **contact center operations**, where customer requests come in and agents handle them.

### Key Columns Explained

* **Offered_Volume**
  Total incoming requests (calls, chats, emails)

* **Handled_Volume**
  Requests that were successfully handled by agents

* **Abandoned_Volume**
  Requests that were not handled (customers dropped or left)

* **Service_Level_Percent**
  Percentage of requests handled successfully

* **AHT_Seconds**
  Average time taken to handle one request

* **Active_Agents**
  Number of agents actively working

* **Is_Holiday**
  Indicates whether the date is a holiday
  (1 = Holiday, 0 = Normal day)

* **Queue_Standardized**
  Cleaned and grouped queue name used for analysis

---

### What this data represents

Each row represents:

> Activity for a specific time, location, and queue

The dataset helps answer questions like:

* How much work came into the system?
* How much was handled successfully?
* How efficient were the agents?
* Does performance change during holidays?

---

## Steps Completed

---

### Step 1: Data Loading (SQL → Power BI)

#### What was done

* Connected Power BI to SQL Server
* Imported `wfm_forecasting_base` table

#### Why

* SQL Server acts as the single source of truth
* Ensures we are using validated and processed data
* Avoids working with raw or inconsistent data

#### What it means for the data

* Data is ready for reporting
* No additional cleaning required in Power BI

---

#### Data story

* All analysis in the dashboard is based on a single trusted dataset
* Ensures consistency between backend processing and reporting layer

---

### Step 2: KPI Creation — Total Offered Volume

#### What was done

* Created a Card visual
* Used `Offered_Volume` column

#### What Power BI did

* Automatically aggregated using SUM

#### What this KPI shows

* Total incoming workload across the dataset

---

#### Data interpretation

If the card shows:

* 3M

This means:

* Around 3 million requests came into the system

---

#### Business meaning

* Represents total demand handled by the system
* Helps understand overall workload volume

---

#### Data story

* The system is handling a high volume of incoming requests
* This KPI sets the baseline for understanding overall workload before analyzing performance

---

### Step 3: KPI Creation — Service Level (Measure)

#### What was done

* Created a custom measure:
Service_Level = DIVIDE(SUM(Handled_Volume),SUM(Offered_Volume))

* Displayed it using a Card visual
* Formatted as percentage

---

#### Why this was done

* Service Level is not a raw column metric
* It must be calculated at an aggregated level
* Using a measure ensures correct business logic

---

#### What this KPI shows

* Percentage of total workload that was successfully handled

---

#### Data interpretation

Example:

* Service Level = 94.68%

This means:

* Out of total incoming requests
* ~94.68% were handled
* ~5.32% were not handled (abandoned or backlog)

---

#### Business meaning

* Indicates system performance
* Higher value = better operational efficiency
* Used for SLA tracking and workforce planning

---

#### Data story

* The system is able to handle most of the incoming workload efficiently
* A small percentage of requests are still not handled, indicating possible backlog or capacity gaps

---

### Step 4: KPI Creation — Holiday vs Non-Holiday Service Level

#### What was done

* Created two measures:
Holiday_SL = CALCULATE(DIVIDE(SUM(Handled_Volume),SUM(Offered_Volume)),Is_Holiday = 1)

NonHoliday_SL = CALCULATE(DIVIDE(SUM(Handled_Volume),SUM(Offered_Volume)),Is_Holiday = 0)

* Displayed both using Card visuals
* Formatted as percentage

---

#### Why this was done

* Overall Service Level does not show behavior differences
* Needed to compare performance between holiday and normal days
* Helps identify operational impact of holidays

---

#### What this KPI shows

* Service Level during holidays
* Service Level during non-holiday days

---

#### Data interpretation

Example:

* Holiday Service Level = X%
* Non-Holiday Service Level = Y%

This means:

* Performance varies depending on whether it is a holiday or not

---

#### Business meaning

* Helps understand if holidays impact operational efficiency
* Useful for workforce planning and staffing adjustments

---

#### Data story

* Performance can change based on external factors like holidays
* Comparing holiday vs non-holiday performance highlights whether the system is equally efficient under different conditions

---

## Key Learning

* Columns represent raw data
* Measures represent business logic
* KPIs should always be built using measures for accuracy

---
### Step 5: KPI Creation — Holiday vs Non-Holiday Volume

#### What was done

* Created two measures:
Holiday_Volume = CALCULATE(SUM(Offered_Volume), Is_Holiday = 1)

NonHoliday_Volume = CALCULATE(SUM(Offered_Volume), Is_Holiday = 0)

* Displayed both using Card visuals
* Formatted values in thousands (K) for better readability

---

#### Why this was done

* Overall volume does not show demand variation across conditions
* Needed to compare workload between holiday and non-holiday days
* Helps understand how demand behaves under different conditions

---

#### What this KPI shows

* Total incoming workload during holidays
* Total incoming workload during non-holiday days

---

#### Data interpretation

Example:

* Holiday Volume = 106K
* Non-Holiday Volume = 2701K

This means:

* A very small portion of total workload occurs during holidays
* Most of the demand is concentrated on non-holiday days

---

#### Business meaning

* Indicates strong variation in demand based on calendar conditions
* Helps in planning workforce allocation more effectively
* Avoids overstaffing during low-demand periods like holidays

---

#### Data story

* Demand drops significantly during holidays compared to normal days
* Workload is heavily skewed towards non-holiday periods
* This pattern highlights the importance of adjusting staffing and planning based on holiday schedules

## Current Status

* Data successfully connected from SQL
* First KPI (Total Offered Volume) created
* Second KPI (Service Level %) created
* Holiday vs Non-Holiday Service Level comparison added
* Holiday vs Non-Holiday Volume comparison added

Dashboard development will continue with additional KPIs and interaction layers.

---
