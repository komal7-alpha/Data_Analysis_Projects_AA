CREATE OR ALTER PROCEDURE dbo.sp_load_kpi_rules
AS
BEGIN
    SET NOCOUNT ON;

    /*
    ============================================
    Procedure Name : dbo.sp_load_kpi_rules
    Author         : KOMAL
    Description    : Reloads all business rules into kpi_rules table
    ============================================
    */

    TRUNCATE TABLE dbo.kpi_rules;

    INSERT INTO dbo.kpi_rules (Rule_ID, Rule_Name, Business_Rule_Description)
    VALUES
    ('BR-01','Remove Region Prefix','Queue names may include region identifiers such as APAC, EMEA, AMER. These should be removed as they do not impact service-level analysis.'),
    ('BR-02','Remove Operational Prefix','Operational labels such as INBOUND, OUTBOUND, CUSTOMER, RETENTION should be ignored as they do not define the service type.'),
    ('BR-03','Service Identification','Queue names should be mapped to a standard service category (VOICE, CHAT_SUPPORT, SUPPORT_EMAIL, CORE_EMAIL, SALES, RETAIL_VOICE).'),
    ('BR-04','Word Order Standardization','Queue names with the same meaning but different word order should be standardized to a single format.'),
    ('BR-05','Tier Normalization','Tier values must follow a consistent format. All T1, T2, T3 should be converted to TIER1, TIER2, TIER3.'),
    ('BR-06','Similar Queue Mapping','Queue names with high similarity should be treated as the same service and mapped to a single standardized name.'),
    ('BR-07','Standard Naming Format','All standardized queue names must follow the format: <SERVICE>_<TIER>.'),
    ('BR-08','Controlled Output Buckets','All queue names must be mapped into predefined business-approved categories to ensure consistency across reporting.'),
    ('BR-09','Duplicate Reduction','Multiple queue names representing the same service should be consolidated into a single standardized queue.'),
    ('BR-10','Data Consistency for Reporting','Standardized queue names should ensure accurate aggregation, reporting, and forecasting by removing inconsistencies and fragmentation.'),
    ('BR-11','Fuzzy Matching Threshold','Queue names are matched based on similarity score. If similarity score >= 85%, the queue is mapped to the closest standardized name. If below threshold, it is retained or reviewed.'),
    ('BR-12','Fallback Handling','If a queue name does not match any predefined standard category or similarity threshold, it should be retained in its normalized form for further review.'),
    ('BR-13','Country Standardization','Country values must be standardized to ensure consistent joins across datasets (e.g., holiday mapping).'),
    ('BR-14','Holiday Mapping','Holiday data must be integrated using Date and Country to enrich the dataset with holiday context.'),
    ('BR-15','Holiday Flag Creation','A binary flag (Is_Holiday) must be created to identify whether a record falls on a holiday.'),
    ('BR-16','Holiday Type Assignment','All holiday records must be assigned a holiday type for classification. Default value can be ''Public''.'),
    ('BR-17','Data Preservation (Join Strategy)','A left join must be used when integrating external datasets to ensure no loss of records from the main dataset.'),
    ('BR-18','KPI Calculation Standardization','All KPI metrics must be calculated using standardized formulas to ensure consistency across systems.'),
    ('BR-19','Safe Division Handling','Any division operation must handle zero denominators to prevent errors and invalid values.'),
    ('BR-20','KPI Validation Rule','All derived KPIs must be validated by recalculating and comparing with stored values.'),
    ('BR-21','Data Storage Standard','Final processed dataset must be stored in SQL Server as a system of record.'),
    ('BR-22','Post-Load Data Integrity Check','After SQL ingestion, row counts must be validated to ensure no data loss or duplication.'),
    ('BR-23','Null Value Handling','Null or missing values must be handled appropriately before analysis or storage.'),
    ('BR-24','Data Type Enforcement','All columns must follow consistent data types before loading into SQL.');
END;

EXEC dbo.sp_load_kpi_rules;