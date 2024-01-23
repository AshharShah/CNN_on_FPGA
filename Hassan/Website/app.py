from flask import Flask, request, render_template
from werkzeug.utils import secure_filename
import os

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads/'
app.config['ALLOWED_EXTENSIONS'] = {'png', 'jpg', 'jpeg'}
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in app.config['ALLOWED_EXTENSIONS']

@app.route('/', methods=['GET'])
def home():
    return render_template('home.html')

@app.route('/about', methods=['GET'])
def about():
    return render_template('about.html')

@app.route('/upload', methods=['GET', 'POST'])
def upload():
    if request.method == 'POST':
        if 'file' not in request.files:
            return render_template('upload.html', results={"error": "No file part"})
        file = request.files['file']
        if file.filename == '':
            return render_template('upload.html', results={"error": "No selected file"})
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(filepath)

            # Process the image using your CNN here
            # results = your_cnn_processing_function(filepath)

            # For now, let's just return a dummy result
            results = {"classification": "Class A", "accuracy": 95, "loss": 0.05}
            return render_template('upload.html', results=results)
    else:
        # When the page is first loaded, there are no results to show
        return render_template('upload.html', results=None)

if __name__ == '__main__':
    app.run(debug=True)

