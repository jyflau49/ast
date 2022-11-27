# ast
1.	Pre-requisite: Get docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
2.	Get repo
git clone https://github.com/jyflau49/ast.git
3.	Get docker image
docker pull lauyufung1994/ast:latest
4.	Edit & rename environmental variables file .env.sample to .env
5.	(dev) Build with docker build -t ast .
6.	For Selenium testing, run command docker run -d -p 4444:4444 -p 7900:7900 -e SE_START_XVFB=false -e SE_NODE_OVERRIDE_MAX_SESSIONS=true -e SE_NODE_MAX_SESSIONS=4 --shm-size="2g" --name grid selenium/standalone-chrome
7.	(dev) Enter shell with docker run -it --rm --add-host blog.cocajola.xyz:23.50.63.25 --network=host --env-file=.env ast
8.	(prod) Enter shell with docker run -it --rm --add-host blog.cocajola.xyz:23.50.63.25 --network=host --env-file=.env lauyufung1994/ast
9.	Use available commands