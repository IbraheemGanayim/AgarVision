:: first run command: heroku login
:: then run command: heroku container:login
:: and after that you can run this script
docker build -t registry.heroku.com/agarvision-api/web . 
docker push registry.heroku.com/agarvision-api/web 
heroku container:release web --app agarvision-api
