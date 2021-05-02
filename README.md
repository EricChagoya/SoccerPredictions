# SoccerPredictions

### Directories
- BradleyTerrySportsModel
    - Contains a prototype Bradley Terry Model
- Data
    - It has all the data we have collected, combined and processed
- Graphs
    - Contains scripts on how to create the referee graph

### Scripts
- DataUK_Combine_Data.ipynb
    - It removes features that have mostly missing data. Removes features that are useless. It also combines all seasons into one dataset
- EPL_Reddit.ipynb
    - It collects data from the reddit API. It tries to find information about what people think about each team. Do the people think that team is good or bad?
- Premier_league_scraper.py
    - The webscrapper that goes to the Premier League website and finds statistics about each individual game from the past 10 years
- createTables.sql
    It combines the dataset from DataUK, Reddit, and the Webscraper. Some data cleaning and changing features so they can join


