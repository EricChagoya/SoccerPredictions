# SoccerPredictions

### Final Report (FinalReport_githubver.pdf)
- 10 pages addressing our works of the project including
    - Problem Statement
    - Related Works
    - Explanation of Datasets used and includes sample datasets
    - Software used
    - Experiments and Evaluation
    - Notebook Evaluation
    - Members Participation
    - Discussion and Conclusion
    - Multiple graphs demonstrating performance of the models

### Directories
- BradleyTerrySportsModel
    - Contains a prototype Bradley Terry Model
- Data
    - It has all the data we have collected, combined and processed
- Graphs
    - Contains scripts on how to create the referee graph
- Recency_feature
    - Contains the work for extracting recency features and contains various csv files that have recency features aggregated with the original data

### Scripts
- DataUK_Combine_Data.ipynb
    - It removes features that have mostly missing data. Removes features that are useless. It also combines all seasons into one dataset
- EPL_Reddit.ipynb
    - It collects data from the reddit API. It tries to find information about what people think about each team. Do the people think that team is good or bad?
- Premier_league_scraper.py
    - The webscrapper that goes to the Premier League website and finds statistics about each individual game from the past 10 years
- createTables.sql
    - It combines the dataset from DataUK, Reddit, and the Webscraper. Some data cleaning and changing features so they can join
- Modeling.ipynb
    - It has all the work for getting the lowest mean RPS(Ranked Probability Score) by logistic regression and k-nearest neighbor
- correlation_plot.ipynb
    - This notebook creates the correlation plot heatmap for the data


