class Student:
    """Stores the name and age of a student

    Contains attributes:
      - name: name of the student
      - age: age of the student

    functions:
      - __init__
      - getName()
    """

    def __init__(self, name="", age=0):
        """Initialise moment object"""
        self.name = name
        self.age = age

    def getName(self):
        """Get the name of the student"""
        return self.name
