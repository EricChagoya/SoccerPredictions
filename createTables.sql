--\i 'C:/Users/Eric/Desktop/SoccerPredictions/createTables.sql'


DROP TABLE IF EXISTS Reddit;
DROP TABLE IF EXISTS DataUK;
DROP TABLE IF EXISTS Web_Scrapped;
DROP TABLE IF EXISTS Games;
DROP TABLE IF EXISTS Games2;
DROP TABLE IF EXISTS Combined_Data;




-- Part 1 Create Tables and load Data
CREATE TABLE Reddit(
	season varchar(9),
    team varchar(20),
    total_post integer,
    total_comments integer,
    score integer,
    positive integer,
    negative integer
);


CREATE TABLE DataUK(
    game_date varchar(12),
    home_team varchar(30),
    away_team varchar(30),
    home_goals decimal,
    away_goals decimal,
    winner varchar(1),              -- Not in Webscrapped
    halftime_home_goals decimal,    -- Not in Webscrapped
    halftime_away_goals decimal,    -- Not in Webscrapped
    halftime_winner varchar(1),     -- Not in Webscrapped
    referee varchar(30),            -- Not in Webscrapped
    home_shots decimal,
    away_shots decimal,
    home_shots_target decimal,
    away_shots_target decimal,
    home_fouls decimal,
    away_fouls decimal,
    home_corners decimal,
    away_corners decimal,
    home_yellow decimal,
    away_yellow decimal,
    home_red decimal,
    away_red decimal
);


CREATE TABLE Web_Scrapped (
    game_date date,
    home_team varchar(30),
    away_team varchar(30),
    home_score integer,
    away_score integer,
    home_position integer,
    away_position integer,
    home_won integer,
    away_won integer,
    home_drawn integer,
    away_drawn integer,
    home_lost integer,
    away_lost integer,
    home_avg_goals_scored_per_match decimal,
    away_avg_goals_scored_per_match decimal,
    home_avg_goals_conceded_per_match  decimal,
    away_avg_goals_conceded_per_match decimal,
    home_clean_sheets integer,
    away_clean_sheets integer,
    home_biggest_win varchar(100),
    away_biggest_win varchar(100),
    home_worst_defeat varchar(100),
    away_worst_defeat varchar(100),
    home_possession_percent decimal,
    away_possession_percent decimal,
    home_shots_on_target decimal,
    away_shots_on_target decimal,
    home_shots decimal,
    away_shots decimal,
    home_touches decimal,
    away_touches decimal,
    home_passes decimal,
    away_passes decimal,
    home_tackles decimal,
    away_tackles decimal,
    home_clearances decimal,
    away_clearances decimal,
    home_corners decimal,
    away_corners decimal,
    home_offsides decimal,
    away_offsides decimal,
    home_yellow_cards decimal,
    away_yellow_cards decimal,
    home_red_cards decimal,
    away_red_cards decimal,
    home_fouls_conceded decimal,
    away_fouls_conceded decimal
);



-- Data Sources
-- Sample Datasets
--\copy Reddit FROM 'C:/Users/Eric/Desktop/SoccerPredictions/Data/Sample Data/EPL_Reddit_Data_Sample.csv' with delimiter ',' csv header
--\copy DataUK FROM 'C:/Users/Eric/Desktop/SoccerPredictions/Data/Sample Data/DataUK_Data_Sample.csv' with delimiter ',' csv header
--\copy Web_Scrapped FROM 'C:/Users/Eric/Desktop/SoccerPredictions/Data/Sample Data/Premier_league_10_20_Sample.csv' with delimiter ',' csv header

-- Full Datasets
\copy Reddit FROM 'C:/Users/Eric/Desktop/SoccerPredictions/Data/EPL_Reddit_Data.csv' with delimiter ',' csv header
\copy DataUK FROM 'C:/Users/Eric/Desktop/SoccerPredictions/Data/DataUK_Data.csv' with delimiter ',' csv header
\copy Web_Scrapped FROM 'C:/Users/Eric/Desktop/SoccerPredictions/Data/Premier_league_10_20.csv' with delimiter ',' csv header


