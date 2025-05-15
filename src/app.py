"""
Just a simple hello-world app.
"""

from flask import Flask
import os


app = Flask(__name__)


@app.route("/")
def hello_world():
    name = os.environ.get("NAME")
    return f"Hello, {name}!"
