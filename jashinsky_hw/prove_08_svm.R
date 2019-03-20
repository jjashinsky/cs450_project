install.packages("e1071", dependencies = TRUE)

# load libraries
pacman::p_load(tidyverse, e1071, mltools, data.table, caret, dummies)

# get data
vowels <- read_csv("vowel.csv")
letters <- read_csv("letters.csv")

dmy <- dummyVars( ~ Speaker + Sex, data = vowels)
trsf <- data.frame(predict(dmy, newdata = vowels))
vowels <- cbind(trsf, vowels %>% select(-Sex, -Speaker))


# get indexes of test samples
rows <- 1:nrow(vowels)
test_rows <- sample(rows, trunc(length(rows) * 0.3))

# get test data
vowels_test <- vowels[test_rows, ]
# get train data
vowels_train <- vowels[-test_rows,]

# scaling the features
preObj <- preProcess(vowels_train[, -28], method = c("center", "scale"))
vowels_train[, -28] <- predict(preObj, vowels_train[, -28])
vowels_test[, -28] <- predict(preObj, vowels_test[, -28])

g <- c(2^-10, 2^-5, 2^-1, 2, 2^5)
i <- c(2^-5, 2^-1, 2, 2^2, 2^5)

for (gam in g) {
  for (cost in i) {
    model <- svm(Class~., data = vowels_train, kernel = "radial", gamma = gam, cost = cost, type = "C")
    prediction <- predict(model, vowels_test[,-28])
    agreement <- prediction == vowels_test$Class
    accuracy <- prop.table(table(agreement))
    print(gam)
    print(cost)
    print(accuracy)
  }
}

confusionMatrix <- table(pred = prediction, true = vowels_test$Class)
confusionMatrix




# Now the letterd data set

# get data
letters <- read_csv("letters.csv")

# get indexes of test samples
letters_sample <- sample_n(letters, size = 2000)

rows <- 1:nrow(letters_sample)
test_rows <- sample(rows, trunc(length(rows) * 0.40))

# get test data
letters_test <- letters_sample[test_rows, ]
# get train data
letters_train <- letters_sample[-test_rows,]

preObj <- preProcess(letters_train[, -1], method = c("scale"))
letters_train[, -1] <- predict(preObj, letters_train[, -1])
letters_test[, -1] <- predict(preObj, letters_test[, -1])

g <- c(2^-10, 2^-5, 2^-1, 2, 2^5)
i <- c(2^-5, 2^-1, 2, 2^2, 2^5)

for (gam in g) {
  for (cost in i) {
    model <- svm(letter~., data = letters_train, kernel = "radial", gamma = gam, cost = cost, type = "C")
    prediction <- predict(model, letters_test[,-1])
    agreement <- prediction == letters_test$letter
    accuracy <- prop.table(table(agreement))
    print(gam)
    print(cost)
    print(accuracy)
  }
}

g <- c(2^-5, 2^-4, 2^-3, 2^-2, 2^-1)
i <- c(2, 2^2, 2^3, 2^4, 2^5)

for (gam in g) {
  for (cost in i) {
    model <- svm(letter~., data = letters_train, kernel = "radial", gamma = gam, cost = cost, type = "C")
    prediction <- predict(model, letters_test[,-1])
    agreement <- prediction == letters_test$letter
    accuracy <- prop.table(table(agreement))
    print(gam)
    print(cost)
    print(accuracy)
  }
}

g <- c(2^-4.5, 2^-4, 2^-3.5)
i <- c(2^3, 2^4, 2^5, 2^6)

for (gam in g) {
  for (cost in i) {
    model <- svm(letter~., data = letters_train, kernel = "radial", gamma = gam, cost = cost, type = "C")
    prediction <- predict(model, letters_test[,-1])
    agreement <- prediction == letters_test$letter
    accuracy <- prop.table(table(agreement))
    print(gam)
    print(cost)
    print(accuracy)
  }
}


confusionMatrix <- table(pred = prediction, true = letters_test$letter)
confusionMatrix


model <- svm(letter~., data = letters_train, kernel = "radial", gamma = .5, cost = 2, type = "C")
prediction <- predict(model, letters_test[,-1])
agreement <- prediction == letters_test$letter
accuracy <- prop.table(table(agreement))
print(gam)
print(cost)
print(accuracy)

# trying with the full dataset now that I narrowed some things down

letters <- read_csv("letters.csv")

rows <- 1:nrow(letters)
test_rows <- sample(rows, trunc(length(rows) * 0.40))

# get test data
letters_test <- letters[test_rows, ]
# get train data
letters_train <- letters[-test_rows,]

preObj <- preProcess(letters_train[, -1], method = c("scale"))
letters_train[, -1] <- predict(preObj, letters_train[, -1])
letters_test[, -1] <- predict(preObj, letters_test[, -1])


model <- svm(letter~., data = letters_train, kernel = "radial", gamma = .04419417, cost = 8, type = "C")
prediction <- predict(model, letters_test[,-1])
agreement <- prediction == letters_test$letter
accuracy <- prop.table(table(agreement))
print(accuracy)
