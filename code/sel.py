from selenium import webdriver # type: ignore
from selenium.webdriver.common.by import By # type: ignore
from selenium.webdriver.chrome.options import Options # type: ignore
from concurrent.futures import ThreadPoolExecutor, wait # type: ignore
from dotenv import load_dotenv #type: ignore
import datetime
import time
from queue import Queue

load_dotenv()

urls = [
    "en.wikipedia.org/wiki/Special:Random?q=1",
    "en.wikipedia.org/wiki/Special:Random?q=2",
    "en.wikipedia.org/wiki/Special:Random?q=3",
    "en.wikipedia.org/wiki/Special:Random?q=4",
    "en.wikipedia.org/wiki/Special:Random?q=5"
]

q = Queue()

# putting all urls into queue
for i in range(len(urls)):
    q.put(urls[i])

def run_once():
    url = q.get()
    print('url added to queue: ' + url)
    # setting up headless chrome options
    options = webdriver.ChromeOptions()
    options.add_argument('--ignore-ssl-errors=yes')
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--headless')
    options.add_argument("--window-size=1920,1080")
    options.add_argument("user-agent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36")
    # send job to the grid container
    driver = webdriver.Remote("http://grid:4444/wd/hub",options=options)
    print('grid webdriver loaded')
    driver.get("https://" + url)
    time.sleep(5)
    date_stamp = str(datetime.datetime.now())
    date_stamp = date_stamp.replace(" ", "_").replace(":", "_").replace("-", "_").replace(".", "_")
    file_name = date_stamp + ".png"
    driver.save_screenshot(file_name)

    # printing website title
    print('title:\n' + driver.title + '\n')

    driver.quit()

# future instances for multithreading
futures = []

# multithreading executor
with ThreadPoolExecutor() as executor:
    for number in range(0, int(len(urls))):
        futures.append(
            executor.submit(run_once)
        )
        
# wait for futures to complete
wait(futures)
