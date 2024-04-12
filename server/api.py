from flask import Flask, request, jsonify
import werkzeug

app = Flask(__name__)

@app.route('/upload_image', methods=['POST'])
def upload():
    if(request.method=='POST'):
        image_file = request.files['image']
        filename = werkzeug.utils.secure_filename(image_file.filename)
        image_file.save("C:/Users/Bhanu2003/OneDrive/Desktop/test1/server/uploaded_images/"+filename)
        return jsonify({
            "message" : "Image uploaded succesfully"
        })

@app.route('/upload_audio', methods=['POST'])
def upload_audio():
    if request.method == 'POST':
        audio_file = request.files['audio']
        filename = werkzeug.utils.secure_filename(audio_file.filename)
        audio_file.save("C:/Users/Bhanu2003/OneDrive/Desktop/test1/server/uploaded_audio/" + filename)
        return jsonify({
            "message": "Audio uploaded successfully"
        })

@app.route('/test', methods=['GET'])
def test():
    return "hello world"

if __name__ == '__main__':
    app.run(debug=True, port=4000)