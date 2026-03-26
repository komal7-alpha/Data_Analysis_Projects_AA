
# Global Public Holiday Data Pipeline (Web Scraping Project)

## Disclaimer
This project reflects the type of Web Scrapping, I work on in my current role as an Associate Solutions Engineer (Data Analyst) at Aligned Automation Ltd.

The implementation in this repository is a recreated, generalized version built solely for demonstration and learning purposes. No proprietary data, internal systems, client information, or confidential business logic from Aligned Automation Ltd. has been used.

All datasets used in this project are either synthetically generated or sourced from publicly available online resources. The project focuses only on showcasing the technical approach, data processing logic, and system design patterns used in real-world scenarios while fully maintaining organizational data privacy and confidentiality.

## Overview

This project builds a scalable web scraping and data processing pipeline to collect, standardize, and analyze public holiday data across 50+ countries over a multi-year period (2021–2040).

File Name- Holiday.ipynb

The solution focuses on:

* Automated large-scale data extraction
* Parallel scraping using Selenium
* Structured storage using chunk-based processing
* Fault-tolerant and resumable execution
* Data aggregation and analytical transformation

The final dataset is suitable for Workforce Management (WFM), forecasting, and analytics use cases.

---

## Objectives

* Extract public holiday data only (exclude observances, religious events, etc.)
* Cover 50+ countries globally
* Capture 20 years of data (2021–2040)
* Ensure:

  * No data loss
  * Resume capability after failure
  * Scalable execution
* Build a clean, analysis-ready dataset

---

## Data Source

* Source: [https://www.timeanddate.com/holidays](https://www.timeanddate.com/holidays)
* Data Type: Public Holidays
* Access Pattern:

  ```
  https://www.timeanddate.com/holidays/{country}/{year}?hol=1
  ```

---

## Architecture Overview

```
Country List + Year Range
          ↓
Chunk-Based Execution
          ↓
Threaded Selenium Scraping
          ↓
HTML Table Extraction
          ↓
Data Cleaning & Formatting
          ↓
Chunk-wise CSV Storage
          ↓
Final Merge
          ↓
Analytics Dataset
```

---

## Key Features

### Multi-Country Support

The pipeline supports 52 countries across multiple regions including the US, India, UK, Australia, Germany, France, Japan, China, and others.

Each country is mapped to its URL-compatible format for automated scraping.

---

### Year Range Handling

* Data collected for:

  ```
  2021 → 2040
  ```
* Sequential year processing ensures:

  * Predictable execution
  * Easier debugging
  * Controlled resource usage

---

### Chunk-Based Processing

Countries are processed in fixed-size batches:

```
CHUNK_SIZE = 5
```

This ensures:

* Stable execution
* Controlled browser usage
* Incremental saving
* Resume capability

---

### Parallel Execution

* Implemented using:

  ```
  ThreadPoolExecutor
  ```
* Controlled with:

  ```
  MAX_THREADS = 2
  ```

This avoids excessive browser load while maintaining performance.

---

### Selenium-Based Scraping

Selenium is used due to dynamic content rendering.

Optimizations applied:

* Headless execution
* Disabled images and extensions
* Reduced page load time using eager strategy
* Controlled waits and delays

---

### Data Extraction Logic

From each page, the following fields are extracted:

* Date
* Day
* Holiday Name
* Type
* Country

Filtering ensures only valid holiday records are included:

```
Type contains "Holiday"
```

This excludes observances and non-relevant entries.

---

### Date Standardization

Raw format:

```
1 Jan
```

Converted to:

```
01-Jan-21
```

This ensures consistency and easier downstream processing.

---

### Fault Tolerance and Resume Logic

Each chunk is saved as:

```
holidays_{year}_part{i}.csv
```

Before processing:

```
If file exists → skip
```

This enables:

* Safe re-execution
* Crash recovery
* No duplication of work

---

### Logging and Monitoring

Structured logs are used:

```
[START] COUNTRY YEAR
[DONE] COUNTRY YEAR → rows
[CHUNK] processing details
[SAVED] file → rows
```

This provides visibility into execution progress and debugging.

---

### Final Data Merge

All partial files are merged into:

```
holidays_all.csv
```

Final dataset:

* ~12,700+ rows
* 52 countries
* 20 years

---

## Data Validation

Validation steps performed:

* Verified country coverage
* Checked row count consistency
* Ensured no empty chunks
* Validated distribution across years

---

## Analytical Enhancements

Post-processing includes:

### Country-Year Holiday Count

```
Country | Year | Holiday_Count
```

### Pivot Matrix

```
Country vs Year → Holiday Count
```

### Data Quality Checks

* Identification of low-count country-year combinations
* Detection of anomalies

---

## Project Structure

```
Holiday/
│
├── holiday.ipynb
├── holidays_2021_part0.csv
├── holidays_2021_part5.csv
├── ...
├── holidays_2040_part50.csv
│
├── holidays_all.csv
├── country_year_holiday_matrix.csv
└── README.md
```

---

## How to Run

### Install dependencies

```
pip install pandas selenium
```

Ensure Chrome and ChromeDriver are compatible.

---

### Run scraping

```
python holiday.py
```

Or execute the notebook:

```
Run All Cells
```

---

### Merge data

Run the merge step to generate:

```
holidays_all.csv
```

---

## Output

Final dataset:

```
holidays_all.csv
```

Columns:

```
Date | Day | Name | Type | Country
```
---

## Key Learnings

* Designing scalable scraping pipelines
* Handling dynamic web content with Selenium
* Balancing concurrency and system stability
* Building fault-tolerant data pipelines
* Structuring data for analytics use cases

---
# List of Countries 

* Australia  
* Bangladesh  
* Brazil  
* Bulgaria  
* Canada  
* China  
* Czech  
* Denmark  
* Finland  
* France  
* Germany  
* Greece  
* Hong-Kong  
* Hungary  
* India  
* Indonesia  
* Israel  
* Italy  
* Japan  
* Kenya  
* North-Korea  
* South-Korea  
* Malaysia  
* Mongolia  
* Morocco  
* Netherlands  
* Norway  
* Pakistan  
* Philippines  
* Poland  
* Portugal  
* Romania  
* Russia  
* Slovenia  
* South-Africa  
* Spain  
* Sri-Lanka  
* Sweden  
* Taiwan  
* Thailand  
* Turkey  
* Vietnam  
* Ukraine  
* UK  
* New-Zealand  
* Belgium  
* Luxembourg  
* Chile  
* Paraguay  
* Slovakia  
* Ireland  
* Iceland  
* US


Just tell.

