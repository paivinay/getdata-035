library(dplyr)

## Common data frames - activity and features file

# Read the activity labels file, and set appropriate column names
activity_labels   <- read.table("UCI HAR Dataset/activity_labels.txt", sep = "" , header = F)
colnames(activity_labels) <- c("activity_id", "activity_name")

# Read the features file which has all column names for the main data set
# This will be used to filter the set of columns which have std or mean in them later
all_column_names = read.table("UCI HAR Dataset/features.txt", header = FALSE)
names(all_column_names) <- c("column_index", "column_name")
std_mean_columns <- all_column_names[grep("std|mean", all_column_names$column_name),]

# Read the main test data set into a dataframe
test_df                       <- read.table("UCI HAR Dataset/test/X_test.txt", sep = "" , header = F)
# Subset to only relevant columsn from test df
test_df_std_mean_cols         <- test_df[, std_mean_columns$column_index]

# Give relevant column names as per features.txt
colnames(test_df_std_mean_cols) <- std_mean_columns$column_name

# Read the activity slice for the test dataframe
test_df_activity              <- read.table("UCI HAR Dataset/test/y_test.txt", sep = "" , header = F)
colnames(test_df_activity)    <- c("activity_id")

# Joins the two data (on activity_id) set while also preserving the original data sequence from test_df_activity
merged_test_df_activity <-inner_join(test_df_activity, activity_labels)

# Read the subject id for the test dataframe
test_df_subject               <- read.table("UCI HAR Dataset/test/subject_test.txt", sep = "" , header = F)
colnames(test_df_subject)     <- c("subject_id")

# We now have the test data set prepared in following dataframes:
# test_df_std_mean_cols has main data
# merged_test_df_activity has activity performed with label (walking / standing...)
# test_df_subject has the subject id

combined_test_df <- cbind(test_df_subject, merged_test_df_activity, test_df_std_mean_cols)

## Now repeat the same set of steps for train data set

# Read the main train data set into a dataframe
train_df                       <- read.table("UCI HAR Dataset/train/X_train.txt", sep = "" , header = F)
# Subset to only relevant columns from train df
train_df_std_mean_cols         <- train_df[, std_mean_columns$column_index]

# Give relevant column names as per features.txt
colnames(train_df_std_mean_cols) <- std_mean_columns$column_name

# Read the activity slice for the test dataframe
train_df_activity              <- read.table("UCI HAR Dataset/train/y_train.txt", sep = "" , header = F)
colnames(train_df_activity)    <- c("activity_id")

# Joins the two data (on activity_id) set while also preserving the original data sequence from train_df_activity
merged_train_df_activity <-inner_join(train_df_activity, activity_labels)

# Read the subject id for the test dataframe
train_df_subject               <- read.table("UCI HAR Dataset/train/subject_train.txt", sep = "" , header = F)
colnames(train_df_subject)     <- c("subject_id")

# We now have the train data set prepared in following dataframes:
# train_df_std_mean_cols has main data
# merged_train_df_activity has activity performed with label (walking / standing...)
# train_df_subject has the subject id

combined_train_df <- cbind(train_df_subject, merged_train_df_activity, train_df_std_mean_cols)


# Now rbind the two train & test data sets to create one single data set
combined_test_train_df <- rbind(combined_test_df, combined_train_df)

# Remove the column activity_name before summarising
combined_test_train_df <- combined_test_train_df[, -3]

tidy_ds <- combined_test_train_df %>% group_by(activity_id, subject_id) %>% summarise_each(funs(mean))

# Write the results back to a flat file
write.table(tidy_ds, "./tidy.txt",row.name=FALSE)
