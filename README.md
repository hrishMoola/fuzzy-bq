# Final Project

Turn in final project deliverables here.

## Dataset

(We already did a lab on this, but you may have changed your mind since then,
so please fill this out):

* Dataset description: A list of company names from [Kaggle](https://www.kaggle.com/dattapiy/sec-edgar-companies-list) 
* Format: CSV
* How you will obtain the data: Download to GCS, export to BQ. 
* What features are available: Just company names pre-cleaned.

This project will be in two parts i.e. 
Part 1 is with BigQuery on Google Cloud Project.
Part 2 is with SparkML.

## Project Plan

At a high level, I intend implement fuzzy string matching on large input dataset - and do it using distributed systems.
Although the use-case may seem niche, I am using this as an opportunity to demystify somethings about NLP techniques and work with ML in distributed systems.

In some cases, even the best laid plans will go awry. However, you will be evaluated on:

1. Whether you did what you said you'd do
2. The work you put in
3. Presentation of the work

Please provide a brief, one or two paragraph description of your project and what you hope to
analyze:

Fuzzy matching involves looking for almost-matches in a dataset. This is a surpsingly ubiquitous problem, and there is a lot of research on different techniques to solve this. My project aims to try out one specific solution, involving calculating a Term Frequency and Inverse Document Frequency (TF-IDF) score for each term and finding their almost-matches using this.

Provide a list of the deliverables you will turn in:

Part 1: BQ
  1. There is detailed README outlined in the directory called BQ_fuzzy here. This directory also has the code deliverables. Furthermore, I've granted access to the Professor on my personal Google Cloud Project, so that these queries could be tried out and the results evaluated. 
 
Part 2: SparkML
  1. Update at the time of this commit i.e. project deadline on 14th December - I haven't been able to get a solid solution here. I look to rolling out a solution over the next couple of days, and accept any point-deductions on the grade here.

This project invovled a lot of reading up about how TF-IDF and cosine similarity works. As such, it's more research and PoC based than data analysis and insights. 
