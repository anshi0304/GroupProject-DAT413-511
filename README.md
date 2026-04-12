Project Overview

Project name: Group Project — Data Cleaning and Tidy Data Preparation
Purpose: Demonstrate the ability to collect, clean, and prepare a tidy dataset from the Human Activity Recognition Using Smartphones data (accelerometer data from Samsung Galaxy S). The final deliverable is a tidy dataset suitable for downstream analysis and reproducible code that documents the cleaning steps.

/ (root)  
├─ Script.R                # Main R script that performs all cleaning steps  
├─ tidy_dataset.txt        # Final tidy dataset produced by Script.R  
├─ CodeBook.md             # Documentation of variables, transformations, and processing steps  
├─ README.md               # This file  
├─ Group Project1.docx     # Project notes/document  


---

Script.R — Main Processing Script  

`Script.R` is the core component of this project. It performs all data cleaning, transformation, and tidying operations required to produce the final dataset.  

What the script does:  

1. **Loads Required Libraries**  
   - Uses `dplyr` for efficient data manipulation  

2. **Reads Metadata**   
   - Imports feature names and activity labels  

3. **Extracts Relevant Variables**  
   - Selects only measurements related to:  
     - Mean (`mean()`)  
     - Standard deviation (`std()`)  

4. **Loads Raw Data**   
   - Imports training and test datasets:  
     - Sensor measurements  
     - Activity labels  
     - Subject identifiers  

5. **Merges Datasets**  
   - Combines training and test data into one unified dataset  

6. **Applies Descriptive Activity Names**  
   - Replaces numeric activity IDs with readable activity names  

7. **Cleans and Labels Variables**  
   - Assigns clear and descriptive column names  

8. **Creates Tidy Dataset**  
   - Groups data by:  
     - Subject  
     - Activity  
   - Computes the **average of each variable**  

9. **Exports Final Output**  
   - Writes the tidy dataset to:  
     ```  
     tidy_dataset.txt  
     ```  

---

How to Run the Script

1. Download and unzip the dataset into your working directory
2. Run the script in R or RStudio:  
source("Script.R")

---  

Output:  
tidy_dataset.txt  
* Contains the average of each variable for each subject and activity, Structured according to tidy data principles  
