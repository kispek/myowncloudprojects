from flask import Flask, jsonify
import os 


app = Flask(__name__)

@app.route('/health')
def health():
    return jsonify({
        "status": "running", 
        "environment": "minikube",
        "arch": "m2-arm64",
        "pod_name": os.getenv("HOSTNAME", "unknown-pod")
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

