from http.server import BaseHTTPRequestHandler, HTTPServer
import os

PORT = int(os.getenv("PORT", "8080"))
TEXT = os.getenv("TEXT", "secureContImg: hello\n").encode("utf-8")

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(TEXT)))
        self.end_headers()
        self.wfile.write(TEXT)

    def log_message(self, format, *args):
        return

HTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
