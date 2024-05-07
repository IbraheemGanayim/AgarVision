:: first run command: heroku login
:: then run command: heroku container:login
:: and after that you can run this script

:: Build the Docker image with the tag 'registry.heroku.com/agarvision/web' for the current directory ('.').
docker build -t registry.heroku.com/agarvision/web .

:: Push the 'registry.heroku.com/agarvision/web' Docker image to the Heroku registry.
docker push registry.heroku.com/agarvision/web

:: Release the 'web' container for the 'agarvision' app using the 'registry.heroku.com/agarvision/web' image.
heroku container:release web --app agarvision
