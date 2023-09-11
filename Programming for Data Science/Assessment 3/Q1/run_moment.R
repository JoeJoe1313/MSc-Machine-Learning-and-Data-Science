# Joana Levtcheva, CID 01252821


testthat::test_file("test_momentS3.R")

# creating a new moment object m1 and updating it with two observation
m1 <- moment()
m1 <- update(m1, 5)
m1 <- update(m1, 3)
print(m1)

# creating a deep copy of m1
m2 <- m1
m1 <- update(m1, 2)
print(m1)
print(m2)
# updating m1 didn't update the m2 deep copy
