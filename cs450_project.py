# -*- coding: utf-8 -*-
"""
Created on Fri Mar 22 02:19:15 2019

@author: Isaac
"""

# -*- coding: utf-8 -*-
"""
Created on Sat Mar  2 00:55:54 2019

@author: Isaac
"""


import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score
from sklearn import preprocessing
import copy
import pydotplus
from sklearn import tree
from collections import Counter
from sklearn.neural_network import MLPClassifier 
from sklearn.tree import export_graphviz
from sklearn.ensemble import BaggingClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import AdaBoostClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn import svm







def getProjectData():
    project_data = pd.read_csv('C:/Users/Owner/Desktop/Isaac School/CS 450/Project/cs450_project/derived_data/game_data_ml.csv')
    return project_data

def getProjectPredictionData():
    project_data = pd.read_csv('C:/Users/Owner/Desktop/Isaac School/CS 450/Project/cs450_project/data/FinalData.csv')
    return project_data



def dataTargetSplit(data, target_column_name):
    X = data.drop(columns=[target_column_name]).values
    y = data[target_column_name].values.flatten()
    return (X, y)

def split_data(data, target_column_name):
    X, y = dataTargetSplit(data, target_column_name)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
    return (X_train, X_test, y_train, y_test)

def split_data_x_y(X, y):
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
    return (X_train, X_test, y_train, y_test)

def evaluate_predictions(targets_predicted, answers, show_values, name_classifier = ""):
    print(name_classifier)
    predictions = copy.deepcopy(targets_predicted)
    i = 0
    for predicted in targets_predicted:
        if predicted == answers[i]:
            predictions[i] = 1
        else:
            predictions[i] = 0
        i += 1
    if show_values == True:
        print(predictions)
    correct = sum(predictions)
    data_set_value = Counter(targets_predicted).keys()
    data_set_values = []
    for num in data_set_value:
        data_set_values.append(num)
    TP = 0
    FP = 0
    TN = 0
    FN = 0
    positive = 0
    negative = 0
    for i in range(len(answers)):
        added = True
        for v in data_set_values:
            if added:
                if targets_predicted[i]==answers[i]==data_set_values[data_set_values.index(v)]:
                    positive += 1
                    TP += 1
                    added = False
                    break
                if answers[i]==data_set_values[data_set_values.index(v)] and targets_predicted[i]!=answers[i]:
                    negative += 1
                    FP += 1
                    added = False
                    break
                if targets_predicted[i]==answers[i]!=data_set_values[data_set_values.index(v)]:
                    negative += 1
                    TN += 1
                    added = False
                    break
                if answers[i]!=data_set_values[data_set_values.index(v)] and targets_predicted[i]!=answers[i]:
                    positive += 1
                    FN += 1
                    added = False
                    break
    if positive == 0:
        positive = 1
    if negative == 0:
        negative = 1
    print("Single Run Prediction Accuracy: {:.1f}%" .format((correct/len(predictions))*100))
    print("True Positive rate: {:.1f}%" .format((TP/positive)*100))
    print("False Positive rate: {:.1f}%" .format((FP/negative)*100))
    print("True Negative rate: {:.1f}%" .format((TN/negative)*100))
    print("False Negative rate: {:.1f}%" .format((FN/positive)*100))
    print("True Positive count: {}" .format(TP))
    print("False Positive count: {}" .format(FP))
    print("True Negative count: {}" .format(TN))
    print("False Negative count: {}" .format(FN))
    print("Total: {}" .format(i))
    data_values = Counter(targets_predicted).values()
    print(data_values)
    print("")
    
    
    
    

def standardizeData(scaling_data, data):
    std_scale = preprocessing.StandardScaler().fit(scaling_data)
    X_train_std = std_scale.transform(data)
    train_std = X_train_std.tolist()
    return train_std



def main():
    project_data = getProjectData()
    prediction_data = getProjectPredictionData()
    
    X_data, y_data = dataTargetSplit(project_data, "team1_win")
    X_train, X_test, y_train, y_test = split_data(project_data, "team1_win")
    
    X_data_prediction, y_data_prediction = dataTargetSplit(prediction_data, "team1_win")

#    X_train_std = standardizeData(X_train, X_train)
#    X_test_std = standardizeData(X_train, X_test)


#CTRL + 4 will comment out a block of code
#CTRL + 5 will uncomment out a block of code

    #Decision Tree Classifier
