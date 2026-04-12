
############################################################
# Analysis:
# This script processes the Human Activity Recognition dataset
# collected from Samsung Galaxy S smartphones. The goal is to
# clean and transform the raw data into a tidy dataset.
#
# Key steps performed:
# 1. Load metadata (feature names and activity labels)
# 2. Extract only mean and standard deviation measurements
# 3. Load and merge training and test datasets
# 4. Replace activity IDs with descriptive activity names
# 5. Label variables clearly
# 6. Create a second tidy dataset with the average of each
#    variable for each subject and activity
# 7. Export the final tidy dataset for analysis
############################################################


# Load required package for data manipulation
library(dplyr)


# Set data path (location of unzipped dataset)
data_path <- "UCI HAR Dataset"


# -----------------------------
# Load metadata
# -----------------------------

# Load activity labels (maps activity IDs to descriptive names)
activity_labels <- read.table(
  file.path(data_path, "activity_labels.txt"),
  col.names = c("activity_id", "activity")
)

# Load feature names (sensor measurement labels)
features <- read.table(
  file.path(data_path, "features.txt"),
  col.names = c("index", "feature_name")
)


# -----------------------------
# Extract mean and std features
# -----------------------------

# Identify only features that contain mean() or std()
mean_std_features <- grep("-(mean|std)\\(\\)", features$feature_name)

# Store the corresponding feature names
selected_features <- features$feature_name[mean_std_features]


# -----------------------------
# Load training data
# -----------------------------

# Load training feature data and keep only selected columns
X_train <- read.table(file.path(data_path, "train", "X_train.txt"))[, mean_std_features]

# Assign descriptive column names
colnames(X_train) <- selected_features

# Load training activity labels
y_train <- read.table(
  file.path(data_path, "train", "y_train.txt"),
  col.names = "activity_id"
)

# Load training subject IDs
subject_train <- read.table(
  file.path(data_path, "train", "subject_train.txt"),
  col.names = "subject"
)


# -----------------------------
# Load test data
# -----------------------------

# Load test feature data and keep only selected columns
X_test <- read.table(file.path(data_path, "test", "X_test.txt"))[, mean_std_features]

# Assign descriptive column names
colnames(X_test) <- selected_features

# Load test activity labels
y_test <- read.table(
  file.path(data_path, "test", "y_test.txt"),
  col.names = "activity_id"
)

# Load test subject IDs
subject_test <- read.table(
  file.path(data_path, "test", "subject_test.txt"),
  col.names = "subject"
)


# -----------------------------
# Merge datasets
# -----------------------------

# Combine subject, activity, and measurements for training data
data_train <- cbind(subject_train, y_train, X_train)

# Combine subject, activity, and measurements for test data
data_test <- cbind(subject_test, y_test, X_test)

# Merge training and test datasets into one dataset
data_combined <- rbind(data_train, data_test)


# -----------------------------
# Apply descriptive activity names
# -----------------------------

# Merge with activity labels to replace activity IDs with names
data_combined <- merge(data_combined, activity_labels, by = "activity_id", all.x = TRUE)

# Remove the numeric activity_id column (no longer needed)
data_combined$activity_id <- NULL


# -----------------------------
# Clean and organize dataset
# -----------------------------

# Reorder columns to place subject and activity first
data_combined <- data_combined %>%
  select(subject, activity, everything())


# -----------------------------
# Create tidy dataset
# -----------------------------

# Group by subject and activity, then compute mean of each variable
tidy_data <- data_combined %>%
  group_by(subject, activity) %>%
  summarise(across(everything(), mean), .groups = "drop")


# -----------------------------
# Export final dataset
# -----------------------------

# Save tidy dataset to file
write.table(tidy_data, "tidy_dataset.txt", row.name = FALSE)


# -----------------------------
# Validation checks
# -----------------------------

# Print dimensions of datasets to verify structure
print(dim(data_combined))  # Combined dataset size
print(dim(tidy_data))      # Tidy dataset size

# Preview first few rows of tidy dataset
print(head(tidy_data))
