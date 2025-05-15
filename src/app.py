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


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)  # nosec B104 # trigger rebuild
