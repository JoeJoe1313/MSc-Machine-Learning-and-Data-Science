import os
import re
from datetime import datetime
from typing import List, Tuple

import pandas as pd

from wmw import wmw

ALPHA = 0.01  # global constant for the significance threshold


def get_datasets_list(path: str) -> List[Tuple[str, str]]:
    """Gets the paths and names, as a list of tuples, of all
    .txt files in the data19 directory given by the path argument.
    """
    datasets_list = []
    for subdir, _, files in os.walk(path):
        for file in files:
            dataset_path = os.path.join(subdir, file)
            datasets_list.append((dataset_path, file))

    return datasets_list


def get_wmw_results(datasets_list) -> pd.DataFrame:
    """Applies the wmw function to every dataset, and
    collects the results in a dataframe with columns
    month and reject.
    """
    results_list = []
    for dataset_path, file_name in datasets_list:
        dataset_df = pd.read_csv(dataset_path)

        # extract the month from the dataset name
        match = re.search(r"\d{4}_\d{2}_\d{2}", file_name)
        month = datetime.strptime(match.group(), "%Y_%m_%d").month

        dataset_unique_labels = dataset_df["label"].unique()
        if len(dataset_unique_labels) == 1:
            reject = False
        elif len(dataset_unique_labels) >= 2:
            # getting the first two unique labels
            # unique() returns values in order of appearance
            dataset_df = dataset_df[
                dataset_df["label"].isin(dataset_df["label"].unique()[:2])
            ]
            x, y = dataset_df.groupby("label").apply(lambda x: list(x["value"].values))
            reject = wmw(x, y, ALPHA).reject
        else:
            raise Exception("There is no label data in one of the datasets!")

        results_list.append({"month": month, "reject": reject})

    return pd.DataFrame(results_list)


def results_df_transformations(results_df: pd.DataFrame) -> pd.DataFrame:
    """Computes the total number of datasets for each month,
    computes the significant number of datasets for each month,
    creates a new dataframe with columns month, total, significant.
    """
    results_df_total = (
        results_df.groupby(["month"])["reject"].count().reset_index(name="total")
    )
    results_df_significant = (
        results_df[results_df["reject"] == True]
        .groupby(["month"])["reject"]
        .count()
        .reset_index(name="significant")
    )
    # specifying outer merge because there might be a month with datasets none of which are signifcant
    results = pd.merge(results_df_total, results_df_significant, how="outer")
    # in the case of none significant months we would have None, so filling these values with 0
    results["significant"] = results["significant"].fillna(0)

    return results


def process_files(path: str, out: str) -> None:
    """Applies the wmw function to every dataset in a given directory
    (specified by the path argument), collects the results by month (month, reject),
    creates a .csv file with name the out argument, with columns month, total, significant.

    Args:
        path (str): the path to the data folder
        out (str): the name of the file to which the results will be saved
    """

    datasets_list = get_datasets_list(path)
    results_df = get_wmw_results(datasets_list)
    results = results_df_transformations(results_df)

    results.to_csv(out, index=False)
