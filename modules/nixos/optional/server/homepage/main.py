from flask import Flask, redirect

app = Flask(__name__)

@app.route("/")
def home():
    return '''
        <html>
            <body>
                <h1>Hello!</h1>
                <p>Click on the links below:</p>
                <ul>
                    <li><a href="/redirect/immich">Immich</a></li>
                    <li><a href="/redirect/cloud">Nextcloud</a></li>
                    <li><a href="/redirect/glances">Glances</a></li>
                    <li><a href="/redirect/cockpit">Cockpit</a></li>
                    <li><a href="/redirect/ytdownload">ytdownload</a></li>
                </ul>
            </body>
        </html>
    '''

@app.route("/redirect/<service>")
def redirect_service(service):
    if service == "immich":
        return redirect("http://immich.home")
    elif service == "cloud":
        return redirect("http://cloud.home")
    elif service == "glances":
        return redirect("http://glances.home")
    elif service == "cockpit":
        return redirect("http://cockpit.home")
    elif service == "ytdownload":
        return redirect("http://ytdownload.home")
    else:
        return "Service not found", 404

if __name__ == "__main__":
    app.run()