-- These change from decimal to integer
ALTER TABLE DataUK
    ALTER COLUMN home_goals TYPE integer,
    ALTER COLUMN away_goals TYPE integer,
    ALTER COLUMN halftime_home_goals TYPE integer,
    ALTER COLUMN halftime_away_goals TYPE integer,
    ALTER COLUMN home_shots TYPE integer,
    ALTER COLUMN away_shots TYPE integer,
    ALTER COLUMN home_shots_target TYPE integer,
    ALTER COLUMN away_shots_target TYPE integer,
    ALTER COLUMN home_fouls TYPE integer,
    ALTER COLUMN away_fouls TYPE integer,
    ALTER COLUMN home_corners TYPE integer,
    ALTER COLUMN away_corners TYPE integer,
    ALTER COLUMN home_yellow TYPE integer,
    ALTER COLUMN away_yellow TYPE integer,
    ALTER COLUMN home_red TYPE integer,
    ALTER COLUMN away_red TYPE integer;


ALTER TABLE Web_Scrapped
    ALTER COLUMN home_shots_on_target TYPE integer,
    ALTER COLUMN away_shots_on_target TYPE integer,
    ALTER COLUMN home_shots TYPE integer,
    ALTER COLUMN away_shots TYPE integer,
    ALTER COLUMN home_touches TYPE integer,
    ALTER COLUMN away_touches TYPE integer,
    ALTER COLUMN home_passes TYPE integer,
    ALTER COLUMN away_passes TYPE integer,
    ALTER COLUMN home_tackles TYPE integer,
    ALTER COLUMN away_tackles TYPE integer,
    ALTER COLUMN home_clearances TYPE integer,
    ALTER COLUMN away_clearances TYPE integer,
    ALTER COLUMN home_corners TYPE integer,
    ALTER COLUMN away_corners TYPE integer,
    ALTER COLUMN home_offsides TYPE integer,
    ALTER COLUMN away_offsides TYPE integer,
    ALTER COLUMN home_yellow_cards TYPE integer,
    ALTER COLUMN away_yellow_cards TYPE integer,
    ALTER COLUMN home_red_cards TYPE integer,
    ALTER COLUMN away_red_cards TYPE integer,
    ALTER COLUMN home_fouls_conceded TYPE integer,
    ALTER COLUMN away_fouls_conceded TYPE integer;




-- Fix DataUK date
ALTER TABLE DataUK
    ADD COLUMN date_fixed DATE; 

UPDATE DataUK
    SET date_fixed = CAST((SPLIT_PART(game_date, '/', 2) || '/' || SPLIT_PART(game_date, '/', 1) || '/20' || RIGHT(game_date, 2)) as DATE);





-- Part 2- Combine DataUK and Webscrapper. 
--         Fix inconsisties from both tables
-- Remove games from before 2010
DELETE FROM DataUK
    WHERE DATE_PART('year', CAST(date_fixed AS DATE)) < 2010;

-- Remove games from the 2009- 2010 season
DELETE FROM DataUK
    WHERE DATE_PART('year', CAST(date_fixed AS DATE)) = 2010 and
            DATE_PART('month', CAST(date_fixed AS DATE)) < 7;



UPDATE DataUK SET home_team = CASE
    WHEN home_team = 'Birmingham' THEN 'Birmingham City'
    WHEN home_team = 'Blackburn' THEN 'Blackburn Rovers'
    WHEN home_team = 'Bolton' THEN 'Bolton Wanderers'
    WHEN home_team = 'Bournemouth' THEN 'AFC Bournemouth'
    WHEN home_team = 'Brighton' THEN 'Brighton and Hove Albion'
    WHEN home_team = 'Cardiff' THEN 'Cardiff City'
    WHEN home_team = 'Huddersfield' THEN 'Huddersfield Town'
    WHEN home_team = 'Hull' THEN 'Hull City'
    WHEN home_team = 'Leicester' THEN 'Leicester City'
    WHEN home_team = 'Man City' THEN 'Manchester City'
    WHEN home_team = 'Man United' THEN 'Manchester United'
    WHEN home_team = 'Newcastle' THEN 'Newcastle United'
    WHEN home_team = 'Norwich' THEN 'Norwich City'
    WHEN home_team = 'QPR' THEN 'Queens Park Rangers'
    WHEN home_team = 'Stoke' THEN 'Stoke City'
    WHEN home_team = 'Swansea' THEN 'Swansea City'
    WHEN home_team = 'Tottenham' THEN 'Tottenham Hotspur'
    WHEN home_team = 'West Brom' THEN 'West Bromwich Albion'
    WHEN home_team = 'West Ham' THEN 'West Ham United'
    WHEN home_team = 'Wigan' THEN 'Wigan Athletic'
    WHEN home_team = 'Wolves' THEN 'Wolverhampton Wanderers'
