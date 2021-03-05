import requests
import urllib.request
from bs4 import BeautifulSoup

url = input("Enter the URL:- ")

if url.split('/')[-2] == 'board':
    page = requests.get(url)
    data = page.text
    soup = BeautifulSoup(data, 'html.parser')

    links = [link.get('data-fullimg') for link in soup.find_all('div', class_='flexbox_item') if link.get('data-fullimg') is not None]

    string = "https://www.wallpaperplay.com"
    output = ["{}{}".format(string,i) for i in links]

    count=1
    for final in output:
        filename = final.split('/')[-1]
        urllib.request.urlretrieve(final, filename)
        print(count,")", filename)
        count += 1
else:
    print("Invalid URL.")
