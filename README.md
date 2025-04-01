# Cyclistic Bike-Share Analysis

This repository contains the analysis and supporting materials for the Cyclistic bikeshare case study, completed as part of the Google Data Analytics Professional Certificate Capstone Project. My main goal with this project was to apply the skills I have learned with SQL, R, and other data anayltics tools in a project scenario.

The analysis tries to understand how casual riders and annual members use Cyclistic bikes differently and to provide insights for marketing strategies to increase annual memberships.

## 1. Project Overview

### 1.1 Background

Cyclistic is a fictional bike-share program in Chicago, featuring over 5,800 bicycles and 600 docking stations. The company offers single-ride passes, full-day passes (referred to as "casual riders"), and annual memberships ("members").

### 1.2 Objectives

The primary objectives of this analysis are to:

* Identify differences in how casual riders and annual members use Cyclistic bikes.
* Determine a strategy to convert casual riders to annual members.

### 1.3 Key Questions

This analysis seeks to answer the following key questions:

* How do annual members and casual riders use Cyclistic bikes differently?
* Why would casual riders buy Cyclistic annual memberships?
* How can Cyclistic use digital media to influence casual riders to become members?

## 2. Data

### 2.1 Data Source

The original data for this analysis was obtained from the Divvy trip data public s3 bucket: [https://divvy-tripdata.s3.amazonaws.com/index.html](https://divvy-tripdata.s3.amazonaws.com/index.html)

### 2.2 Data Description

The dataset includes trip data from March 2024 to February 2025. It contains information on ride start and end times, rider type (member/casual), rideable type (classic bike/electric bike/electric scooter), and station information.

### 2.3 Data Cleaning

The following data cleaning steps were performed:

* Missing values were filtered out.
* Duplicate ride\_id values were removed.
* Outliers in ride duration were removed (rides ≤ 0 sec, ≤ 15 seconds, ≥ 16 hours). 
* Data types were checked and corrected.
* Inconsistencies in start/end times were addressed.

### 2.4 Cleaned Data

The cleaned data used for analysis was aggregated, cleaned and downloaded from BigQuery into a CSV file called `cleaned_bikeshare_data`.

## 3. Analysis

The analysis was conducted using R and the tidyverse package. Key analysis steps include:

* Grouping data by rider type, rideable type, hour of day, day of week, and month.
* Calculating summary statistics (e.g., ride count, average duration).
* Visualizing data using ggplot2 (e.g., bar charts, line charts).

## 4. Files

### 4.1 Code

* `R/BikeshareAnalysis.R`: R script for data analysis and visualization.
* `R/Bikeshare-Documentation.Rmd`: R Markdown document containing the analysis and code.
* `R/Bikeshare-Documentation.md`: Github document containing the analysis and code.

### 4.2 Data

* `data/CSVs/`: CSVs included in the markdown for narrative purposes
* `data/images/`: Images included in the markdown for narrative purposes

### 4.3 Documentation

* `presentation/Cyclistic Bikeshare Case Study.pdf`: Presentation slides summarizing the analysis and recommendations.
* `presentation/Bikeshare-Documentation.pdf`: PDF version of the rendered markdown document

## 5. Key Findings

* Annual members take significantly more rides than casual riders.
* Casual riders have a significantly longer average ride duration.
* Members have peak usage during commuting hours, while casual riders peak during midday and afternoons.
* Member usage is higher on weekdays, while casual rider usage is higher on weekends.
* Both user types show increased usage in warmer months, with a more pronounced effect for casual riders.

## 6. Recommendations

Based on the analysis, the following recommendations are made to increase casual rider conversions to annual memberships:

* Offer targeted memberships
* Offer promotional offers 
* Use social media to target casual riders

## 8. Author

Austin Broadbent

## 9. Acknowledgements

* Data source: Divvy trip data public s3 bucket
* R packages: tidyverse, ggplot2
* Presentation template: Slidesgo
