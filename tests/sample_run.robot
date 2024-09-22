*** Settings ***
Library           SeleniumLibrary
Library           XvfbRobot
Suite Setup    	  Start Virtual Display    1280		720

*** Test Cases ***
Open Browser in Virtual Display
    Open Browser    https://www.example.com    chrome	options=add_argument('--no-sandbox');add_argument('--disable-dev-shm-usage')
    Title Should Be    Example Domain
    Close Browser