END
WHERE home_team IN ('Birmingham', 'Blackburn','Bolton', 'Bournemouth', 'Brighton', 'Cardiff', 
                    'Huddersfield', 'Hull', 'Leicester', 'Man City', 'Man United', 'Newcastle', 
                    'Norwich', 'QPR', 'Stoke', 'Swansea', 'Tottenham', 'West Brom', 'West Ham',
                    'Wigan', 'Wolves');

UPDATE DataUK SET away_team = CASE
    WHEN away_team = 'Birmingham' THEN 'Birmingham City'
    WHEN away_team = 'Blackburn' THEN 'Blackburn Rovers'
    WHEN away_team = 'Bolton' THEN 'Bolton Wanderers'
    WHEN away_team = 'Bournemouth' THEN 'AFC Bournemouth'
    WHEN away_team = 'Brighton' THEN 'Brighton and Hove Albion'
    WHEN away_team = 'Cardiff' THEN 'Cardiff City'
    WHEN away_team = 'Huddersfield' THEN 'Huddersfield Town'
    WHEN away_team = 'Hull' THEN 'Hull City'
    WHEN away_team = 'Leicester' THEN 'Leicester City'
    WHEN away_team = 'Man City' THEN 'Manchester City'
    WHEN away_team = 'Man United' THEN 'Manchester United'
    WHEN away_team = 'Newcastle' THEN 'Newcastle United'
    WHEN away_team = 'Norwich' THEN 'Norwich City'
    WHEN away_team = 'QPR' THEN 'Queens Park Rangers'
    WHEN away_team = 'Stoke' THEN 'Stoke City'
    WHEN away_team = 'Swansea' THEN 'Swansea City'
    WHEN away_team = 'Tottenham' THEN 'Tottenham Hotspur'
    WHEN away_team = 'West Brom' THEN 'West Bromwich Albion'
    WHEN away_team = 'West Ham' THEN 'West Ham United'
    WHEN away_team = 'Wigan' THEN 'Wigan Athletic'
    WHEN away_team = 'Wolves' THEN 'Wolverhampton Wanderers'
END
WHERE away_team IN ('Birmingham', 'Blackburn','Bolton', 'Bournemouth', 'Brighton', 'Cardiff', 
                    'Huddersfield', 'Hull', 'Leicester', 'Man City', 'Man United', 'Newcastle', 
                    'Norwich', 'QPR', 'Stoke', 'Swansea', 'Tottenham', 'West Brom', 'West Ham',
                    'Wigan', 'Wolves');

-- Left ones only appear in DataUK
-- Right ones only appear in Webscrapper
/*
SELECT DISTINCT DataUK.home_team, Web_Scrapped.home_team
FROM Web_Scrapped
FULL OUTER JOIN DataUK ON Web_Scrapped.home_team = DataUK.home_team
ORDER BY DataUK.home_team;
*/


