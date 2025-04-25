from flask import Flask, request, jsonify
from flask_cors import CORS
from openai import OpenAI # Or use your custom NLP model
import firebase_admin
from firebase_admin import credentials, firestore
from dotenv import load_dotenv
import os


load_dotenv()
app = Flask(__name__)
CORS(app)

# Initialize Firebase
firebase_path = os.path.join(os.path.dirname(__file__), "firebase-admin-sdk.json")
cred = credentials.Certificate(firebase_path)
firebase_admin.initialize_app(cred)
db = firestore.client()

# OpenAI API Key
#openai_api_key = os.getenv("OPENAI_API_KEY")
#client = openai.OpenAI(api_key=openai_api_key)
#openai_api_key = "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"
#client = openai.OpenAI(api_key=openai_api_key)
client = OpenAI(
  base_url="https://openrouter.ai/api/v1",
  api_key="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",
)

@app.route('/chatbot', methods=['POST'])
def chatbot():
    user_input=request.json.get("message")

    response = client.chat.completions.create(
    extra_headers={
        "X-Title": "SereneMind Chatbot", # Optional. Site title for rankings on openrouter.ai.
    },
    extra_body={},
    model="meta-llama/llama-3.1-8b-instruct:free",
    messages=[
            {"role": "system", "content": "You are a mental health support chatbot."},
            {"role": "user", "content": user_input}
            ]
    )
    bot_reply = response.choices[0].message.content

    # Store chat history in Firestore
    db.collection("chats").add({
        "user": user_input,
        "bot": bot_reply
    })

    return jsonify({"response": bot_reply})
@app.route('/')
def home():
    return "Welcome to SereneMind Chatbot API!"

if __name__ == '__main__':
    app.run(debug=True)
