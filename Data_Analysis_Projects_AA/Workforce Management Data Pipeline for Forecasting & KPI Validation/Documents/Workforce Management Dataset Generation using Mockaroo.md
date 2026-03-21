Here is your **updated README (same content + added cloning process)** — nothing else changed, just extended cleanly.

---

# Workforce Management Dataset Generation using Mockaroo

This guide explains step-by-step (from scratch) how to generate a complete Workforce Management (WFO) dataset using Mockaroo.

No prior experience required.
Follow exactly and you will get the same dataset. 

---

# Step 0: Open Mockaroo & Save Schema (IMPORTANT)

### Go to:

[https://mockaroo.com/](https://mockaroo.com/)

---

### What to do:

1. Click **Start from scratch**
2. You will see the schema builder

---

### Save your schema (DO THIS FIRST)

1. Click **Save Changes**
2. Give name:

```text
WFO_Dataset
```

3. Click Save

Reason: Mockaroo can refresh and remove your work if not saved.

---

# Step-by-step Column Creation

Rule:

* Add one column at a time
* Click Save Changes after every 2–3 columns

---

# 1. Date

* Field Name: Date
* Type: Datetime
* From: 01/01/2021
* To: 12/31/2026
* Format: yyyy-mm-dd

---

# 2. Weekday

* Field Name: Weekday
* Type: Custom List

Values:

```text
Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
```

---

# 3. Week_Number

* Field Name: Week_Number
* Type: Number

```text
min: 1
max: 52
decimals: 0
```

---

# 4. Month

* Field Name: Month
* Type: Custom List

```text
January, February, March, April, May, June, July, August, September, October, November, December
```

---

# 5. Year

* Field Name: Year
* Type: Number

```text
min: 2021
max: 2026
decimals: 0
```

---

# 6. Hour

* Field Name: Hour
* Type: Number

```text
min: 0
max: 23
```

---

# 7. Country

* Field Name: Country
* Type: Country

---

# 8. Region

* Field Name: Region
* Type: Custom List

```text
APAC, EMEA, AMER
```

---

# 9. Site

* Field Name: Site
* Type: Custom List

```text
Hyderabad, Pune, Bangalore, Dublin, Sydney, Toronto, Cape Town, Manila, Tokyo
```

---

# 10. Queue_Name

* Field Name: Queue_Name
* Type: Custom List

```text
INBOUND_VOICE_TIER1, US_RETAIL_VOICE_T2, APAC_CHAT_SUPPORT_T1, EU_EMAIL_SUPPORT_T3, CUSTOMER_SUPPORT_CHAT_T1
```

---

# 11. Channel

* Field Name: Channel
* Type: Custom List

```text
Voice, Chat, Email
```

---

# 12. All_Units_Filter

* Field Name: All_Units_Filter
* Type: Custom List

```text
Consumer, Enterprise, Premium
```

---

# 13. Queue_Units_Filter

* Field Name: Queue_Units_Filter
* Type: Custom List

```text
Queue_Units_Filter
```

---

# 14. ASU_Tier_Filter

* Field Name: ASU_Tier_Filter
* Type: Custom List

```text
Tier 1, Tier 2, Tier 3
```

---

# 15. Business_Unit

* Field Name: Business_Unit
* Type: Custom List

```text
Telecom, Banking, Healthcare, Retail, E-commerce
```

---

# 16. planned_Volume

* Field Name: planned_Volume
* Type: Number

```text
min: 50
max: 500
```

---

# 17. offered_Volume

* Field Name: offered_Volume
* Type: Formula

```text
planned_Volume + random(-20, 30)
```

---

# 18. handled_Volume

* Field Name: handled_Volume
* Type: Formula

```text
offered_Volume - random(0, 30)
```

---

# 19. abandoned_Volume

* Field Name: abandoned_Volume
* Type: Formula

```text
offered_Volume - handled_Volume
```

---

# 20. backlog_Volume

* Field Name: backlog_Volume
* Type: Formula

```text
offered_Volume - handled_Volume
```

---

# 21. aHT_Seconds

* Field Name: aHT_Seconds
* Type: Number

```text
min: 180
max: 900
```

---

# 22. handle_Time_Total

* Field Name: handle_Time_Total
* Type: Formula

```text
handled_Volume * aHT_Seconds
```

---

# 23. Wait_Time_Avg

* Field Name: Wait_Time_Avg
* Type: Formula

```text
aHT_Seconds * (backlog_Volume / (offered_Volume * 1.0))
```

Important:
`* 1.0` ensures decimal division.

---

# 24. shrinkage_Percent

* Field Name: shrinkage_Percent
* Type: Number

```text
min: 15
max: 35
```

---

# 25. required_FTE

* Field Name: required_FTE
* Type: Formula

```text
handle_Time_Total / (8 * 3600 * (1 - (shrinkage_Percent / 100.0)))
```

---

# 26. Agent_Count

* Field Name: Agent_Count
* Type: Formula

```text
round(required_FTE * (1 + shrinkage_Percent / 100.0))
```

---

# 27. Utilization_Percent

* Field Name: Utilization_Percent
* Type: Number

```text
min: 65
max: 95
```

---

# 28. Active_Agents

* Field Name: Active_Agents
* Type: Formula

```text
round(Agent_Count * (Utilization_Percent / 100.0))
```

---

# 29. Service_Level_Percent

* Field Name: Service_Level_Percent
* Type: Number

```text
min: 70
max: 95
```

---

# 30. Occupancy_Percent

* Field Name: Occupancy_Percent
* Type: Number

```text
min: 60
max: 90
```

---

# Important Notes

* Ignore uppercase/lowercase issues (handled later in Python)
* Date mismatches are expected
* Holiday data will be added separately

---

# Save Work

* Click **Save Changes**

---

# Generate Data

```text
Rows = 1000
Format = CSV
```

Click **Generate Data** and download CSV.

---

# Generate More Data (CLONE SCHEMA METHOD)

To create another 1000 rows:

### Step 1: Go to your saved schemas

* Click **Schemas (top menu)**

---

### Step 2: Open your schema

* Click on `WFO_Dataset`

---

### Step 3: Clone it

* Click **Duplicate / Copy Schema**

---

### Step 4: Rename (optional)

```text
WFO_Dataset_2
```

---

### Step 5: Generate again

* Keep same settings:

```text
Rows = 1000
Format = CSV
```

* Click **Generate Data**

---

### Step 6: Repeat if needed

You can generate:

* 1000 rows
* 2000 rows
* 5000 rows (by repeating cloning)

---

### Step 7: Combine datasets

Later in Python:

* Merge all CSV files
* Clean data
* Remove duplicates if needed

---

# Final Result

You now have:

* Multiple datasets
* Realistic relationships
* Scalable data generation

---

# Next Step

Use Python to:

* Fix date mismatches
* Add holiday data (web scraping)
* Merge multiple files
* Clean dataset
* Format column names as per business rules

---

This dataset is now ready for further processing and analysis.
