# Joana Levtcheva, CID 01252821


import numbers
from typing import List

import numpy as np
import pandas as pd
from scipy.stats import norm


class WMW:
    """Stores Wilcoxon-Mann-Whitney (WMW) test information, WMW statistic
    and whether the null hypothesis had been rejected.

    Attributes:
    - stat: the value of the Wilcoxon-Mann-Whitney statistic
    - reject: a boolean which is True if the null hypothesis is rejected, and False otherwise

    Methods:
    - __init__: Initialise a WMW object
    - wmw: Computing the Wilcoxon-Mann-Whitney statistic, and whether the null hypothesis had been rejected
    """

    def __init__(self, stat, reject) -> None:
        """Initialise WMW object"""
        self.stat = stat
        self.reject = reject

    def __eq__(self, __o: object) -> bool:
        if isinstance(__o, WMW):
            return self.stat == __o.stat and self.reject == __o.reject

        return False


def check_inputs(x: List[float], y: List[float], alpha: float) -> None:
    if alpha <= 0 or alpha >= 1:
        raise Exception("Alpha is not in the open interval 0 to 1!")

    if not isinstance(x, list):
        raise Exception("The input x is not of type list!")

    if not isinstance(y, list):
        raise Exception("The input y is not of type list!")

    if not all(isinstance(el, numbers.Number) for el in x):
        raise Exception("The input x contains not number elements!")

    if not all(isinstance(el, numbers.Number) for el in y):
        raise Exception("The input y contains not number elements!")


def wmw(x: List[float], y: List[float], alpha: float) -> WMW:
    """Function for computing the Wilcoxon-Mann-Whitney statistic.

    Args:
        x (List[float]): a list representing the data for the first label
        y (List[float]): a list representing the data for the second label
        alpha (float): a significance threshold

    Returns:
        WMW: WMW object with the calculated stat and reject values 
    """
    check_inputs(x, y, alpha)

    x_df = pd.DataFrame(data={"x_values": x, "is_x_value": True})
    y_df = pd.DataFrame(data={"y_values": y, "is_x_value": False})

    df = pd.concat([x_df, y_df], axis=0)
    df["z_values"] = x + y
    df["ranked_z_values"] = df["z_values"].rank(method="average")

    n = len(x)
    m = len(y)

    x_ranks_sum = df[df["is_x_value"]]["ranked_z_values"].sum()
    w = x_ranks_sum - n * (n + 1) / 2

    mu = n * m / 2
    sigma_squared = n * m * (n + m + 1) / 12
    sigma = np.sqrt(sigma_squared)

    l_alpha = norm.ppf(q=alpha / 2, loc=mu, scale=sigma)
    u_alpha = norm.ppf(q=1 - alpha / 2, loc=mu, scale=sigma)

    reject = w < l_alpha or w > u_alpha

    return WMW(w, reject)
