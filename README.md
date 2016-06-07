# getting and cleaning dataset : project work

This repository contains the solution to "Getting and Cleaning Data" Coursera project. It contains a script called run_analysis.R which works as
follows:

*  Downloading the required dataset from a url if it does not already exist in the working directory
*  Loading the feature and activities information from files to tables
*  Selecting required features using regular expressions and finuning the features to the name desired.
*  loading the training and test data based on the selected features gotten in the previous step. The features contian either the mean or standard deviation.
*  Adding the activity and subject data for each dataset to the other columns (features) in the dataset.
*  Merging the train and test dataset by row.
*  Converting the activity and subject columns into factors
*  Saves the combined tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair to a new file called tidyDataset.csv.
