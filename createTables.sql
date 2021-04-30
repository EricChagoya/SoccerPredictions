--\i 'C:/Users/Eric/Desktop/SoccerPredictions/createTables.sql'


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
    --game_date date DMY,
    home_team varchar(30),
    away_team varchar(30),
    home_goals decimal,
    away_goals decimal,
    winner varchar(1),              -- Here
    halftime_home_goals decimal,    -- Here
    halftime_away_goals decimal,    -- Here
    halftime_winner varchar(1),     -- Here
    referee varchar(30),            -- Here
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
\copy Reddit FROM 'C:/Users/Eric/Desktop/SoccerPredictions/Data/Sample Data/EPL_Reddit_Data_Sample.csv' with delimiter ',' csv header
\copy DataUK FROM 'C:/Users/Eric/Desktop/SoccerPredictions/Data/Sample Data/DataUK_Data_Sample.csv' with delimiter ',' csv header
\copy Web_Scrapped FROM 'C:/Users/Eric/Desktop/SoccerPredictions/Data/Sample Data/Premier_league_10_20_Sample.csv' with delimiter ',' csv header


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







