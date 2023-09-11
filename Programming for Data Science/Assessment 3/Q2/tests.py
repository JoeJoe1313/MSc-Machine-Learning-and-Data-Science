# Joana Levtcheva, CID 01252821


import unittest

import numpy as np

from moment import Moment


tol = 1e-5  # specifying tolerance


class MomentTests(unittest.TestCase):
    """Unit tests for the Moment class"""

    def test_creating(self):
        """Test 1: creating moment object"""
        m = Moment()

        self.assertEqual(m.getSize(), 0)
        self.assertAlmostEqual(m.getMean(), 0, delta=tol)
        self.assertAlmostEqual(m.getVariance(), 0, delta=tol)

    def test_one_update(self):
        """Test 2: updating moment with one observation"""
        m = Moment()
        m.update(5)

        self.assertEqual(m.getSize(), 1)
        self.assertAlmostEqual(m.getMean(), 5, delta=tol)
        self.assertAlmostEqual(m.getVariance(), 0, delta=tol)

    def test_two_updates(self):
        """Test 3: updating moment with two observations"""
        m = Moment()
        m.update(5)
        m.update(3)

        self.assertEqual(m.getSize(), 2)
        self.assertAlmostEqual(m.getMean(), 4, delta=tol)
        self.assertAlmostEqual(m.getVariance(), 2, delta=tol)

    def test_normal_distribution_sample(self):
        """Test 4: updating moment with 50 observations drawn
        from a normal distribution with mean = 0 and variance = 1
        """
        m = Moment()
        np.random.seed(1)
        x = np.random.normal(loc=0, scale=1, size=50)
        for element in x:
            m.update(element)

        self.assertEqual(m.getSize(), 50)
        self.assertAlmostEqual(m.getMean(), -0.02551484800765029, delta=tol)
        self.assertAlmostEqual(m.getVariance(), 0.9592891608441553, delta=tol)


if __name__ == "__main__":

    unittest.main()
