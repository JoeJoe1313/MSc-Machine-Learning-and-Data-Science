library("rstudioapi")
# using rstudioapi so there is no need to assume the working 
# directory is the same as the one of the current file
current_dir_path <- dirname(getSourceEditorContext()$path)
wmw_file_path <- paste(current_dir_path,"/wmw.R", sep="")
ALPHA = 0.01  # global constant for the significance threshold

source(wmw_file_path)

# get the paths of all datasets in data19
get_data19_dirs <- function(path) {
    return(list.dirs(
        path = path,
        full.names = TRUE,
        recursive = FALSE
    ))
}

# Applies the wmw function to every dataset, and collects the
# results in a dataframe with columns month and reject.
get_wmw_results <- function(datasets_paths, datasets_names) { 
    results_month <- list()
    results_reject <- list()
    for (i in 1:length(datasets_paths)) {
        dataset_path <- datasets_paths[i]
        dataset_name <- datasets_names[i]

        # read dataset
        dataset_df <- read.table(dataset_path, header = TRUE, sep = ",")
        # extract the month from the dataset name
        dataset_month <- regmatches(dataset_name,regexpr("_\\d{2}_",dataset_name))
        dataset_month <- as.integer(gsub("[^0-9]", "", dataset_month))

        dataset_unique_labels <- unique(dataset_df[,'label'])
        if (length(dataset_unique_labels) == 1) {
            reject <- FALSE
        } else if (length(dataset_unique_labels) >= 2) {
            # getting the first two unique labels
            # unique() returns values in order of appearance
            x <- dataset_df$value[which(dataset_df[,"label"] %in% dataset_unique_labels[1])]
            y <- dataset_df$value[which(dataset_df[,"label"] %in% dataset_unique_labels[2])]
            reject <- wmw(x, y, ALPHA)$reject
        } else {
            stop("There is no label data in one of the datasets!")
        }

        results_month <- append(results_month, dataset_month)
        results_reject <- append(results_reject, reject)
    }
    results_month <- unlist(results_month)
    results_reject <- unlist(results_reject)
    
    return(data.frame(results_month, results_reject))
}

results_df_transformations <- function(results_df) {
    # compute the total number of datasets for each month
    agg_total <- aggregate(results_df, list(results_df$results_month), FUN = length)
    total_df <- data.frame(month=agg_total$Group.1, total=agg_total$results_month)

    # compute the significant number of datasets for each month
    agg_significant <- aggregate(
        results_df[results_df$results_reject,],
        list(results_df[results_df$results_reject,]$results_month),
        FUN = length
    )
    significant_df <- data.frame(month=agg_significant$Group.1, significant=agg_significant$results_reject)

    # create a new dataframe with columns month, total, significant
    results <- merge(total_df, significant_df, by = "month", all = TRUE)
    # in the case of none significant months we would have None, so filling these values with 0
    results$significant[which(is.na(results$significant))] <- 0

    return(results)
}

process_files <- function(path, out) {
    
    data19_dirs <- get_data19_dirs(path)

    # get the paths and names of all .txt files
    datasets_paths <- list()
    datasets_names <- list()
    for (directory in data19_dirs) {
        dir_files <- list.files(
            path = directory,
            pattern = ".txt$",
            recursive = TRUE,
            full.names = TRUE
        )
        datasets_paths <- append(datasets_paths, dir_files)
        datasets_names <- append(datasets_names, basename(dir_files))
    }
    datasets_paths <- unlist(datasets_paths)
    datasets_names <- unlist(datasets_names)

    results_df <- get_wmw_results(datasets_paths, datasets_names)
    results <- results_df_transformations(results_df)

    # save the dataframe results as .csv with name out
    write.table(
        results,
        file = paste(current_dir_path,"/",out, sep=""),
        sep = ",",
        row.names = FALSE,
        quote=FALSE
    )
}

data19_path = paste(current_dir_path, "/../data19", sep = "")
process_files(path=data19_path, out="results.csv")
