# SAS_SQL

## Overview

This SAS program is designed to access, explore, prepare, and analyze data from claims and enplanement records. It processes and cleans the data, performs various transformations, and generates insightful reports by combining multiple datasets. The final results provide an analysis of the percentage of claims for each airport based on enplanements.

## Data Sources

The program uses the following datasets:
- `claimsraw.sas7bdat`: Contains claim data, including incident dates, airport information, and claim types.
- `enplanement2017.sas7bdat`: Contains enplanement data for the year 2017.
- `boarding2013_2016.sas7bdat`: Contains boarding data for the years 2013 to 2016.

## Steps

### 1. Access and Explore Data
- **Library Definition**: The `libname` statement defines the `cs` library to access SAS datasets from the `case_study` folder.
- **Initial Data Inspection**: The program retrieves and prints the first 10 rows of the `claimsraw`, `enplanement2017`, and `boarding2013_2016` datasets using `PROC SQL`.
- **Column Attributes Report**: It fetches and prints metadata about columns (name, type, length) for the claims and enplanement datasets.
- **Distinct Values**: The code extracts distinct values from specific columns such as `Claim_Site`, `Disposition`, `Claim_Type`, `Date_Received`, and `Incident_Date`.

### 2. Data Preparation
- **Remove Duplicates**: The program creates a deduplicated dataset from `claimsraw`.
- **Date Corrections**: Fixes incorrect dates in the `Date_Received` column where the incident date is after the received date by incrementing the year.
- **Replace Missing Values**: Replaces missing airport codes with "Unknown" and cleans columns like `Claim_Type`, `Claim_Site`, and `Disposition` by handling null or inconsistent values.
- **Case and Formatting**: Formats monetary amounts using the DOLLAR format and adjusts case (uppercase/lowercase) for state, county, and city names.

### 3. Create Views and Final Tables
- **Total Claims by Airport**: The `TotalClaims` view aggregates claim counts by airport and year.
- **Total Enplanements**: The `TotalEnplanements` view concatenates the `enplanement2017` and `boarding2013_2016` datasets.
- **Claims by Airport**: Combines claims and enplanement data into a `ClaimsByAirport` table, calculating the percentage of claims relative to enplanements for each airport and year.

### 4. Data Analysis and Reporting
- **Summary Statistics**: Generates summary statistics such as:
  - Total enplanements across all years.
  - Total number of claims.
  - Average time (in days) between the incident date and when the claim was received.
  - Number of claims with missing or unknown airport codes.
  - Count of claims for each `Claim_Type` and `Disposition`.
- **Airport-Level Analysis**: Identifies airports with more than 10 million enplanements and lists them along with their respective percentage of claims.

---

## Notes
- The program uses SQL queries extensively for data manipulation and cleaning.
- The final output of the analysis includes a cleaned dataset that can be used for further reporting or predictive analysis.
- Ensure that all required datasets are present in the `/home/u62293126/SQL/case_study` directory for successful execution.

---
