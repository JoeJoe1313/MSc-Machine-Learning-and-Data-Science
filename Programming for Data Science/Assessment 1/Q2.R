##============================================================================##
## MATH70094 Programming for Data Science Assessment 1 Question 2 2022
# Joana Tchavdarova Levtcheva
# CID 01252821
##============================================================================##

##============================================================================##
# Do not edit this code block
mytext <- paste0("It wa5 th3 b35t of t!m35, !t wa5 th3 wor5t of t!m35, !t wa5 ", 
                 "th3 ag3 of w!5dom, !t wa5 th3 ag3 of fool!5hn355, !t wa5 ", 
                 "th3 3poch of b3l!3f, !t wa5 th3 3poch of !ncr3dul!ty, !t ", 
                 "wa5 th3 53a5on of L!ght, !t wa5 th3 53a5on of Darkn355, !t ", 
                 "wa5 th3 5pr!ng of hop3, !t wa5 th3 w!nt3r of d35pa!r, w3 ", 
                 "had 3v3ryth!ng b3for3 u5, w3 had noth!ng b3for3 u5, w3 w3r3 ", 
                 "all go!ng d!r3ct to H3av3n, w3 w3r3 all go!ng d!r3ct th3 ", 
                 "oth3r way - !n 5hort, th3 p3r!od wa5 5o far l!k3 th3 ", 
                 "pr353nt p3r!od, that 5om3 of !t5 no!5!35t author!t!35 ", 
                 "!n5!5t3d on !t5 b3!ng r3c3!v3d, for good or for 3v!l, ", 
                 "!n th3 5up3rlat!v3 d3gr33 of compar!5on only.")
# Do not edit this code block
##============================================================================##


##=============================================================##
## Part A 

mytext_fixed = gsub("3", "e", mytext)
mytext_fixed = gsub("!", "i", mytext_fixed)
mytext_fixed = gsub("5", "s", mytext_fixed)
print(mytext_fixed)

##=============================================================##


##=============================================================##
## Part B 

# for loop iterating over a list please
mytext_fixed_no_punc = gsub("-", "", mytext_fixed)
mytext_fixed_no_punc = gsub(",", "", mytext_fixed_no_punc)
mytext_fixed_no_punc = gsub("[.]", "", mytext_fixed_no_punc)
print(mytext_fixed_no_punc)

##=============================================================##


##=============================================================##
## Part C (i)

mytext_fixed_no_punc_words = strsplit(mytext_fixed_no_punc, " ")[[1]]

# Approach 1
match_the = grep("\\<the\\>", mytext_fixed_no_punc_words)
count_the = length(match_the)
print(count_the)

# Approach 2
count_the = 0
for (element in mytext_fixed_no_punc_words) {
  if (element == 'the') {
    count_the = count_the + 1
  }
}
print(count_the)


##=============================================================##


##=============================================================##
## Part C(ii)

second_to_last_the_index = rev(match_the)[2]
current_index = 0
for (i in  1:length(mytext_fixed_no_punc_words)) {
  if (i != second_to_last_the_index) {
    current_index = current_index + nchar(mytext_fixed_no_punc_words[i]) + 1
  } else {
    my_the_index = current_index + 1
    break
  }
}
print(my_the_index)

##=============================================================##


##=============================================================##
## Part D 

letter_start_index = 244
count_index = 0
for (word in mytext_fixed_no_punc_words) {
  if (count_index + 1 != letter_start_index) {
    count_index = count_index + nchar(word) + 1
  } else {
    myword = word
    break
  }
}
print(myword)

##=============================================================##


##=============================================================##
## Part E (i) 
mytext_fixed_no_punc_no_whitesapces = gsub(" ", "", mytext_fixed_no_punc)
mychar_vec = strsplit(mytext_fixed_no_punc_no_whitesapces, "")[[1]]
print(mychar_vec)

##=============================================================##


##=============================================================##
## Part E (ii) 
mychar_vec_lower = tolower(mychar_vec)
counts = table(mychar_vec_lower)
print(counts)
##=============================================================##


##=============================================================##
## Part E (iii) 

show_counts <-function(mychar_vec) {
  print("Counts")
  print("------")
  for (letter in sort(unique(mychar_vec_lower))){
    x <- sprintf("%s: %s", letter, counts[[letter]])
    print(x)
  }
}

show_counts(mychar_vec)

##=============================================================##


##=============================================================##
## Part F 
vowels = c("a", "e", "i", "o", "u")
vowel_counts <- c()
for (vowel in vowels) {
  vowel_counts <- c(vowel_counts, counts[vowel])
}

barplot(vowel_counts, main="Vowels Distribution", xlab="Vowels")
##=============================================================##


##=============================================================##
## Code clarity

## Remember to strive for clarity of your code and use comments 
## where appropriate.
##=============================================================##


