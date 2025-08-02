from flask import Flask, redirect

app = Flask(__name__)

@app.route("/")
def home():
    return '''
        <html>
            <body>
                <h1>Hello, Flask on port 5000!</h1>
                <p>Click on the links below:</p>
                <ul>
                    <li><a href="/redirect/immich">Immich</a></li>
                    <li><a href="/redirect/cloud">Nextcloud</a></li>
                </ul>
            </body>
        </html>
    '''

@app.route("/redirect/<service>")
def redirect_service(service):
    if service == "immich":
        return redirect("http://immich.home")  # Nginx will handle this
    elif service == "cloud":
        return redirect("http://cloud.home")  # Nginx will handle this
    else:
        return "Service not found", 404

if __name__ == "__main__":
    # Binding to '0.0.0.0' allows access via localhost and network IP
    app.run(host="0.0.0.0", port=5000)
