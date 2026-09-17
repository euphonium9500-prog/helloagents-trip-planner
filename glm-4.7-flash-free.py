import os
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()

client = OpenAI(
    api_key=os.environ["AIHUBMIX_API_KEY"],
    base_url="https://aihubmix.com/v1",
)

response = client.chat.completions.create(
    model="glm-4.7-flash-free",
    messages=[
      {
        "role": "user",
        "content": "Hello!"
      },
      {
        "role": "assistant",
        "content": "Hello! How can I assist you today?"
      }
    ],
    max_tokens=4096,
    top_p=0.95,
    stream=True,
)

for chunk in response:
    print(chunk.choices[0].delta.content or "", end="")