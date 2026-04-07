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

### Step 6: Interaction Layer — Holiday Filter (Slicer)

#### What was done

* Created a new column:
Holiday_Label = IF(wfm_forecasting_base[Is_Holiday] = 1, "Holiday", "Non-Holiday")

* Added a Slicer visual to the dashboard
* Used `Holiday_Label` in the slicer
* Changed slicer style to Dropdown
* Enabled "Select All" option for flexibility

---

#### Why this was done

* Raw column `Is_Holiday` (0/1) is not user-friendly
* Needed a clear and readable filter for end users
* Enables dynamic filtering of the entire dashboard
* Allows users to switch between Holiday, Non-Holiday, or All data

---

#### What this step shows

* Provides a control to filter the dashboard based on holiday conditions
* All KPIs and visuals update dynamically based on selection

---

#### Data interpretation

Example:

* When "Holiday" is selected:
  Only holiday data is shown

* When "Non-Holiday" is selected:
  Only non-holiday data is shown

* When "All" is selected:
  Full dataset is displayed

---

#### Business meaning

* Enables focused analysis on specific conditions
* Helps compare performance and demand under different scenarios
* Improves usability of the dashboard for decision-making

---

#### Data story

* The same system behaves differently under different conditions
* By filtering between holiday and non-holiday data, users can explore how workload and performance vary across scenarios
* This adds an exploration layer on top of the KPI comparisons

---

### Step 7: Interaction Layer — Core Filters (Date, Country, Channel)

#### What was done

* Added a slicer for `Date`
* Configured Date slicer to "Between" range selection
* Added a slicer for `Country`
* Added a slicer for `Channel`
* Set Country and Channel slicers to Dropdown style
* Aligned all slicers horizontally for consistent layout

---

#### Why this was done

* KPI cards alone do not allow detailed analysis
* Needed filters to explore data across different dimensions
* Enables users to analyze performance across time, geography, and communication channels

---

#### What this step shows

* Provides control to filter the dashboard by:
  - Time (Date range)
  - Location (Country)
  - Communication type (Channel)

* All KPIs dynamically update based on selected filters

---

#### Data interpretation

Example:

* Selecting a specific date range:
  Shows performance only for that time period

* Selecting a specific country:
  Filters data to that region

* Selecting a specific channel:
  Displays metrics for that communication type

---

#### Business meaning

* Helps identify trends over time
* Enables region-wise performance comparison
* Allows channel-level analysis for better decision-making
* Supports targeted workforce planning

---

#### Data story

* System performance and demand are not constant across time, regions, and channels
* By applying filters, users can uncover patterns such as peak periods, regional differences, and channel-specific behavior
* This enables deeper exploration beyond high-level KPIs

---

### Step 8: Visualization Layer — Business Graphs (Demand, Performance, Distribution)

#### What was done

* Added four key visuals to represent different aspects of the data:

Before building visuals, it is important to understand how charts work in Power BI:

* X-axis → categories (what you compare)
* Y-axis → numbers (what you measure)

This basic concept helps in correctly designing all charts.

---

1. Volume by Holiday Type  
   - X-axis: Holiday_Label  
   - Y-axis: SUM(Offered_Volume)  

   Explanation:  
   Holiday_Label is a category (Holiday vs Non-Holiday), so it is placed on X-axis.  
   Offered_Volume is a numeric field, so it is aggregated using SUM and placed on Y-axis.  

   This chart compares total workload between holiday and non-holiday conditions.

---

2. Service Level by Holiday Type  
   - X-axis: Holiday_Label  
   - Y-axis: Service_Level (measure)  

   Explanation:  
   Service_Level is a calculated measure, not a raw column.  
   It represents performance, so it is placed on Y-axis.  

   This chart compares how efficiently the system performs under different conditions.

---

3. Top Countries by Volume  
   - Y-axis: Country  
   - X-axis: SUM(Offered_Volume)  
   - Applied Top N filter (Top 5 based on Offered_Volume)  

   Explanation:  
   Country is a category, so it is placed on axis.  
   Offered_Volume is summed to show total workload per country.  

   Top N filter is applied to avoid showing all countries and focus only on the most important ones.

---

4. Volume Distribution by Channel  
   - Legend: Channel  
   - Values: SUM(Offered_Volume)  

   Explanation:  
   Channel represents different communication types like Voice, Email, and Chat.  
   Offered_Volume is used as value to show how workload is distributed across these channels.  

   This helps understand how work is split between different communication modes.

---

#### Why this was done

* KPI cards alone do not provide visual understanding
* Needed graphical representation to:
  - Compare demand
  - Compare performance
  - Identify geographic distribution
  - Understand channel mix

* Helps transform raw numbers into intuitive insights

---

#### What this step shows

