
# Load required package
library(dplyr)

# Set data path
data_path <- "UCI HAR Dataset"

# Load metadata
activity_labels <- read.table(
  file.path(data_path, "activity_labels.txt"),
  col.names = c("activity_id", "activity")
)

features <- read.table(
  file.path(data_path, "features.txt"),
  col.names = c("index", "feature_name")
)

# Extract mean() and std() features
mean_std_features <- grep("-(mean|std)\\(\\)", features$feature_name)
selected_features <- features$feature_name[mean_std_features]

# Load training data
X_train <- read.table(file.path(data_path, "train", "X_train.txt"))[, mean_std_features]
colnames(X_train) <- selected_features

y_train <- read.table(
  file.path(data_path, "train", "y_train.txt"),
  col.names = "activity_id"
)

subject_train <- read.table(
  file.path(data_path, "train", "subject_train.txt"),
  col.names = "subject"
)

# Load test data
X_test <- read.table(file.path(data_path, "test", "X_test.txt"))[, mean_std_features]
colnames(X_test) <- selected_features

y_test <- read.table(
  file.path(data_path, "test", "y_test.txt"),
  col.names = "activity_id"
)

subject_test <- read.table(
  file.path(data_path, "test", "subject_test.txt"),
  col.names = "subject"
)

# Merge training and test data
data_train <- cbind(subject_train, y_train, X_train)
data_test <- cbind(subject_test, y_test, X_test)
data_combined <- rbind(data_train, data_test)

# Add descriptive activity names
data_combined <- merge(data_combined, activity_labels, by = "activity_id", all.x = TRUE)
data_combined$activity_id <- NULL

# Reorder columns
data_combined <- data_combined %>%
  select(subject, activity, everything())

# Create tidy dataset with averages for each subject and activity
tidy_data <- data_combined %>%
  group_by(subject, activity) %>%
  summarise(across(everything(), mean), .groups = "drop")

# Save tidy dataset
write.table(tidy_data, "tidy_dataset.txt", row.name = FALSE)

# Check results
print(dim(data_combined))
print(dim(tidy_data))
print(head(tidy_data))