from WebAPI import Flask
from WebAPI import create_app
import os

app = create_app()
# print(os.environ)


# if __name__ == '__main__':
#     app.run(port=os.getenv('PORT'))