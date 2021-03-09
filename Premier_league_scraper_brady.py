from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from time import sleep
from datetime import datetime
import pandas as pd

errors = []
season = []
for id in range(32419, 46985): #3287,46985 #59162, 59163 17853,32419 32419,46985
    # Opening the connection and grabbing the page
    my_url = f'https://www.premierleague.com/match/{id}'
    option = Options()
    option.headless = False
    driver = webdriver.Chrome('/Users/tollbrothers/Downloads/Stats_170/chromedriver',options=option)
    driver.get(my_url)
    driver.maximize_window()
    sleep(5)

    # Scraping the data
    try:
        cookie = WebDriverWait(driver, 3).until(
            EC.element_to_be_clickable((By.XPATH, '//div[@class="btn-primary cookies-notice-accept"]')))
        cookie.click()
        
        date = driver.find_element_by_xpath('//*[@id="mainContent"]/div/section/div[2]/section/div[1]/div/div[1]/div[1]').text
        date = datetime.strptime(date, '%a %d %b %Y').strftime('%m/%d/%Y')
        
        home_team = driver.find_element_by_xpath(
            '//*[@id="mainContent"]/div/section/div[2]/section/div[3]/div/div/div[1]/div[1]/a[2]/span[1]').text
        away_team = driver.find_element_by_xpath(
            '//*[@id="mainContent"]/div/section/div[2]/section/div[3]/div/div/div[1]/div[3]/a[2]/span[1]').text
        scores = driver.find_element_by_xpath(
            '//*[@id="mainContent"]/div/section/div[2]/section/div[3]/div/div/div[1]/div[2]/div/div').text
        home_score = scores.split('-')[0]
        away_score = scores.split('-')[1]

        elem = WebDriverWait(driver, 3).until(
            EC.element_to_be_clickable((By.XPATH, "//ul[@class='tablist']//li[@data-tab-index='2']")))
        elem.click()
        sleep(3)

        #dfs = pd.read_html(driver.page_source)
        
        elem2 = WebDriverWait(driver, 3).until(
            EC.element_to_be_clickable((By.XPATH, 
                                        "/html/body/main/div/section[2]/div[2]/div/div[2]/section[3]/div[1]/ul/ul/li[1]")))
        elem2.click()
        sleep(3)
        
        dfs1 = pd.read_html(driver.page_source)
        
        stats = dfs1[-1]
        stats1 = dfs1[-2]
        

        driver.quit()

    except Exception as inst:
        print(type(inst))    # the exception instance
        print(inst.args)     # arguments stored in .args
        print(inst) 
        driver.quit()
        errors.append(id)
        continue

    # Handling the stats
    home_stats = {}
    away_stats = {}

    home_series = stats[home_team]
    away_series = stats[away_team]
    stats_series = stats['Unnamed: 1']
    
    home_series1 = stats1[home_team]
    away_series1 = stats1[away_team]
    stats_series1 = stats1['Unnamed: 1']
    
    for row in zip(home_series, stats_series, away_series):
        stat = row[1].replace(' ', '_').lower()
        home_stats[stat] = row[0]
        away_stats[stat] = row[2]
    
    for row in zip(home_series1, stats_series1, away_series1):
        stat = row[1].replace(' ', '_').lower()
        home_stats[stat] = row[0]
        away_stats[stat] = row[2]
    
    stats_check = ['position', 'won', 'drawn', 'lost', 'avg_goals_scored_per_match',
                   'avg_goals_conceded_per_match', 'clean_sheets', 'biggest_win',
                   'worst_defeat','possession_%', 'shots_on_target', 'shots', 
                   'touches', 'passes', 'tackles', 'clearances', 'corners', 
                   'offsides', 'yellow_cards','red_cards', 'fouls_conceded']

    for stat in stats_check:
        if stat not in home_stats.keys():
            home_stats[stat] = 0
            away_stats[stat] = 0

    # Storing the data
    match = [date, home_team, away_team, home_score, away_score, home_stats['position'], away_stats['position'],
             home_stats['won'], away_stats['won'], home_stats['drawn'], away_stats['drawn'],
             home_stats['lost'], away_stats['lost'], home_stats['avg_goals_scored_per_match'], 
             away_stats['avg_goals_scored_per_match'],home_stats['avg_goals_conceded_per_match'],
             away_stats['avg_goals_conceded_per_match'], home_stats['clean_sheets'], away_stats['clean_sheets'],
             home_stats['biggest_win'], away_stats['biggest_win'], home_stats['worst_defeat'], away_stats['worst_defeat'],
             home_stats['possession_%'], away_stats['possession_%'],home_stats['shots_on_target'], 
             away_stats['shots_on_target'], home_stats['shots'], away_stats['shots'],
             home_stats['touches'], away_stats['touches'], home_stats['passes'], away_stats['passes'],
             home_stats['tackles'], away_stats['tackles'], home_stats['clearances'], away_stats['clearances'],
             home_stats['corners'], away_stats['corners'], home_stats['offsides'], away_stats['offsides'],
             home_stats['yellow_cards'], away_stats['yellow_cards'], home_stats['red_cards'], away_stats['red_cards'],
             home_stats['fouls_conceded'], away_stats['fouls_conceded']]
    season.append(match)

    print(f'ID {id} scraped.')

# Exporting the data
columns = ['date', 'home_team', 'away_team', 'home_score', 'away_score']
stats_check = ['position', 'won', 'drawn', 'lost', 'avg_goals_scored_per_match',
                   'avg_goals_conceded_per_match', 'clean_sheets', 'biggest_win',
                   'worst_defeat','possession_%', 'shots_on_target', 'shots', 
                   'touches', 'passes', 'tackles', 'clearances', 'corners', 
                   'offsides', 'yellow_cards','red_cards', 'fouls_conceded']
for stat in stats_check:
    columns.append(f'home_{stat}')
    columns.append(f'away_{stat}')

dataset = pd.DataFrame(season, columns=columns)
dataset.to_csv('Premier_league_10_20.csv', index=False)
print('.csv file exported.')
print(f'Number of errors: {len(errors)}')
print('Errors:\n')
print(errors)