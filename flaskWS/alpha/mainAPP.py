from flask import Flask, render_template

app = Flask(__name__, static_folder="/home/kim/projectOWL/flaskWS/alpha/static") #

@app.route('/')
@app.route('/home')
def home():
   return render_template('home.html')

@app.route('/dragons')
def dragons():
   return render_template('dragons.html')



if __name__ == "__main__":
    app.run(debug=True)
