from flask import Flask
app = Flask(__name__)


@app.route('/')
def hello():
  return 'hello'

@app.route('/deploy-web',methods=['GET', 'POST'])
def deploy_web():
    import os
    os.system("git pull -f &&  make deploy-web")
    return 'OK'

if __name__ == '__main__':
    app.run(debug=True)