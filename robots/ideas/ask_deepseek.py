"""Ask DeepSeek (via OpenRouter) for out-of-the-box presentation ideas. Writes only to robots/ideas/out/. Never prints the key."""
import json, os, sys, urllib.request
key = os.environ.get("OPENROUTER_API_KEY")
if not key:
    sys.exit("OPENROUTER_API_KEY missing")
model = os.environ.get("OPENROUTER_MODEL", "deepseek/deepseek-chat")
brief = open("robots/ideas/brief.md", encoding="utf-8").read()
prompt = open("robots/ideas/prompt.md", encoding="utf-8").read()
body = {"model": model, "temperature": 0.9, "max_tokens": 8000,
        "messages": [{"role": "system", "content": brief}, {"role": "user", "content": prompt}]}
req = urllib.request.Request("https://openrouter.ai/api/v1/chat/completions",
      data=json.dumps(body).encode(), headers={"Authorization": "Bearer " + key, "Content-Type": "application/json"})
with urllib.request.urlopen(req, timeout=600) as r:
    res = json.load(r)
os.makedirs("robots/ideas/out", exist_ok=True)
text = res["choices"][0]["message"]["content"]
open("robots/ideas/out/ideas.md", "w", encoding="utf-8").write(text)
json.dump({"model_used": res.get("model"), "usage": res.get("usage")}, open("robots/ideas/out/meta.json", "w"), indent=1)
print("model_used:", res.get("model"), "chars:", len(text))
