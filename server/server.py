from flask import Flask, render_template
from flask_socketio import SocketIO, emit
from pyautogui import press
from flask_cors import CORS, cross_origin
import json

app = Flask(__name__, static_url_path='/', static_folder='.')
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app)#, cors_allowed_origins='*')
cors = CORS(app, origins=['*'])
app.config['CORS_HEADERS'] = 'Content-Type'
app.config['Access-Control-Allow-Origin'] = '*'
# app.config['Access-Control-Allow-Origin'] = ['*']
# Access-Control-Allow-Origin 

# Add static asset root directory from ../a
# @app.route('/')
# def index():
    # server entire a directory
    # return app.send_static_file('index.html')


@socketio.on('control')
@cross_origin()
def handle_control(key):
    #print('SOCKET' + str(key))
    key_handler(key['data'])
    emit('response', {'status': 'Controlled'})


def key_handler(key):
    data = json.loads(key.replace("'", '"'))
    expressions = data['expressions']

    if expressions['happy'] > 0.75:
        press('w')
    elif expressions['surprised'] > 0.75:
        press('s')
    elif expressions['sad'] > 0.75:
        press('t')

if __name__ == '__main__':
    socketio.run(app, port=5000, host='*')
