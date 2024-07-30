from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
import os
import comtypes.client
import pythoncom

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = r'C:\Users\user\Desktop\PDF folder\uploaded_files'  # Ensure this folder exists

def convert_doc_to_pdf(input_path, output_path):
    pythoncom.CoInitialize()  # Initialize COM library
    word = comtypes.client.CreateObject("Word.Application")
    docx_path = os.path.abspath(input_path)
    pdf_path = os.path.abspath(output_path)
    pdf_format = 17  # PDF format code

    try:
        in_file = word.Documents.Open(docx_path)
        in_file.SaveAs(pdf_path, FileFormat=pdf_format)
        in_file.Close()
        return True
    except Exception as e:
        print(f"Error converting '{input_path}' to PDF: {str(e)}")
        return False
    finally:
        word.Quit()
        pythoncom.CoUninitialize()  # Uninitialize COM library

@app.route('/PDF_Maker', methods=['POST'])
def upload_file():
    print("Request files:", request.files)  # Debugging line
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400

    file = request.files['file']

    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    filename = secure_filename(file.filename)
    input_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    output_path = os.path.join(app.config['UPLOAD_FOLDER'], f'{os.path.splitext(filename)[0]}.pdf')

    try:
        file.save(input_path)
        print(f"Received file: {file.filename}")
        print(f"Saved file to: {input_path}")

        if os.path.exists(input_path):
            if convert_doc_to_pdf(input_path, output_path):
                os.remove(input_path)
                return jsonify({'success': 'File converted and saved successfully', 'output_path': output_path}), 200
            else:
                return jsonify({'error': 'Conversion failed'}), 500
        else:
            return jsonify({'error': 'File does not exist'}), 404

    except Exception as e:
        print(f"Exception: {str(e)}")
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    # Create upload folder if it doesn't exist
    os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
    app.run(debug=True)
