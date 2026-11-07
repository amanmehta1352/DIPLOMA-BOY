"""Multi-round chat with DeepSeek via OpenRouter. Keeps the whole conversation in robots/ideas/conv.json.
Each run sends robots/ideas/next.md as the next user turn, saves the reply as robots/ideas/out/round_N.md. Never prints the key."""
import json, os, sys, urllib.request
key = os.environ.get("OPENROUTER_API_KEY") or sys.exit("OPENROUTER_API_KEY missing")
model = os.environ.get("OPENROUTER_MODEL", "deepseek/deepseek-chat")
cp = "robots/ideas/conv.json"
conv = json.load(open(cp, encoding="utf-8")) if os.path.exists(cp) else [
    {"role": "system", "content": open("robots/ideas/system.md", encoding="utf-8").read()}]
conv.append({"role": "user", "content": open("robots/ideas/next.md", encoding="utf-8").read()})
body = {"model": model, "temperature": 0.8, "max_tokens": 8000, "messages": conv}
req = urllib.request.Request("https://openrouter.ai/api/v1/chat/completions", data=json.dumps(body).encode(),
      headers={"Authorization": "Bearer " + key, "Content-Type": "application/json"})
with urllib.request.urlopen(req, timeout=900) as r:
    res = json.load(r)
text = res["choices"][0]["message"]["content"]
conv.append({"role": "assistant", "content": text})
json.dump(conv, open(cp, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
n = sum(1 for m in conv if m["role"] == "assistant")
os.makedirs("robots/ideas/out", exist_ok=True)
open(f"robots/ideas/out/round_{n}.md", "w", encoding="utf-8").write(text)
log = "robots/ideas/out/cost_log.jsonl"
open(log, "a").write(json.dumps({"round": n, "model": res.get("model"), "usage": res.get("usage")}) + "\n")
print("round", n, "model", res.get("model"), "chars", len(text), "cost", (res.get("usage") or {}).get("cost"))
