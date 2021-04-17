
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt


def countRefereeGames(gamesDf: 'df'):
    """It returns the 10 referrees who referee the most games"""
    count = dict()
    for _, row in gamesDf.iterrows():
        if row['Referee'] not in count:
            count[row['Referee']] = 0
        count[row['Referee']] += 1

    top10 = dict()
    i = 0
    for k, v in sorted(count.items(), key = lambda x: -x[1]):
        top10[k] = v
        if i >= 11:     # 11 or 12
            break
        i += 1
    return top10


def RefereeStats(gamesDf: 'df', top10: {'referee': 'games'}):
    dfReferee = pd.DataFrame()
    for _, row in gamesDf.iterrows():
        if row['Referee'] in top10:
            dfReferee = dfReferee.append(row, ignore_index = True)
    dfReferee = dfReferee[['Referee', 'HomeFouls', 'AwayFouls', 'HomeYellow',
                           'AwayYellow', 'HomeRed', 'AwayRed']]
    return dfReferee


def RefereeAverages(dfReferee: 'df', top10: {'referee': 'games'}):
    avg = dict()
    for _, row in dfReferee.iterrows():
        if row['Referee'] not in avg:
            avg[row['Referee']] = {#'Referee': row['Referee'],
                                   'HomeFouls': 0,
                                   'AwayFouls': 0,
                                   'HomeYellow': 0,
                                   'AwayYellow': 0,
                                   'HomeRed': 0,
                                   'AwayRed': 0}
        avg[row['Referee']]['HomeFouls'] += row['HomeFouls']
        avg[row['Referee']]['AwayFouls'] += row['AwayFouls']
        avg[row['Referee']]['HomeYellow'] += row['HomeYellow']
        avg[row['Referee']]['AwayYellow'] += row['AwayYellow']
        avg[row['Referee']]['HomeRed'] += row['HomeRed']
        avg[row['Referee']]['AwayRed'] += row['AwayRed']

    for referee, v in avg.items():
        numGames = top10[referee]
        avg[referee]['HomeFouls'] = round(avg[referee]['HomeFouls']/ numGames, 3)
        avg[referee]['AwayFouls'] = round(avg[referee]['AwayFouls']/ numGames, 3)
        avg[referee]['HomeYellow'] = round(avg[referee]['HomeYellow']/ numGames, 3)
        avg[referee]['AwayYellow'] = round(avg[referee]['AwayYellow']/ numGames, 3)
        avg[referee]['HomeRed'] = round(avg[referee]['HomeRed']/ numGames, 3)
        avg[referee]['AwayRed'] = round(avg[referee]['AwayRed']/ numGames, 3)
        

    diff = dict()
    for k, v in avg.items():
        diff[k] = dict()
        diff[k]['Foul Difference'] = round(v['HomeFouls'] - v['AwayFouls'], 3)
        diff[k]['Yellow Card Difference'] = round(v['HomeYellow'] - v['AwayYellow'], 3)
        diff[k]['Red Card Difference'] = round(v['HomeRed'] - v['AwayRed'], 3)
    return diff



def topReferees(gamesDf: 'df'):
    top10 = countRefereeGames(gamesDf)
    dfReferee = RefereeStats(gamesDf, top10)
    refereeAVG = RefereeAverages(dfReferee, top10)
    return refereeAVG



def plotReferee(refereeAVG: {'str':{'str': int}}) -> None:
    df = pd.DataFrame()
    for referee, v in refereeAVG.items():
        v['referee'] = referee
        df = df.append(v, ignore_index = True)
    
    dfs1 = pd.melt(df, id_vars = 'referee')
    #print(dfs1)
    g = sns.catplot(x = 'referee',
                     y = 'value',
                     hue = 'variable',
                     kind = 'bar',
                    palette=sns.color_palette(['green', 'red', 'yellow']),
                     data = dfs1)
    
    plt.title('Referees Preference for Home Teams', size = 20)
    plt.xlabel('Referees', size = 15)
    plt.ylabel('Average Home-Away', size = 15)


    # Tick Label Size
    _, xlabels = plt.xticks()
    g.set_xticklabels(xlabels, size = 12)
    _, ylabels = plt.yticks()
    g.set_yticklabels(ylabels, size = 12)

    

    g.set_xticklabels(rotation = 30)
    plt.show()







    










def main():
    games = f'../Data/CombinedTeamData.csv'
    gamesDf = pd.read_csv(games)
    gamesDf = gamesDf[3800:]    #2013 Season onwards
    refereeAVG = topReferees(gamesDf)
    #refereeAVG = {'A Taylor': {'Foul Difference': 0.602, 'Yellow Card Difference': -0.03, 'Red Card Difference': 0.025}, 'M Atkinson': {'Foul Difference': -1.015, 'Yellow Card Difference': -0.322, 'Red Card Difference': -0.014}, 'M Oliver': {'Foul Difference': -0.325, 'Yellow Card Difference': -0.204, 'Red Card Difference': -0.01}, 'N Swarbrick': {'Foul Difference': -0.415, 'Yellow Card Difference': 0.08, 'Red Card Difference': 0.01}, 'K Friend': {'Foul Difference': -0.779, 'Yellow Card Difference': -0.091, 'Red Card Difference': -0.007}, 'J Moss': {'Foul Difference': -0.529, 'Yellow Card Difference': -0.259, 'Red Card Difference': -0.005}, 'M Clattenburg': {'Foul Difference': -0.168, 'Yellow Card Difference': -0.355, 'Red Card Difference': 0.01}, 'A Marriner': {'Foul Difference': 0.074, 'Yellow Card Difference': -0.17, 'Red Card Difference': -0.034}, 'M Jones': {'Foul Difference': -0.568, 'Yellow Card Difference': -0.216, 'Red Card Difference': -0.041}, 'L Mason': {'Foul Difference': -0.881, 'Yellow Card Difference': -0.216, 'Red Card Difference': -0.028}, 'M Dean': {'Foul Difference': -0.59, 'Yellow Card Difference': -0.115, 'Red Card Difference': -0.105}, 'C Pawson': {'Foul Difference': -0.321, 'Yellow Card Difference': -0.327, 'Red Card Difference': -0.039}}
    #print(refereeAVG)
    plotReferee(refereeAVG)
    


# Things left to do
# Move the order of the bars so its fouls, yellow, red
# Change legend size



main()