-- Combined table of Webscrapped and DataUK
CREATE TABLE Games AS
SELECT Web_Scrapped.game_date, Web_Scrapped.home_team, Web_Scrapped.away_team, Web_Scrapped.home_score, Web_Scrapped.away_score, 
        DataUK.winner, DataUK.halftime_home_goals, DataUK.halftime_away_goals, DataUK.halftime_winner, DataUK.referee,
        Web_Scrapped.home_position, Web_Scrapped.away_position, Web_Scrapped.home_won, Web_Scrapped.away_won,
        Web_Scrapped.home_drawn, Web_Scrapped.away_drawn, Web_Scrapped.home_lost, Web_Scrapped.away_lost,
        Web_Scrapped.home_avg_goals_scored_per_match, Web_Scrapped.away_avg_goals_scored_per_match, 
        Web_Scrapped.home_avg_goals_conceded_per_match, Web_Scrapped.away_avg_goals_conceded_per_match,
        Web_Scrapped.home_clean_sheets, Web_Scrapped.away_clean_sheets, Web_Scrapped.home_biggest_win, 
        Web_Scrapped.away_biggest_win, Web_Scrapped.home_worst_defeat, Web_Scrapped.away_worst_defeat,
        Web_Scrapped.home_possession_percent, Web_Scrapped.away_possession_percent, Web_Scrapped.home_shots_on_target,
        Web_Scrapped.away_shots_on_target, Web_Scrapped.home_shots, Web_Scrapped.away_shots,
        Web_Scrapped.home_touches, Web_Scrapped.away_touches, Web_Scrapped.home_passes, Web_Scrapped.away_passes,home_tackles,
        Web_Scrapped.away_tackles, Web_Scrapped.home_clearances, Web_Scrapped.away_clearances, Web_Scrapped.home_corners,
        Web_Scrapped.away_corners, Web_Scrapped.home_offsides, Web_Scrapped.away_offsides, Web_Scrapped.home_yellow_cards,
        Web_Scrapped.away_yellow_cards, Web_Scrapped.home_red_cards, Web_Scrapped.away_red_cards,
        Web_Scrapped.home_fouls_conceded, Web_Scrapped.away_fouls_conceded
FROM DataUK
INNER JOIN Web_Scrapped
    ON Web_Scrapped.game_date = DataUK.date_fixed AND 
        Web_Scrapped.home_team = DataUK.home_team AND 
        Web_Scrapped.away_team = DataUK.away_team
ORDER BY Web_Scrapped.game_date;






-- Part 3- Combines Games and Reddit Data
-- Remove games from before 2013
DELETE FROM Games
    WHERE DATE_PART('year', CAST(game_date AS DATE)) < 2013;

-- Remove games from the 2012- 2013 season
DELETE FROM Games
    WHERE DATE_PART('year', CAST(game_date AS DATE)) = 2013 and
            DATE_PART('month', CAST(game_date AS DATE)) < 7;




-- Change team names of Reddit Data to match Games
UPDATE Reddit SET Team = CASE
    WHEN Team = 'Newcastle' THEN 'Newcastle United'
    WHEN Team = 'QPR' THEN 'Queens Park Rangers'
    WHEN Team = 'Swansea' THEN 'Swansea City'
    WHEN Team = 'Tottenham' THEN 'Tottenham Hotspur'
    WHEN Team = 'WBA' THEN 'West Bromwich Albion'
    WHEN Team = 'West Ham' THEN 'West Ham United'
END
WHERE Team IN ('Newcastle', 'QPR', 'Swansea', 'Tottenham', 'WBA', 'West Ham');

-- Left ones only appear in Reddit
-- Right ones only appear in Games
/*
SELECT DISTINCT Reddit.Team, Games.home_team
FROM Games
FULL OUTER JOIN Reddit ON Games.home_team = Reddit.Team
ORDER BY Reddit.Team;
*/




-- Add a column for the start of the season
ALTER TABLE Games
    ADD COLUMN start_season integer; 

UPDATE Games
    SET start_season = DATE_PART('year', game_date);

UPDATE Games
    SET start_season = start_season - 1 WHERE DATE_PART('month', game_date) < 7;


ALTER TABLE Reddit
    ADD COLUMN start_season integer; 

UPDATE Reddit
    SET start_season = LEFT(season, 4)::integer;




