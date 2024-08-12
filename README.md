# MARKET BASKET ANALYSIS PROJECT

This repository contains a market basket analysis project as a part of my data analyst portfolio. The main objective of this project is to discover rules that describe the relationships between different item with association rules mining. The output of this analysis helps business understands which products customer frequently purchased together and use this information for various purposes such as cross-selling, special deals, and product placement. 

## DATASET

Dataset that were used for this project is publicaly available on kaggle. This dataset contains record of transactions that belong to a retailer that sells various grocery items.

**Source** : Kaggle (https://www.kaggle.com/datasets/aslanahmedov/market-basket-analysis)

## ASSOCIATION RULE MINING

Association rule mining is a technique used to identify patterns and relationships in a large dataset that may not immediately apparent. Three metrics that were used to evaluate quality and importance of the discovered rules are support, confidence, and lift.

For example, let's analyze these 2 items that were purchased at some grocery store. Item A act as antecedent while item B act as consequent. Out of 1000 transactions, 120 of them has item A, 80 of them has item B, and 20 of them has item A and B together.
![association rule mining](https://github.com/user-attachments/assets/367c726a-7771-4235-8238-6922e3fdc068)

### Problem Statement:
If item A got purchased, what chances of item B also got purchased together ?

### Hypothesis:
There is significant evidence to show the probability of item B got purchased after item A got purchased.

### Analysis:

* **Support**

Support is a measure of how frequently an item appears in all transactions that were made.

##### *Support (A,B)* = *Freq (A,B)* / N

##### *Support (A,B)* = 20 / 1000

##### *Support (A,B)* = 2%

The support value of 2% indicates 2% of all transactions have combination of item A and item B bought together.

* **Confidence**

Confidence is a measure of the strength of the association between two items.

##### *Confidence (A,B)* = *Freq (A,B)* / *Freq (A)*

##### *Confidence (A,B)* = 20 / 100

##### *Confidence (A,B)* = 20%

The confidence value of 20% indicates the confidence level of item B will be bought after item A is bought is 20%

* **Lift**

Lift is a measure of the strentgh of the association, taking into account the frequency of both items in the dataset.

##### *Lift (A,B)* = *Support (A,B)* / (*Support A* x *support B*)

##### *Lift (A,B)* = (20/1000) / ((100/1000) x (80/1000))

##### *Lift (A,B)* = 0.02 / (0.1 x 0.08)

##### *Lift (A,B)* = 2.5

The lift value of 2.5 indicates that item A being purchased influence item B to also be purchased by 2.5 times

### Conclusion:

Based on the calculation above, we can justify the hypothesis as we found out that:

- The support of 2% transactions for item A and item B in the same basket
- 25% confidence that item A and item B is in the same basket
- item A sales influences item B sales by 2.5 times more
