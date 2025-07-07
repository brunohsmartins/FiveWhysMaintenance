import os, requests

headers = {"Authorization": f"Bearer {os.getenv('OPENROUTER_API_KEY')}"}
r = requests.get("https://openrouter.ai/api/v1/models", headers=headers)
models = [m["id"] for m in r.json()["data"]]
print("\n".join(models))
