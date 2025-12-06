# BHDS-2010-Assignment-4
Assignment 4: Shiny App
Ibrahim indicates that the original name of the dataset is “SAheart”. Bryanna 
defined the data, stating, This dataset originates from a retrospective study
of adult males living in a heart disease high-risk region of the Western Cape, 
South Africa. The sample includes individuals with diagnosed coronary heart 
disease (CHD) and a larger group of demographic factors. These data form part 
of a broader study described in Roussaeuw et al. (1983) in the South African 
Medical Journal. Several physiological measurements were recorded after 
treatment. This is an important consideration when interpreting predictors such 
as systolic blood pressure in relation to CHD status.
Ibrahim - The original data is named SAheat. It contains 10 variables: sbp:
systolic blood pressure; tobacco: cumulative tobacco use (kg); ldl: low-density 
lipoprotein cholesterol; adiposity: measure of body fat; famhist: family history 
of heart disease (Present/Absent); typea: type-A behavior; obesity: obesity 
score or index; alcohol: current alcohol consumption (Liter Per Year); age: age
at onset; chd: coronary heart disease (No CHD/CHD). We used all variables 
excluding typea. All variables are numeric, except for famhist and chd, which 
are categorical. Variables’ definitions are given on the data source website.

## Summary for histogram:

Ibrahim created a histogram. In this part of the app, Ibrahim wanted to explore 
risk factors for coronary heart disease. Ibrahim created a drop list to select 
a variable from the dataset and a slider to adjust the range of the selected 
variable. Ibrahim used the drop list and the slider to see how different risk 
factors (variables and ranges) affect CHD prevalence. Ibrahim summarized his 
observations as follows: 
Ibrahim - Note: all first selected ranges start with the minimum value of the 
variable, and all second selected ranges end with the maximum value of the 
variable.
Ibrahim - Age ranges: The 101 younger cases (15-29 yo) contain 7 CHD cases and 
94 non-CHD cases, which corresponds to a 6.9% CHD prevalence. In contrast, the 
97 older cases (58-64 yo) contain 56 CHD cases and 41 non-CHD cases, 
corresponding to a 57.7% CHD prevalence. 
Ibrahim - Current Alcohol Consumption ranges: Range (0-15) with 302 total 
observations, containing 99 CHD cases and 203 non-CHD cases, which is 32.8%  CHD 
prevalence, while range (95-148) with 8 total observations, containing 4 CHD 
cases and 4 non-CHD cases, which is 50%  CHD prevalence. The alcohol variable 
has outliers in high values.
Ibrahim - Obesity ranges: Range (14-23) with 116 total observations, containing 
30 CHD cases and 86 non-CHD cases, which is 25.9%  CHD prevalence, while range 
(34-47) with 19 total observations, containing 8 CHD cases and 11 non-CHD cases,
which is 42.1% CHD prevalence. The obesity variable has outliers on both sides.
Ibrahim - Family history of heart disease: It is absent in 270 total 
observations, containing 64 CHD cases and 206 non-CHD cases, which is 23.7%  CHD 
prevalence, while it is present in 192 total observations, containing 96 CHD 
cases and 96 non-CHD cases, which is 50% CHD prevalence. The presence of heart 
disease in the family history shows a slightly higher risk of CHD.
Ibrahim - Adiposity ranges: Range (6-18) with 93 total observations, containing 
15 CHD cases and 78 non-CHD cases, which is 16.1%  CHD prevalence, while range 
(34-43) with 70 total observations, containing 39 CHD cases and 31 non-CHD 
cases, which is 55.7% CHD prevalence, and a high range of it shows higher risk 
of CHD. 
Ibrahim - Low-density lipoprotein cholesterol ranges: Range (0-6) with 198 total 
observations, containing 43 CHD cases and 155 non-CHD cases, which is 21.7% CHD 
prevalence, while range (8-16) with 34 total observations, containing 21 CHD 
cases and 13 non-CHD cases, which is 61.8% CHD prevalence. The low-density 
lipoprotein cholesterol variable has outliers in higher values, and a high range
of it shows a high risk of CHD.
Ibrahim - Tobacco ranges: Range (0-4) with 298 total observations, containing 
79 CHD cases and 219 non-CHD cases, which is 26.5% CHD prevalence, while range 
(16-32) with 11 total observations, containing 7 CHD cases and 4 non-CHD cases,
which is 63.6% CHD prevalence. The tobacco variable has outliers in higher 
values, and a high range of it shows a high risk of CHD.
Ibrahim - Systolic blood pressure ranges: Range (101-127) with 143 total
observations, containing 40 CHD cases and 103 non-CHD cases, which is 28% CHD 
prevalence, while range (185-218) with 15 total observations, containing 9 CHD 
cases and 6 non-CHD cases, which is 60% CHD prevalence. The systolic blood 
pressure variable has outliers in higher values, and a high range of it shows a 
high risk of CHD.

Ibrahim - In conclusion, in addition to academic learning, this project allows 
us to work in groups. And it gives us the opportunity to explore some of the 
challenges that the team could face. And it allows us to explore how to overcome 
the obstacles that we face in working as a team. This project answers the 
question of “Which risk factors are most strongly associated with CHD diagnosis 
in high-risk South African men?" The histogram and the slide bar show that most 
strongly associated with CHD diagnosis in high-risk individuals are aging, the 
presence of heart disease in the family history, high adiposity rate, 
low-density lipoprotein cholesterol, high use of tobacco, and high systolic 
blood pressure. The app contains three tabs: a histogram with manageable data 
uses, a box plot, and a data table with a manageable summary table.
