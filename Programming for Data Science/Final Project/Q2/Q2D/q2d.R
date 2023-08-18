# S3 class `student`, stores the name and age of a student
student <- function(name="", age=0){
    structure(list(name=name, age=age), class="student")
}

# declare getName function
getName <- function(x) UseMethod("getName")
# implement getName function; returns name
getName.student <- function(x){
    return(x$name)
}


# R6 class `Student`, stores the name and age of a student
library(R6)

Student <- R6Class("Student",
    public = list(
        initialize = function(name="", age=0){
            private$name <- name
            private$age <- age
        },
        getName = function() {
            return(private$name)
        }
    ),
    private = list(
        name = NULL,
        age = NULL
    )
)
