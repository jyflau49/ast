# ast local build & run
1.	Pre-requisite: Get docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh ./get-docker.sh
2.	Get ast repo
    git clone https://github.com/jyflau49/ast.git
    (optional) Get ast docker image
    docker pull lauyufung1994/ast:latest
4.	Edit environmental variables file .env and docker-compose extra_hosts
5.	(local) Build with docker build -t ast .
    (github actions) Auto builds at main branch remote repo push
6.	For Selenium testing, run command 
    docker run -d -p 4444:4444 -p 7900:7900 -e SE_START_XVFB=false -e SE_NODE_OVERRIDE_MAX_SESSIONS=true -e SE_NODE_MAX_SESSIONS=4 --shm-size="2g" --name grid selenium/standalone-chrome
7.	(local) Enter shell with docker run -it --rm --add-host blog.cocajola.xyz:23.50.63.25 --network=host --env-file=.env ast
    (github) Enter shell with docker run -it --rm --add-host blog.cocajola.xyz:23.50.63.25 --network=host --env-file=.env lauyufung1994/ast

docker compose up grid -d
docker ps
docker compose run --rm shorthand
extrahost