* Demand comparison between Holiday and Non-Holiday periods
* Performance comparison using Service Level
* Top contributing countries based on workload
* Distribution of workload across different communication channels

---

#### Data interpretation

Example:

* Non-Holiday Volume is significantly higher than Holiday Volume  
* Service Level remains relatively stable across both conditions  
* A few countries contribute the majority of workload  
* Workload is distributed across channels like Voice, Email, and Chat  

---

#### Business meaning

* Demand is highly concentrated on non-holiday periods  
* System performance remains consistent even when demand changes  
* Workload is not evenly distributed across countries  
* Channel mix helps identify where most operational effort is required  

---

#### Data story

* The system experiences significantly higher demand during non-holiday periods  
* Despite variation in workload, performance (Service Level) remains stable  
* Workload is concentrated in a few key countries, indicating regional demand patterns  
* Different communication channels contribute differently to total workload, highlighting operational distribution  

* Together, these visuals provide a complete view of demand, performance, geography, and channel behavior in a single dashboard layer

---
---

### Step 9: Dashboard Layout & Formatting (Structure, Alignment, Presentation)

#### What was done

* Structured the entire dashboard into clear sections:

1. Title Section  
   - Added a centered title:  
     Workforce Management Dashboard Summary  

2. KPI Row (Top Row)  
   - Placed six KPI cards in a single horizontal line:
     - Total Volume  
     - Service Level  
     - Holiday SL  
     - Non-Holiday SL  
     - Holiday Volume  
     - Non-Holiday Volume  

3. Filter Row (Second Row)  
   - Placed all slicers in one aligned row:
     - Date (range slider)
     - Country (dropdown)
     - Channel (dropdown)
     - Holiday Filter (dropdown)

4. Secondary Metrics Row (Third Row)  
   - Added supporting KPIs:
     - Avg Volume per Agent
     - Avg Agent Utilization
     - Holiday Impact on SL  

5. Visualization Layer  
   - Positioned visuals in a structured layout:
     - Donut chart (center-right, between metrics and graphs)
     - Bottom row:
       - Volume by Holiday Type
       - Service Level by Holiday Type
       - Top Countries by Volume  

---

#### Why this was done

* Raw visuals without structure create confusion
* Needed clear grouping of:
  - KPIs (what is happening)
  - Filters (how to explore)
  - Metrics (why it is happening)
  - Charts (where and how it varies)

* Helps users understand the dashboard flow without explanation

---

#### What this step shows

* A clean and structured dashboard layout
* Logical flow from top to bottom:
  - High-level summary
  - User controls (filters)
  - Supporting metrics
  - Visual insights

---

#### Layout logic (Important for beginners)

The dashboard follows a clear reading pattern:

1. Top → Overall system performance  
2. Middle → Filters to explore data  
3. Below → Supporting metrics  
4. Bottom → Visual analysis  

This ensures users can understand the dashboard without guidance.

---

#### Formatting improvements applied

* Renamed technical labels:
  - Holiday_SL → Holiday SL
  - NonHoliday_SL → Non-Holiday SL

* Standardized number formatting:
  - Volume → Thousands (K)
  - Service Level → Percentage (%)
  - Metrics → Limited decimal places

* Aligned all visuals:
  - KPI cards in one straight row
  - Filters in one horizontal line
  - Metrics centered and evenly spaced

* Removed unnecessary visual noise:
  - Reduced background usage
  - Avoided excessive borders
  - Maintained clean white canvas

* Improved visual spacing:
  - Ensured proper gaps between sections
  - Avoided overlapping elements

---

#### Data interpretation

* Users can now clearly see:
  - Total workload and performance at a glance
  - Differences between holiday and non-holiday behavior
  - Key contributing countries and channels
  - Supporting metrics explaining operational efficiency

---

#### Business meaning

* A well-structured dashboard improves decision-making speed
* Users can quickly:
  - Identify demand patterns
  - Compare performance across conditions
  - Drill down using filters
* Reduces dependency on technical explanations

---

#### Data story

* The dashboard now tells a complete story:

  - The system handles a large volume of requests  
  - Performance remains stable across different conditions  
  - Demand is significantly higher during non-holiday periods  
  - Workload is concentrated in specific countries and channels  

* The structured layout ensures that users can move from summary to detailed insights seamlessly

---

## Current Status

* Data successfully connected from SQL
* First KPI (Total Offered Volume) created
* Second KPI (Service Level %) created
* Holiday vs Non-Holiday Service Level comparison added
* Holiday vs Non-Holiday Volume comparison added
* Holiday filter (slicer) added for interactive analysis
* Core filters (Date, Country, Channel) added for detailed exploration
* Business visuals added for demand, performance, and distribution analysis
* Dashboard structured with proper layout and alignment
* Formatting applied for clean and professional presentation

Dashboard development will continue with additional pages and deeper analysis layers.

---

---