# =============================================================================
#     decisionTreeClassifier = DecisionTreeClassifier(criterion='entropy', random_state=0, max_depth=5)
#     
#     scores = cross_val_score(decisionTreeClassifier, X_data, y_data, cv=5)
#     print("Cross Validation Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))
#     decisionTreeClassifier.fit(X_train, y_train)
#     predictions = decisionTreeClassifier.predict(X_test)
#     evaluate_predictions(predictions, y_test, False, "Decision Tree")
#     #Make a graph of the tree
#     dot_data = tree.export_graphviz(decisionTreeClassifier, out_file=None, 
#                                     feature_names=list(project_data.drop(columns=["team1_win"])),  
#                                     class_names="team1_win")
#     graph = pydotplus.graph_from_dot_data(dot_data)  
#     graph.write_png("C:/Users/Owner/Desktop/Isaac School/CS 450/Project/cs450_project/graphs/decision_tree.png")
# 
# 
# =============================================================================


    #Neural Network Classifer
    neural_network = MLPClassifier(hidden_layer_sizes=(100, ), activation='logistic', solver='adam', alpha=0.0001, batch_size='auto', learning_rate='constant', learning_rate_init=0.001, power_t=0.5, max_iter=400, shuffle=True, random_state=None, tol=0.0001, verbose=False, warm_start=False, momentum=0.9, nesterovs_momentum=True, early_stopping=True, validation_fraction=0.1, beta_1=0.9, beta_2=0.999, epsilon=1e-08, n_iter_no_change=10)
    
    scores = cross_val_score(neural_network, X_data, y_data, cv=10)
    print("Cross Validation Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))
    neural_network.fit(X_train, y_train)
    predictions = neural_network.predict(X_test)
    evaluate_predictions(predictions, y_test, False, "Neural Network")



    #Neural Network Classifer Prediction
    neural_network = MLPClassifier(hidden_layer_sizes=(100, ), activation='logistic', solver='adam', alpha=0.0001, batch_size='auto', learning_rate='constant', learning_rate_init=0.001, power_t=0.5, max_iter=400, shuffle=True, random_state=None, tol=0.0001, verbose=False, warm_start=False, momentum=0.9, nesterovs_momentum=True, early_stopping=True, validation_fraction=0.1, beta_1=0.9, beta_2=0.999, epsilon=1e-08, n_iter_no_change=10)
    
    scores = cross_val_score(neural_network, X_data, y_data, cv=10)
    print("Cross Validation Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))
    neural_network.fit(X_data, y_data)
    predictions = neural_network.predict(X_data_prediction)
    evaluate_predictions(predictions, y_data_prediction, False, "Neural Network Prediction")


# =============================================================================
# 
#     #Bagging Classifer with KNeighbors
#     bagging = BaggingClassifier(MLPClassifier(), max_samples=0.5, max_features=0.5)    
# 
#     scores = cross_val_score(bagging, X_data, y_data, cv=50)
#     print("Cross Validation Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))
#     bagging.fit(X_train, y_train)
#     predictions = bagging.predict(X_test)
#     evaluate_predictions(predictions, y_test, False, "Bagging Classifier")
#     
# =============================================================================
    

# =============================================================================
#     
#     #Ada Boost Classifier
#     ada_boost_classifier = AdaBoostClassifier(n_estimators=100)
# 
#     scores = cross_val_score(ada_boost_classifier, X_data, y_data, cv=10)
#     print("Cross Validation Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))
#     ada_boost_classifier.fit(X_train, y_train)
#     predictions = ada_boost_classifier.predict(X_test)
#     evaluate_predictions(predictions, y_test, False, "Ada Boost Classifier")
# 
# 
# 
#     #Gradient Boosting Classifier
#     gradient_boosting_classifier = GradientBoostingClassifier(loss='deviance', learning_rate=0.1, n_estimators=100, subsample=1.0, criterion='friedman_mse', min_samples_split=2, min_samples_leaf=1, min_weight_fraction_leaf=0.0, max_depth=3, min_impurity_decrease=0.0, min_impurity_split=None, init=None, random_state=None, max_features=None, verbose=0, max_leaf_nodes=None, warm_start=False, presort='auto', validation_fraction=0.1, n_iter_no_change=None, tol=0.0001)
# 
#     scores = cross_val_score(gradient_boosting_classifier, X_data, y_data, cv=10)
#     print("Cross Validation Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))
#     gradient_boosting_classifier.fit(X_train, y_train)
#     predictions = gradient_boosting_classifier.predict(X_test)
#     evaluate_predictions(predictions, y_test, False, "Gradient Boosting Classifier")
# 
# 
# 
#   
#     #Random Forest Classifier
#     random_forest_classifier = RandomForestClassifier(n_estimators=200, n_jobs=-1, oob_score=True, max_depth=5 )
# 
#     scores = cross_val_score(random_forest_classifier, X_data, y_data, cv=10)
#     print("Cross Validation Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))
#     random_forest_classifier.fit(X_train, y_train)
#     predictions = random_forest_classifier.predict(X_test)
#     evaluate_predictions(predictions, y_test, False, "Random Forest Classifier")
# 
#     # Extract single tree and write to png
#     estimator = random_forest_classifier.estimators_[6]
#     dot_data = tree.export_graphviz(estimator, out_file=None, 
#                                     feature_names=list(project_data.drop(columns=["team1_win"])),  
#                                     class_names="team1_win")
#     graph = pydotplus.graph_from_dot_data(dot_data)  
#     graph.write_png("C:/Users/Owner/Desktop/Isaac School/CS 450/Project/cs450_project/graphs/random_forest_decision_tree.png")
# 
#     
#     
#     #Support Vector Machine Classifier
#     support_vector_machine_classifier = svm.SVC(C=1.0, kernel='rbf', degree=3, gamma='scale', coef0=0.0, shrinking=True, probability=False, tol=0.001, cache_size=200, class_weight=None, verbose=False, max_iter=-1, decision_function_shape='ovr', random_state=None)
# 
#     scores = cross_val_score(support_vector_machine_classifier, X_data, y_data, cv=10)
#     print("Cross Validation Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))
#     support_vector_machine_classifier.fit(X_train, y_train)
#     predictions = support_vector_machine_classifier.predict(X_test)
#     evaluate_predictions(predictions, y_test, False, "Support Vector Machine Classifier")
#     
# =============================================================================

if __name__ == "__main__":
    main()
    
    

