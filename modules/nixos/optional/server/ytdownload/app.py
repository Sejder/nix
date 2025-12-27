# /// script
# requires-python = ">=3.12"
# dependencies = [
#   "flask",
#   "gunicorn",
# ]
# ///

import subprocess
import threading
from flask import Flask, render_template_string, request, jsonify
import time
import queue
import os

app = Flask(__name__)

# Global variables to store process state
current_process = None
output_queue = queue.Queue()
process_complete = False

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>YouTube Downloader</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; text-align: center; }
        .form-group { margin: 20px 0; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="url"] { width: 100%; padding: 12px; border: 2px solid #ddd; border-radius: 4px; font-size: 16px; }
        button { background: #007bff; color: white; padding: 12px 24px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        button:hover { background: #0056b3; }
        button:disabled { background: #6c757d; cursor: not-allowed; }
        .output { margin-top: 20px; padding: 15px; background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 4px; white-space: pre-wrap; font-family: monospace; max-height: 400px; overflow-y: auto; }
        .loading { display: none; text-align: center; margin: 20px 0; }
        .spinner { border: 4px solid #f3f3f3; border-top: 4px solid #3498db; border-radius: 50%; width: 40px; height: 40px; animation: spin 2s linear infinite; margin: 0 auto; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        .clear-btn { background: #28a745; margin-left: 10px; }
        .clear-btn:hover { background: #218838; }
    </style>
</head>
<body>
    <div class="container">
        <h1>YouTube Downloader</h1>
        <form id="downloadForm">
            <div class="form-group">
                <label for="url">YouTube URL:</label>
                <input type="url" id="url" name="url" placeholder="https://www.youtube.com/watch?v=..." required>
            </div>
            <button type="submit" id="downloadBtn">Download</button>
            <button type="button" id="clearBtn" class="clear-btn" onclick="clearOutput()">Clear</button>
            <button type="button" id="updateBtn" onclick="updateYtdlp()">Update yt-dlp</button>
        </form>
        
        <div id="loading" class="loading">
            <div class="spinner"></div>
            <p>Downloading... Please wait.</p>
        </div>
        
        <div id="output" class="output" style="display: none;"></div>
    </div>

    <script>
        let polling = false;
        
        document.getElementById('downloadForm').onsubmit = async function(e) {
            e.preventDefault();
            
            const url = document.getElementById('url').value;
            const downloadBtn = document.getElementById('downloadBtn');
            const loading = document.getElementById('loading');
            const output = document.getElementById('output');
            
            // Reset UI
            downloadBtn.disabled = true;
            loading.style.display = 'block';
            output.style.display = 'none';
            output.innerHTML = '';
            
            try {
                // Start download
                const response = await fetch('/download', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({url: url})
                });
                
                if (response.ok) {
                    // Start polling for output
                    startPolling();
                } else {
                    const error = await response.text();
                    output.innerHTML = 'Error: ' + error;
                    output.style.display = 'block';
                    loading.style.display = 'none';
                    downloadBtn.disabled = false;
                }
            } catch (error) {
                output.innerHTML = 'Network error: ' + error;
                output.style.display = 'block';
                loading.style.display = 'none';
                downloadBtn.disabled = false;
            }
        };
        
        function startPolling() {
            if (polling) return;
            polling = true;
            
            const pollOutput = async () => {
                try {
                    const response = await fetch('/output');
                    const data = await response.json();
                    
                    if (data.output) {
                        const output = document.getElementById('output');
                        output.innerHTML += data.output;
                        output.style.display = 'block';
                        output.scrollTop = output.scrollHeight;
                    }
                    
                    if (data.complete) {
                        polling = false;
                        document.getElementById('loading').style.display = 'none';
                        document.getElementById('downloadBtn').disabled = false;
                        return;
                    }
                    
                    setTimeout(pollOutput, 500);
                } catch (error) {
                    polling = false;
                    document.getElementById('loading').style.display = 'none';
                    document.getElementById('downloadBtn').disabled = false;
                }
            };
            
            pollOutput();
        }
        
        function clearOutput() {
            document.getElementById('output').innerHTML = '';
            document.getElementById('output').style.display = 'none';
            document.getElementById('url').value = '';
        }
    </script>
</body>
</html>
"""


@app.route("/")
def index():
    return render_template_string(HTML_TEMPLATE)


@app.route("/download", methods=["POST"])
def download():
    global current_process, output_queue, process_complete

    data = request.json
    url = data.get("url", "").strip()

    if not url:
        return "URL is required", 400

    # Clear previous output
    while not output_queue.empty():
        try:
            output_queue.get_nowait()
        except queue.Empty:
            break

    process_complete = False

    def run_ytdownload():
        global current_process, process_complete
        try:
            # Ensure Videos directory exists
            videos_dir = "/var/lib/ytdownload/Videos"
            os.makedirs(videos_dir, exist_ok=True)

            # Change to the working directory
            os.chdir("/var/lib/ytdownload")

            # Run ytdownload command
            output_queue.put("🚀 Starting download...\n")
            current_process = subprocess.Popen(
                ["ytdownload", url],
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                universal_newlines=True,
                bufsize=1,
                cwd="/var/lib/ytdownload",
            )

            # Stream output
            for line in iter(current_process.stdout.readline, ""):
                output_queue.put(line)

            current_process.wait()
            download_return_code = current_process.returncode

            if download_return_code == 0:
                output_queue.put("\n✅ Download completed successfully!\n")

                # Check if Videos directory has any files
                if os.path.exists(videos_dir) and os.listdir(videos_dir):
                    output_queue.put("📤 Starting upload to cloud storage...\n")

                    # Run rclone move command
                    current_process = subprocess.Popen(
                        [
                            "rclone",
                            "move",
                            "Videos",
                            "cloud:/netgear/Videos",
                            "-v",
                        ],
                        stdout=subprocess.PIPE,
                        stderr=subprocess.STDOUT,
                        universal_newlines=True,
                        bufsize=1,
                        cwd="/var/lib/ytdownload",
                    )

                    # Stream rclone output
                    for line in iter(current_process.stdout.readline, ""):
                        output_queue.put(line)

                    current_process.wait()
                    rclone_return_code = current_process.returncode

                    if rclone_return_code == 0:
                        output_queue.put(
                            "\n🎉 Upload completed successfully! Files moved to cloud:/netgear/Videos\n"
                        )
                    else:
                        output_queue.put(
                            f"\n❌ Upload failed with exit code {rclone_return_code}\n"
                        )
                else:
                    output_queue.put(
                        "\n⚠️  No files found in Videos directory to upload\n"
                    )
            else:
                output_queue.put(
                    f"\n❌ Download failed with exit code {download_return_code}\n"
                )

        except Exception as e:
            output_queue.put(f"\n❌ Error: {str(e)}\n")
        finally:
            process_complete = True
            current_process = None

    # Start download in background thread
    thread = threading.Thread(target=run_ytdownload)
    thread.daemon = True
    thread.start()

    return jsonify({"status": "started"})


@app.route("/output")
def get_output():
    global process_complete

    output_lines = []
    while not output_queue.empty():
        try:
            line = output_queue.get_nowait()
            output_lines.append(line)
        except queue.Empty:
            break

    return jsonify({"output": "".join(output_lines), "complete": process_complete})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8001)
