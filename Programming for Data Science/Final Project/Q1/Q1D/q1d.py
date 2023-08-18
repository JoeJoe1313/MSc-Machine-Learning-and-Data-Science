import numpy as np
import pandas as pd
from scipy.stats import norm

# function taken from wmw.py and modified a little (removed inputs checks,
# doesn't return WMW object) for example purposes
def wmw(x, y, alpha):
    """Function for computing the Wilcoxon-Mann-Whitney statistic.
    Args:
        x (List[float]): a list representing the data for the first label
        y (List[float]): a list representing the data for the second label
        alpha (float): a significance threshold
    Returns:
        WMW: WMW object with the calculated stat and reject values
    """

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

    return (w, reject)


if __name__ == "__main__":

    x = [2.1, 7.2, 4.3]
    y = [1.4, 2.1, 5.6, 8.7]

    w, reject = wmw(x, y, 0.05)

    print(f"w = {w}")
    print(f"reject = {reject}")
