# getdata-035
Coursera Get Data exercise


## Description of process run_analysis.R

We use the dplyr package for data transformation.

First read in all the raw files which have relevant data:
activity_labels
features.txt
X_test.txt
y_test.txt
subject_test.txt
X_train.txt
y_train.txt
subject_train.txt

The data is then filtered by searching for either std or mean in the column name using the grep function on all column names, and using this variable to further subset the columns

The resulting dataframe for test & training is then combined to give the larger data set, and this is then passed over to group by for summarising by all the variables.


