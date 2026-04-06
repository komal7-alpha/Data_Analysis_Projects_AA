# Power BI Summary Dashboard — Roadmap (Page 1)

---

## Objective

The goal of the summary dashboard is to provide a high-level view of:

* Overall workload
* System performance
* Holiday vs Non-Holiday behavior
* Demand and performance comparison

This page is designed to give a quick understanding of the system in a single view.

---

## Dashboard Layout Structure

The dashboard is divided into three main sections:

1. KPI Section (Top)
2. Comparison Section (Middle)
3. Filters and Interaction Layer (Top/Side)

---

## Section 1: KPI Cards (Top Row)

This section provides a quick snapshot of overall system performance.

### KPIs Included

1. Total Offered Volume
2. Service Level %
3. Holiday Service Level %
4. Non-Holiday Service Level %

---

### Purpose

* To show total workload entering the system
* To show how efficiently the system is handling requests
* To compare performance between holiday and non-holiday conditions

---

## Section 2: Volume Comparison (Second Row)

This section focuses on demand behavior.

### KPIs Included

1. Holiday Volume
2. Non-Holiday Volume

---

### Purpose

* To compare incoming workload during holidays vs normal days
* To identify demand variation patterns

---

## Section 3: Interaction Layer (Slicers)

This section allows users to dynamically explore the data.

### Slicers Included

1. Holiday Filter

   * Values: Holiday / Non-Holiday

2. Date Filter

3. Country Filter

4. Channel Filter

---

### Purpose

* To allow filtering of the entire dashboard
* To enable focused analysis on specific segments
* To dynamically update all KPIs based on selection

---

## Step-by-Step Implementation

---

### Step 1: Data Connection

* Connect Power BI to SQL Server
* Load `wfm_forecasting_base` table

---

### Step 2: Create Total Offered Volume KPI

* Use `Offered_Volume`
* Display using Card visual
* Aggregation: SUM

---

### Step 3: Create Service Level KPI

* Create measure using:
  Handled_Volume / Offered_Volume
* Display as percentage

---

### Step 4: Create Holiday vs Non-Holiday Service Level

* Create two measures:

  * Holiday Service Level
  * Non-Holiday Service Level

* Use CALCULATE with Is_Holiday filter

---

### Step 5: Create Holiday vs Non-Holiday Volume

* Create two measures:

  * Holiday Volume
  * Non-Holiday Volume

* Based on Offered_Volume

---

### Step 6: Add Slicers

* Add slicer for Is_Holiday (or Holiday_Label)
* Add slicers for Date, Country, Channel

---

### Step 7: Arrange Layout

* Place KPI cards in top row
* Place volume comparison cards in second row
* Place slicers at top or left panel

---

### Step 8: Add Cross-Page Summary Visual

* Create a combined summary visual representing key metrics from all pages
* Include metrics such as:
  - Total Volume
  - Service Level
  - Holiday Impact
  - Utilization
  - Volume per Agent

* Use a single chart (e.g., clustered column chart) to represent all metrics
* This visual acts as a high-level snapshot of the entire dashboard ecosystem

---

### Step 9: Formatting and Design

* Use consistent titles for all visuals
* Apply proper number formatting (Millions, Percentage)
* Align visuals properly for readability
* Avoid clutter and unnecessary visuals

---

## Final Dashboard Flow

The summary dashboard answers the following questions:

1. What is the total workload in the system?
2. How well is the system handling the workload?
3. Does performance change during holidays?
4. Does demand change during holidays?
5. Can the user explore data dynamically using filters?
6. What is the overall system snapshot across all analytical dimensions?

---

## Expected Outcome

* A clean, structured dashboard
* Clear comparison between holiday and non-holiday behavior
* Interactive filtering capability
* Business-ready visualization for decision-making
* High-level summary of all analytical pages in a single view

---
