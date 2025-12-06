# BHDS-2010-Assignment-4
Assignment 4: Shiny App

# Authors 
Bryanna Schaffer and Ibrahim Elbasheer

# Assignment Description

This assignment provides another opportunity to practice collaborating via Github. For this assignment, we will create an interactive Shiny app to investigate potential factors that are associated with coronary heart disease, or CHD. 
# Dataset
The original name of the dataset is SAheart. This dataset originates from a retrospective study of adult males living in a heart-disease high-risk region of the Western Cape, South Africa. The sample includes individuals with diagnosed coronary heart disease (CHD) and a larger group of individuals without CHD, along with various demographic and physiological factors. These data form part of a broader study described in Roussaeuw et al. (1983) in the South African Medical Journal. Several physiological measurements were recorded after treatment, which is important to consider when interpreting predictors such as systolic blood pressure in relation to CHD status.

The dataset contains 10 variables:

sbp: systolic blood pressure

tobacco: cumulative tobacco use (kg)

ldl: low-density lipoprotein cholesterol

adiposity: measure of body fat

famhist: family history of heart disease (Present/Absent)

typea: type-A behavior

obesity: obesity score or index

alcohol: current alcohol consumption (liters per year)

age: age at onset

chd: coronary heart disease (No CHD/CHD)

All variables were used except typea. All variables are numeric except famhist and chd, which are categorical. Variable definitions are provided on the data source website.
# Roles and Responsibilities
To complete this assignment, we though it would be best if we split our variables of interest between the two of us. Bryanna is responsible for sbp, tobacco, ldl, and famhist. Ibrahim is responsible for typea, obesity, alcohol, and age. We both will perform data analysis and write a results section for each variable (total of 4 each)!

Ibrahim: Visualization 1 (Histogram) with Summary Statistics/Analysis + README 
documentation

Bryanna: Summary Statistics + Visualization 2 (Boxplots/Bar plots) with Analysis + 
README documentation

# Dataset

The original name of the dataset is SAheart. This dataset originates from a retrospective study of adult males living in a heart-disease high-risk region of the Western Cape, South Africa. The sample includes individuals with diagnosed coronary heart disease (CHD) and a larger group of individuals without CHD, along with various demographic and physiological factors. These data form part of a broader study described in Roussaeuw et al. (1983) in the South African Medical Journal. Several physiological measurements were recorded after treatment, which is important to consider when interpreting predictors such as systolic blood pressure in relation to CHD status. The dataset is highly relevant to the course as it allows students to apply statistical concepts such as data visualization and exploratory data analysis.

The dataset contains 10 variables:

1. sbp: systolic blood pressure

2. tobacco: cumulative tobacco use (kg)

3. ldl: low-density lipoprotein cholesterol

4. adiposity: measure of body fat

5. famhist: family history of heart disease (Present/Absent)

6. typea: type-A behavior

7. obesity: obesity score or index

8. alcohol: current alcohol consumption (liters per year)

9. age: age at onset

10. chd: coronary heart disease (No CHD/CHD)

All variables were used except typea. All variables are numeric except famhist and chd, which are categorical. Variable definitions are provided on the data source website.

# Key Features of the App

This app includes several user-controlled inputs via a dropdown menu, slider input, and a tab selector. The dropdown menu allows users to select a variable of interest and compare it to CHD. The slider input allows users to focus on a specific value within the variable selected from the dropdown menu. Specifically, if the user was to select the age variable, the slider variable would allow the user to focus on a specific age range (i.e. 18-25). 

Each tab produces different visual and numerical outputs, such as summary tables, histograms, and boxplots/bar plots. The summary table outputs the mean, median, standard deviation, and proportions depending on the variable selected. The histogram and boxplots/bar plots show the relationship between CHD status and a user-chosen risk factor. Below each plot there is a summary explaining the patterns observed in each visualization. 

The server logic controls how the app processes user inputs and generates outputs. The key components in our server logic include: text outputs, summary statistics, filtering the dataset, generating plots, displaying the full dataset, and statistical analysis. This portion of our app ties the dataset and user inputs to create an interactive environment for the audience. 

# Summary of Results

The histogram component of the app was designed to explore how different ranges of each risk factor relate to CHD prevalence. A dropdown menu allows the user to select any variable of interest, and a slider adjusts the numerical range for that variable. This setup makes it possible to observe how CHD prevalence changes across low, medium, and high values of each risk factor.

1. Systolic Blood Pressure (sbp):
For the lower range (101–127), there are 143 observations with 40 CHD and 103 non-CHD cases (28% prevalence). In the higher range (185–218), 15 observations include 9 CHD and 6 non-CHD cases (60% prevalence). The plot indicates that individuals with CHD tend to have higher systolic blood pressure on average, with an approximate difference of 8 mmHg. Blood pressure also shows greater variation in the CHD group, and outliers appear in both groups. These patterns suggest a potential association between systolic blood pressure and CHD, though individual variability is present and formal statistical testing is required.

2. Tobacco Use (tobacco):
The lower tobacco-use range (0–4) contains 298 observations with 79 CHD and 219 non-CHD cases (26.5%). The higher range (16–32) contains 11 observations with 7 CHD and 4 non-CHD cases (63.6%). The boxplot shows that individuals with CHD generally have higher cumulative tobacco use, with an approximate mean difference of 3 kg. Variability is greater in the CHD group, and outliers are present in both. These findings suggest an association between cumulative tobacco use and CHD, pending statistical confirmation.

