# Two sheets
# First one is just game information.
# Row for each game
# It has the winning and losing team


# Second sheet has team info on total wins, losses, ties,
# goals for, goals against, goals at home, goals away,
# goal home - goals away

import pandas as pd



def GamesOutput(dfGames: 'df') -> 'df':
    """It organizes the games so that we only the teams played and their score"""
    gamesBradley = pd.DataFrame()
    for _, row in dfGames.iterrows():
        if row['FTR'] == 'H':
            new_row = {'Winning Team': row['HomeTeam'],
                       'Winning Score': row['FTHG'],
                       'Losing Team': row['AwayTeam'],
                       'Losing Score': row['FTAG'],
                       'Tie?': ''}
        elif row['FTR'] == 'A':
            new_row = {'Winning Team': row['HomeTeam'],
                       'Winning Score': row['FTHG'],
                       'Losing Team': row['AwayTeam'],
                       'Losing Score': row['FTAG'],
                       'Tie?': ''}
        else:   # Tie
            new_row = {'Winning Team': row['HomeTeam'],
                       'Winning Score': row['FTHG'],
                       'Losing Team': row['AwayTeam'],
                       'Losing Score': row['FTAG'],
                       'Tie?': 'Yes'}
        gamesBradley = gamesBradley.append(new_row, ignore_index = True)
    gamesBradley = gamesBradley[['Winning Team', 'Winning Score',
                                 'Losing Team', 'Losing Score', 'Tie?']]
    return gamesBradley


def addGame (teams: {str: {str: int}}, name: str, result: str,
             pointsFor: int, pointsAgainst: int) -> None:
    """It adds individual final game result and
    the goals they scored and they let in"""
    if name not in teams:
        teams[name] = {'Wins': 0, 'Losses': 0, 'Ties': 0,
                       'Points For': 0, 'Points Against': 0, 'Team': name}
    if result == 'W':
        teams[name]['Wins'] += 1
    elif result == 'L':
        teams[name]['Losses'] += 1
    else:
        teams[name]['Ties'] += 1
    
    teams[name]['Points For'] += pointsFor
    teams[name]['Points Against'] += pointsAgainst


def addAVG(teams: {str: {str: int}}) -> None:
    """It determines the averages based off past games"""
    for team, v in teams.items():
        totalGames = teams[team]['Wins'] + teams[team]['Losses'] + teams[team]['Ties']
        teams[team]['Differential'] = teams[team]['Points For'] - teams[team]['Points Against']
        teams[team]['Avg Points For'] = teams[team]['Points For'] / totalGames
        teams[team]['Avg Points Against'] = teams[team]['Points Against'] / totalGames
        teams[team]['Avg Differential'] = teams[team]['Avg Points For'] - teams[team]['Avg Points Against']


def avgTeam(dfGames: 'df') -> 'df':
    """It determines the statistics for each team for that season"""
    teams = dict()
    for _, row in dfGames.iterrows():
        if row['FTR'] == 'H':
            HR, AR = 'W', 'L'
        elif row['FTR'] == 'A':
            HR, AR = 'L', 'W'
        else:
            HR, AR = 'T', 'T'
        
        addGame(teams, row['HomeTeam'], HR, row['FTHG'], row['FTAG'])
        addGame(teams, row['AwayTeam'], AR, row['FTAG'], row['FTHG'])

    addAVG(teams)
    avg = pd.DataFrame()
    for team, values in sorted(teams.items()):
        avg = avg.append(values, ignore_index = True)
    avg = avg[['Team', 'Wins', 'Losses', 'Ties', 'Points For',
               'Points Against', 'Differential', 'Avg Points For',
               'Avg Points Against', 'Avg Differential']]
    return avg





def main():
    dfGames = 'PLGames2018.csv'
    dfGames = pd.read_csv(dfGames)
    avg = avgTeam(dfGames)
    games = GamesOutput(dfGames)
    
    writer = pd.ExcelWriter('PL_Bradley.xlsx', engine='xlsxwriter')
    avg.to_excel(writer, sheet_name = 'Teams and Records', index = False)
    games.to_excel(writer, sheet_name = 'Games', index = False)
    writer.save()

    





main()
