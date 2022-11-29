# ast build & run
1.	Pre-requisite: Get docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh ./get-docker.sh
2.	Get ast repo
    git clone https://github.com/jyflau49/ast.git
    (optional) Get ast docker image
    docker pull lauyufung1994/ast:latest
4.	Edit environmental variables file /.env and urls string list in /code/sel.py
5.	(local) Build with docker compose build ast
    (github actions) Auto builds at main branch remote repo push
6.	For Selenium testing, run command
    docker compose up -d grid
7.	(local) Enter shell with docker compose run --rm ast
    (docker hub build) Enter shell with docker compose run --rm lauyufung1994/ast