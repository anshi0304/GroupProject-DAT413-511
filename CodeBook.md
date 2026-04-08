# CodeBook

## 1. Data Overview

This project uses the Human Activity Recognition Using Smartphones dataset from the UCI Machine Learning Repository. The dataset contains motion and activity data collected from 30 subjects who performed six different physical activities while wearing a Samsung Galaxy S smartphone on their waist. The smartphone captured signals using its embedded accelerometer and gyroscope.
The purpose of this project was to clean and organize the raw dataset into a tidy dataset that can be used for later analysis. The final dataset contains the average of selected measurements for each subject and each activity.

The six activities included in the dataset are

- WALKING
- WALKING_UPSTAIRS
- WALKING_DOWNSTAIRS
- SITTING
- STANDING
- LAYING

## 2. Variable Description

The final tidy dataset contains 68 variables.

### Subject
- **Type:** Integer
- **Description:** Identifies the participant who performed the activity.
- **Values:** 1 to 30

### Activity
- **Type:** Character
- **Description:** Descriptive name of the activity performed by the subject.
- **Possible values:** WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

### Measurement Variables
The remaining 66 variables are numeric measurement variables selected from the original dataset. These variables represent either the **mean()** or **std()** of motion and signal measurements.

Examples of measurement variables include:

- `tBodyAcc-mean()-X`
- `tBodyAcc-mean()-Y`
- `tBodyAcc-std()-X`
- `tGravityAcc-mean()-Z`
- `fBodyGyro-std()-Y`

Each of these variables contains the average value of that measurement for a specific subject and activity.

## 3. Variable Naming Conventions

The variable names come from the original dataset and follow a standard format.

- `t` = time domain signal
- `f` = frequency domain signal
- `Body` = body movement signal
- `Gravity` = gravity signal
- `Acc` = accelerometer
- `Gyro` = gyroscope
- `Jerk` = rate of change of the signal
- `Mag` = magnitude of the signal
- `mean()` = mean value
- `std()` = standard deviation
- `X`, `Y`, `Z` = direction of the signal on the three axes

For example:

- `tBodyAcc-mean()-X` means the mean of the body acceleration signal in the X direction in the time domain.
- `fBodyGyro-std()-Z` means the standard deviation of the body gyroscope signal in the Z direction in the frequency domain.

## 4. Missing Data Handling

The dataset did not contain missing values in the variables selected for analysis. The data files were loaded using `read.table()` without specifying any missing value parameters, and no NA values were encountered during processing.

Since no missing data was present, no imputation or removal of observations was necessary. All data points were used in creating the final tidy dataset.

## 5. Data Processing and Cleaning Steps

The dataset was cleaned and transformed using the following steps:

##### Step 1: Load Metadata

```r
activity_labels <- read.table(file.path(data_path, "activity_labels.txt"),
                              col.names = c("activity_id", "activity"))

features <- read.table(file.path(data_path, "features.txt"),
                       col.names = c("index", "feature_name"))
```
The metadata files were loaded to obtain descriptive activity names and feature variable names.

##### Step 2: Select Mean and Standard Deviation Features

```r
mean_std_features <- grep("-(mean|std)\\(\\)", features$feature_name)
selected_features <- features$feature_name[mean_std_features]
```
Only variables containing **mean()** or **std()** were selected. This reduced the dataset from 561 variables to 66 relevant measurement variables.

##### Step 3: Load Training Data

```r
X_train <- read.table(file.path(data_path, "train", "X_train.txt"))[, mean_std_features]
colnames(X_train) <- selected_features

y_train <- read.table(file.path(data_path, "train", "y_train.txt"),
                      col.names = "activity_id")

subject_train <- read.table(file.path(data_path, "train", "subject_train.txt"),
                            col.names = "subject")
```
The training dataset was loaded, including measurement data, activity labels, and subject identifiers. Only the selected mean and standard deviation variables were kept.

##### Step 4: Load Test Data

```r
X_test <- read.table(file.path(data_path, "test", "X_test.txt"))[, mean_std_features]
colnames(X_test) <- selected_features

y_test <- read.table(file.path(data_path, "test", "y_test.txt"),
                     col.names = "activity_id")

subject_test <- read.table(file.path(data_path, "test", "subject_test.txt"),
                           col.names = "subject")
```
The test dataset was loaded in the same way as the training dataset to ensure consistency.

##### Step 5: Merge Training and Test Datasets

```r
data_train <- cbind(subject_train, y_train, X_train)
data_test <- cbind(subject_test, y_test, X_test)

data_combined <- rbind(data_train, data_test)
```
The training and test datasets were combined into one dataset by binding columns and stacking rows together.

##### Step 6: Apply Descriptive Activity Names

```r
data_combined <- merge(data_combined, activity_labels,
                       by = "activity_id", all.x = TRUE)

data_combined$activity_id <- NULL
```
Numeric activity IDs were replaced with descriptive activity names to improve readability.

##### Step 7: Reorder Columns

```r
data_combined <- data_combined %>%
  select(subject, activity, everything())
```
The dataset was reorganized so that the subject and activity columns appear first, followed by the measurement variables.

##### Step 8: Create Tidy Dataset

```r
tidy_data <- data_combined %>%
  group_by(subject, activity) %>%
  summarise(across(everything(), mean), .groups = "drop")
```
The dataset was grouped by subject and activity, and the average of each measurement variable was calculated to create a tidy dataset.

##### Step 9: Save Final Dataset

```r
write.table(tidy_data, "tidy_dataset.txt", row.name = FALSE)
```
The final tidy dataset was saved as a text file for submission.

## 6. Code Instructions

To reproduce the dataset:

1. Open the R project in RStudio.
2. Ensure the folder `UCI HAR Dataset` is located in the project directory.
3. Open and run the script `GroupWork.R`.
4. The script will generate the output file `tidy_dataset.txt`.

Required package:

- dplyr

## 7. Analysis Description

The goal of this project was to transform raw data into a tidy dataset suitable for analysis.

The final dataset:

- Contains 180 rows (30 subjects × 6 activities)
- Contains 68 columns (subject, activity, and 66 measurement variables)

Each row represents one subject performing one activity, and each value represents the average of a measurement variable for that subject and activity.

This dataset can be used for further statistical analysis, visualization, or machine learning applications.

## 8. Final Dataset Summary

The final dataset follows tidy data principles:

- Each variable is stored in its own column
- Each observation is stored in its own row
- Each value is stored in a single cell

This structure makes the dataset easy to analyze and interpret.