3. Low-Density Lipoprotein Cholesterol (ldl):
In the lower LDL range (0–6), 198 observations include 43 CHD and 155 non-CHD cases (21.7%). The higher LDL range (8–16) includes 34 observations with 21 CHD and 13 non-CHD cases (61.8%). The plot shows that average LDL is slightly higher among CHD cases, with a mean difference of about 1 mg/dL. Variation is similar between groups but slightly higher in the CHD group. A statistical test is needed to determine whether LDL is significantly associated with CHD.

4. Adiposity (adiposity):
The lower adiposity range (6–18) includes 93 observations with 15 CHD and 78 non-CHD cases (16.1%). The higher range (34–43) includes 70 observations with 39 CHD and 31 non-CHD cases (55.7%). The boxplot shows a slightly greater median in the CHD group, with mean values of approximately 28.12 for CHD and 23.97 for non-CHD (a 5-unit difference). Variability is very similar in both groups. A statistical test will be needed to confirm whether adiposity is associated with CHD.

5. Family History of Heart Disease (famhist):
Individuals without a family history show 270 observations containing 64 CHD and 206 non-CHD cases (23.7%), whereas those with a family history show 192 observations with 96 CHD and 96 non-CHD cases (50%). The bar plot indicates that CHD prevalence increases by roughly 25% among individuals with a family history, while non-CHD prevalence decreases by a similar amount. This suggests a strong association between family history and CHD, which should be examined with statistical testing.

6. Type-A Behavior (typea):
This variable was not included in the histogram analysis and therefore does not appear in the exploration tool.

7. Obesity (obesity):
The lower obesity range (14–23) includes 116 observations with 30 CHD and 86 non-CHD cases (25.9%). The higher range (34–47) includes 19 observations with 8 CHD and 11 non-CHD cases (42.1%). The plot shows that median obesity values are similar between groups. Mean obesity levels are approximately 26.62 for CHD and 25.74 for non-CHD. Based on the plot alone, obesity does not appear strongly associated with CHD, but statistical testing is needed.

8. Alcohol Consumption (alcohol):
The lower range (0–15) includes 302 observations with 99 CHD and 203 non-CHD cases (32.8%). The higher range (95–148) includes only 8 observations with 4 CHD and 4 non-CHD cases (50%). The boxplot shows similar medians and equal variation between groups. Mean alcohol consumption is approximately 19.15 for CHD and 15.93 for non-CHD. Due to similarities between groups and the presence of extreme outliers, statistical testing is recommended to assess any association.

9. Age (age):
The younger group (15–29) includes 101 observations with 7 CHD and 94 non-CHD cases (6.9%). The older group (58–64) includes 97 observations with 56 CHD and 41 non-CHD cases (57.7%). The plot shows a clear separation between groups: the median age of CHD cases does not overlap with the IQR of non-CHD cases. Mean age is approximately 50 for CHD and 39 for non-CHD. These findings indicate a strong association between age and CHD, though variability remains and statistical testing is needed for confirmation.

10. Coronary Heart Disease (chd):
This is the outcome variable and is not evaluated as a predictor within the histogram or boxplot components.

# Conclusion

This project not only reinforced key analytical and statistical concepts but also provided valuable experience in collaborative work. Through group coordination, we learned to navigate challenges, communicate effectively, and combine our strengths to produce this Shiny app.

Our investigation addressed the question: Which risk factors are most strongly associated with CHD diagnosis in high-risk South African men? The visualizations, particularly the histogram and boxplots, indicate that several factors may show strong associations with CHD status. These include age, family history of heart disease, adiposity, low-density lipoprotein cholesterol, tobacco use, and systolic blood pressure. It is important to note that further statistical testing, like t-test, should be performed to conclude whether such associations truly exist. 

The final Shiny application presents our findings through three interactive components: a raw data table with summary statistics, histograms, and boxplots. Together, these tools allow users to explore and gain insights into the potential key predictors of coronary heart disease.

# Change History

11/10/2025 - Initial repository setup by Bryanna Schaffer

11/10/2025 - IbrahimElbasheer invited to repository

11/10/2025 - Dataset picked out and agreed uponed by Bryanna and Ibrahim

11/12/2025 - Bryanna edited and saved the data as a csv file and uploaded to the 
main branch.

11/12/2025 - Roles (Variables) assigned for analysis. Bryanna cleaned the dataset.

11/14/2025 - Ibrahim accepted the invitation

11/14/2025 - Ibrahim created a branch and downloaded the data and stored it in an 
Excel sheet.

11/18/2025 - Bryanna created Shiny App and uploaded necessary information for Tab (Bryanna Branch)

11/21/2025 - Bryanna finished Tab 2, which included raw data set and summary 
statistics for variables of interest. (Bryanna Branch)

11/26/2025 - Bryanna uploaded plots to Tab 3 and is working on findings for each 
plot. (Bryanna Branch)

12/1/2025 - Ibrahim created the code for the filtered data and the histogram.

12/1/2025 - Ibrahim commented to the code explaining the purpose of each part of 
the code.

12/1/2025 - Bryanna finished findings for each plot. (Bryanna Branch)

12/2/2025 - Bryanna and Ibrahim discuss how to proceed with merging apps. It is 
decided to add the histograms to the app in the Bryanna branch.

12/3/2025 - Bryanna merges the apps.

12/4/2025 - Ibrahim puts his write up in his branch as a word document. He also 
added summary code to his app.

12/4/2025 - Bryanna takes Ibrahim's write up and adds it to the README file. She 
also adds Ibrahim's summary code to the main app.

12/5/2025 - Bryanna adds her write up to the README file. 

12/5/2025 - Bryanna sends published app and README file to Ibrahim for approval 
to submit.

12/5/2025 - Ibrahim approves the README file and app for submission.

12/6/2025 - Bryanna puts all code into main branch.


