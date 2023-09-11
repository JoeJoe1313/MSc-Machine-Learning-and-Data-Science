# Joana Levtcheva, CID 01252821


class Moment:
    """Stores the sample mean and variance, updates sequentially

    Attributes:
    - n: Number of observations
    - xbar: Sample mean of the observations
    - s2: Sample variance of the observations

    Methods:
    - __init__: Initialise a moment object
    - __str__: Return the string representation of the object
    - getSize: Get the size value of the object
    - getMean: Get the sample mean value of the object
    - getVariance: Get the sample varaince value of the object
    - update: Update estimates for sample mean and sample variance
    """

    def __init__(self):
        """Initialise moment object"""
        self.n = 0
        self.xbar = 0
        self.s2 = 0

    def __str__(self) -> str:
        """Return the string representation of the object"""
        return f"Moment object:\n  Size: {self.n}\n  Mean: {self.xbar}\n  Variance: {self.s2}"

    def getSize(self):
        """Get the size value of the object"""
        return self.n

    def getMean(self):
        """Get the sample mean value of the object"""
        return self.xbar

    def getVariance(self):
        """Get the sample variance value of the object"""
        return self.s2

    def update(self, x):
        """Update estimates for sample mean and sample variance"""
        self.n += 1
        # s2 only holds for n >= 2
        if self.n >= 2:
            self.s2 = (
                self.n * (self.n - 2) * self.s2 + (self.n - 1) * ((x - self.xbar) ** 2)
            ) / (self.n * (self.n - 1))
        self.xbar = ((self.n - 1) * self.xbar + x) / self.n