CREATE TABLE Games2 AS
SELECT Games.game_date, Games.start_season, Games.home_team, Games.away_team, Games.home_score, Games.away_score, 
        Games.winner, Games.halftime_home_goals, Games.halftime_away_goals, Games.halftime_winner, Games.referee,
        Games.home_position, Games.away_position, Games.home_won, Games.away_won,
        Games.home_drawn, Games.away_drawn, Games.home_lost, Games.away_lost,
        Games.home_avg_goals_scored_per_match, Games.away_avg_goals_scored_per_match, 
        Games.home_avg_goals_conceded_per_match, Games.away_avg_goals_conceded_per_match,
        Games.home_clean_sheets, Games.away_clean_sheets, Games.home_biggest_win, 
        Games.away_biggest_win, Games.home_worst_defeat, Games.away_worst_defeat,
        Games.home_possession_percent, Games.away_possession_percent, Games.home_shots_on_target,
        Games.away_shots_on_target, Games.home_shots, Games.away_shots,
        Games.home_touches, Games.away_touches, Games.home_passes, Games.away_passes,home_tackles,
        Games.away_tackles, Games.home_clearances, Games.away_clearances, Games.home_corners,
        Games.away_corners, Games.home_offsides, Games.away_offsides, Games.home_yellow_cards,
        Games.away_yellow_cards, Games.home_red_cards, Games.away_red_cards,
        Games.home_fouls_conceded, Games.away_fouls_conceded,
        Reddit.team AS reddit_home_team, Reddit.total_post as reddit_home_post,
        Reddit.total_comments AS reddit_home_comments, Reddit.score AS reddit_home_score, 
        Reddit.positive AS reddit_home_positive, Reddit.negative AS reddit_home_negative
FROM Reddit
INNER JOIN Games
    ON Games.start_season = Reddit.start_season AND
        Games.home_team = Reddit.team
ORDER BY Games.game_date;


CREATE TABLE Combined_Data AS
SELECT Games2.game_date, Games2.start_season, Games2.home_team, Games2.away_team, Games2.home_score, Games2.away_score, 
        Games2.winner, Games2.halftime_home_goals, Games2.halftime_away_goals, Games2.halftime_winner, Games2.referee,
        Games2.home_position, Games2.away_position, Games2.home_won, Games2.away_won,
        Games2.home_drawn, Games2.away_drawn, Games2.home_lost, Games2.away_lost,
        Games2.home_avg_goals_scored_per_match, Games2.away_avg_goals_scored_per_match, 
        Games2.home_avg_goals_conceded_per_match, Games2.away_avg_goals_conceded_per_match,
        Games2.home_clean_sheets, Games2.away_clean_sheets, Games2.home_biggest_win, 
        Games2.away_biggest_win, Games2.home_worst_defeat, Games2.away_worst_defeat,
        Games2.home_possession_percent, Games2.away_possession_percent, Games2.home_shots_on_target,
        Games2.away_shots_on_target, Games2.home_shots, Games2.away_shots,
        Games2.home_touches, Games2.away_touches, Games2.home_passes, Games2.away_passes,home_tackles,
        Games2.away_tackles, Games2.home_clearances, Games2.away_clearances, Games2.home_corners,
        Games2.away_corners, Games2.home_offsides, Games2.away_offsides, Games2.home_yellow_cards,
        Games2.away_yellow_cards, Games2.home_red_cards, Games2.away_red_cards,
        Games2.home_fouls_conceded, Games2.away_fouls_conceded,
        Games2.reddit_home_team, Games2.reddit_home_post, Games2.reddit_home_comments,
        Games2.reddit_home_score, Games2.reddit_home_positive, Games2.reddit_home_negative,
        Reddit.team AS reddit_away_team, Reddit.total_post as reddit_away_post,
        Reddit.total_comments AS reddit_away_comments, Reddit.score AS reddit_away_score, 
        Reddit.positive AS reddit_away_positive, Reddit.negative AS reddit_away_negative
FROM Reddit
INNER JOIN Games2
    ON Games2.start_season = Reddit.start_season AND
        Games2.away_team = Reddit.team
ORDER BY Games2.game_date;


-- Save Data
\copy Combined_Data TO 'C:\Users\Eric\Desktop\SoccerPredictions\Data\Combined_Data.csv' DELIMITER ',' CSV HEADER;

