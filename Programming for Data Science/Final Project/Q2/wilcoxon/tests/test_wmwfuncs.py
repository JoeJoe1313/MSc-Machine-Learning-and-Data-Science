import unittest

from wilcoxon import wmw, WMW


class WMWTests(unittest.TestCase):
    """Unit tests for the WMW class and wmw function"""

    def test_create_wmw_object(self):
        """Test 1: create a WMWS3 object"""
        actual = WMW(2, True)
        self.assertEqual(actual.stat, 2)
        self.assertEqual(actual.reject, True)

    def test_eq_wmw_objects(self):
        """Test 2: two equal WMW objects"""
        self.assertEqual(WMW(2, True), WMW(2, True))

    def test_not_eq_wmw_objects(self):
        """Test 3: two not equal WMW objects"""
        self.assertNotEqual(WMW(2, True), WMW(2, False))
    
    def test_different_types_eq(self):
        """Test 4: WMW object and not a WMW object"""
        self.assertNotEqual(WMW(2, True), 5)

    def test_wmwfunc(self):
        """Test 5: function wmw with all correct inputs"""
        actual = wmw(x=[2.1, 7.2, 4.3], y=[1.4, 2.1, 5.6, 8.7], alpha=0.05)
        expected = WMW(6.5, False)

        self.assertEqual(actual, expected)

    def test_wmw_incorrect_alpha(self):
        """Test 6: function wmw with incorrect alpha"""
        self.assertRaisesRegex(
            Exception,
            "Alpha is not in the open interval 0 to 1!",
            wmw,
            [2.1, 7.2, 4.3],
            [1.4, 2.1, 5.6, 8.7],
            0,
        )

    def test_wmw_incorrect_x_type(self):
        """Test 7: function wmw with incorrect x type"""
        self.assertRaisesRegex(
            Exception,
            "The input x is not of type list!",
            wmw,
            (5, 6),
            [1.4, 2.1, 5.6, 8.7],
            0.05,
        )

    def test_wmw_incorrect_y_type(self):
        """Test 8: function wmw with incorrect y type"""
        self.assertRaisesRegex(
            Exception,
            "The input y is not of type list!",
            wmw,
            [2.1, 7.2, 4.3],
            3,
            0.05,
        )

    def test_wmw_wrong_element_types_of_x(self):
        """Test 9: function wmw with x containing not number elements"""
        self.assertRaisesRegex(
            Exception,
            "The input x contains not number elements!",
            wmw,
            [2.1, "v", 4.3],
            [1.4, 2.1, 5.6, 8.7],
            0.05,
        )

    def test_wmw_wrong_element_types_of_y(self):
        """Test 10: function wmw with y containing not number elements"""
        self.assertRaisesRegex(
            Exception,
            "The input y contains not number elements!",
            wmw,
            [2.1, 2, 4.3],
            [1.4, 2.1, "g", 8.7],
            0.05,
        )

    def test_wmw_wrong_element_types_of_x_and_y(self):
        """Test 11: function wmw with x and y containing not number elements"""
        self.assertRaisesRegex(
            Exception,
            "The input x contains not number elements!",
            wmw,
            ["v", 2, 4.3],
            [1.4, 2.1, "g", 8.7],
            0.05,
        )
