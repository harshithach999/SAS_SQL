
# README for SAS Program

## Overview

This SAS program is designed to access, explore, prepare, and analyze claims and enplanement data. The program processes and cleans the data, performs various transformations, and generates insightful reports by combining multiple datasets. The final results are saved in a PDF file (`output.pdf`), which captures the output and tables generated during the analysis.

## Data Sources

The program uses the following datasets:
- `claimsraw.sas7bdat`: Contains claim data, including incident dates, airport information, and claim types.
- `enplanement2017.sas7bdat`: Contains enplanement data for the year 2017.
- `boarding2013_2016.sas7bdat`: Contains boarding data for the years 2013 to 2016.

## Steps

### 1. Access and Explore Data
- **Library Definition**: The `libname` statement defines the `cs` library to access SAS datasets from the `case_study` folder.
- **Initial Data Inspection**: The program retrieves and prints the first 10 rows of the `claimsraw`, `enplanement2017`, and `boarding2013_2016` datasets using `PROC SQL`. The results of these queries, including table previews, are stored in the `output.pdf` file.
- **Column Attributes Report**: It fetches and prints metadata about columns (name, type, length) for the claims and enplanement datasets. This metadata is outputted to the PDF file for review.
- **Distinct Values**: The program extracts distinct values from specific columns such as `Claim_Site`, `Disposition`, `Claim_Type`, `Date_Received`, and `Incident_Date`. The distinct values are shown in the PDF file.

### 2. Data Preparation
- **Remove Duplicates**: A deduplicated dataset is created from `claimsraw`, and the results are displayed in the `output.pdf` file.
- **Date Corrections**: The program fixes incorrect dates in the `Date_Received` column where the incident date is after the received date by incrementing the year. These transformations and the affected records are presented in the PDF file.
- **Replace Missing Values**: Missing airport codes are replaced with "Unknown", and other columns like `Claim_Type`, `Claim_Site`, and `Disposition` are cleaned. The cleaned data is shown in the results PDF file.
- **Case and Formatting**: The program applies appropriate formats (e.g., DOLLAR format for monetary amounts) and corrects the case for state, county, and city names. These formatting changes are documented in the PDF file.

### 3. Create Views and Final Tables
- **Total Claims by Airport**: The `TotalClaims` view aggregates claim counts by airport and year. The summarized results are included in the `output.pdf` file.
- **Total Enplanements**: The `TotalEnplanements` view concatenates the `enplanement2017` and `boarding2013_2016` datasets, and this is shown in the PDF file.
- **Claims by Airport**: Combines claims and enplanement data into a `ClaimsByAirport` table, calculating the percentage of claims relative to enplanements for each airport and year. The final table is outputted to the PDF file for review.

### 4. Data Analysis and Reporting
- **Summary Statistics**: The following statistics are calculated and output to the `output.pdf` file:
  - Total enplanements across all years.
  - Total number of claims.
  - Average time (in days) between the incident date and when the claim was received.
  - Number of claims with missing or unknown airport codes.
  - Count of claims for each `Claim_Type` and `Disposition`.
- **Airport-Level Analysis**: The program identifies airports with more than 10 million enplanements and lists them along with their respective percentage of claims. These insights are stored in the PDF file for further analysis.

## Results File: [CaseStudy_Solution-results](./output.pdf)

The results of all steps, including data previews, transformations, and final analysis, are stored in the `output.pdf` file. This file contains:
- Tables showing initial data from the `claimsraw`, `enplanement2017`, and `boarding2013_2016` datasets.
- Column metadata from the dictionary of columns for all the relevant datasets.
- Summary tables showing distinct values from key columns (e.g., `Claim_Type`, `Claim_Site`, etc.).
- Results of data cleaning and transformation steps (e.g., fixing dates, handling missing values).
- Summarized insights such as the total number of enplanements, claims, and analysis on claims by airport.

You can view the output in the file after running the program. The file is located in the repository as `output.pdf`.

## Notes
- Ensure that all required datasets are present in the `/home/user/SQL/case_study` directory for successful execution.
- The program is organized into sections, beginning with data exploration, followed by cleaning, preparation, and analysis, to provide a clear structure for understanding the process flow.
