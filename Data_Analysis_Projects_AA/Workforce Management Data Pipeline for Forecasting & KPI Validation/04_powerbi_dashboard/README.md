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

### Step 2: Total Offered Volume KPI

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

### Step 3: Service Level KPI (Measure)

#### What was done

* Created a custom measure:

```
Service_Level = 
DIVIDE(
    SUM(Handled_Volume),
    SUM(Offered_Volume)
)
```

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

## Key Learning

* Columns represent raw data
* Measures represent business logic
* KPIs should always be built using measures for accuracy

---

## Current Status

* Data successfully connected from SQL
* First KPI (Total Offered Volume) created
* Second KPI (Service Level %) created

Dashboard development will continue with additional KPIs and analysis layers.

---
