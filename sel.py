from selenium import webdriver # type: ignore
from selenium.webdriver.common.by import By # type: ignore
from selenium.webdriver.chrome.options import Options # type: ignore
from concurrent.futures import ThreadPoolExecutor, wait
import time

url = "blog.cocajola.xyz/"
run_limit = 20
print("Selenium is running. Please be patient.")

def run_once():
    options = webdriver.ChromeOptions()
    options.add_argument('--ignore-ssl-errors=yes')
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--headless')
    options.add_argument("user-agent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36")
    driver = webdriver.Remote("http://localhost:4444/wd/hub",options=options)
    driver.get("https://" + url)
    time.sleep(5)

    # search_temp = driver.find_element(By.XPATH, '/html/body/h1').text
    # print(driver.page_source.encode("utf-8")) # if you want to print the HTTP content
    print('title:\n' + driver.title + '\n')

    driver.quit()

# future instances for multithreading
futures = []

# multithreading executor
with ThreadPoolExecutor() as executor:
    for number in range(0, run_limit):
        futures.append(
            executor.submit(run_once)
        )
        
# wait for futures to complete
wait(futures)
