--\i 'C:/Users/Eric/Desktop/SoccerPredictions/createTables.sql'

/*
Tasks
Fix the date in DataUK
    Make year into 4 digits- Done
    Make the date day, month, year- Done
    Remove games from before the 2010 season- Done
Join Web_Scrapped and DataUK's 5 columns
    Both Webscrapped and DataUK have different names for team- Done
    I will need to change the team names for DataUK into Webscrapped- Done
    Check for full dataset
    Append each feature
    Put this into a new table
Remove games from before 2013
Join with Reddit Data
*/


DROP TABLE IF EXISTS Reddit;
DROP TABLE IF EXISTS DataUK;
DROP TABLE IF EXISTS Web_Scrapped;

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
\copy DataUK FROM 'C:/Users/Eric/Desktop/SoccerPredictions/Data/Sample Data/DataUK_Data_Sample.csv' with delimiter ',' csv header
\copy Web_Scrapped FROM 'C:/Users/Eric/Desktop/SoccerPredictions/Data/Sample Data/Premier_league_10_20_Sample.csv' with delimiter ',' csv header

-- Full Datasets
--\copy Reddit FROM 'C:/Users/Eric/Desktop/SoccerPredictions/Data/EPL_Reddit_Data.csv' with delimiter ',' csv header
--\copy DataUK FROM 'C:/Users/Eric/Desktop/SoccerPredictions/Data/DataUK_Data.csv' with delimiter ',' csv header
--\copy Web_Scrapped FROM 'C:/Users/Eric/Desktop/SoccerPredictions/Data/Premier_league_10_20.csv' with delimiter ',' csv header


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
    --SET date_fixed = CAST((SUBSTRING(game_date, 4, 2) || '/' || LEFT(game_date, 2) || '/20' || RIGHT(game_date, 2)) as DATE);



-- Remove games from before 2010
DELETE FROM DataUK
    WHERE DATE_PART('year', CAST(date_fixed AS DATE)) < 2010;

-- Remove games from the 2009- 2010 season
DELETE FROM DataUK
    WHERE DATE_PART('year', CAST(date_fixed AS DATE)) = 2010 and
            DATE_PART('month', CAST(date_fixed AS DATE)) < 7;



-- These teams have the same name in both datasets 
/*
SELECT DISTINCT Web_Scrapped.home_team
FROM Web_Scrapped
INNER JOIN DataUK ON Web_Scrapped.home_team = DataUK.home_team;
*/

-- Left ones only appear in DataUK
-- Right ones only appear in Webscrapper
/*
SELECT DISTINCT DataUK.home_team, Web_Scrapped.home_team
FROM Web_Scrapped
FULL OUTER JOIN DataUK ON Web_Scrapped.home_team = DataUK.home_team
ORDER BY DataUK.home_team;
*/


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


/*
SELECT DISTINCT DataUK.home_team, Web_Scrapped.home_team
FROM Web_Scrapped
FULL OUTER JOIN DataUK ON Web_Scrapped.home_team = DataUK.home_team
ORDER BY DataUK.home_team;
*/









SELECT Web_Scrapped.game_date, Web_Scrapped.home_team, Web_Scrapped.away_team, Web_Scrapped.home_score, Web_Scrapped.away_score, DataUK.winner
FROM DataUK
INNER JOIN Web_Scrapped
    ON Web_Scrapped.game_date = DataUK.date_fixed AND 
        Web_Scrapped.home_team = DataUK.home_team AND 
        Web_Scrapped.away_team = DataUK.away_team
ORDER BY Web_Scrapped.game_date;



-- SELECT * FROM Web_Scrapped;






