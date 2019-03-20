pacman::p_load(tidyverse, arules)

data(Groceries)

Groceries

summary(Groceries)

inspect(Groceries[1:5])

itemFrequencyPlot(Groceries, topN = 30)

image(Groceries[1:200])

image(Groceries[1:300])

my_rules <- apriori(Groceries, 
                    parameter = list(support = .1,
                                     confidence = .6,
                                     minlen = 2))
# 0 rules

# 3 purchases for 30 days = 180 transactions
3 * 30
90/9835
# 0.009150991

# sopme trials

my_rules <- apriori(Groceries, 
                    parameter = list(support = .0092,
                                     confidence = .6,
                                     minlen = 2))
inspect(my_rules)

# some trials
# more experimenting with numbers has been done that is not shown here

my_rules <- apriori(Groceries, 
                    parameter = list(support = .006,
                                     confidence = .20,
                                     minlen = 2))

inspect(sort(my_rules, by = "lift")[1:5])
inspect(sort(my_rules, by = "support")[1:5])
inspect(sort(my_rules, by = "confidence")[1:5])


# my final selection of parameters and rules

my_rules <- apriori(Groceries, 
                    parameter = list(support = .003,
                                     confidence = .5,
                                     minlen = 2))

subset <- subset(my_rules,	items	%in%	"chicken")

inspect(sort(my_rules, by = "lift")[1:5])
inspect(sort(my_rules, by = "support")[1:5])
inspect(sort(my_rules, by = "confidence")[1:5])
inspect(sort(subset, by = "lift")[1:5])

