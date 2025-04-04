import json

# Load keyword-template mapping
with open("templates/en.json", "r", encoding="utf-8") as f:
    templates = json.load(f)

def match_keywords_to_template(keywords, lang="en"):
    matched = []

    for kw in keywords:
        if kw in templates:
            matched.append((kw, templates[kw]))

    if matched:
        # 가장 레벨이 높은 템플릿 우선
        matched.sort(key=lambda x: -_level_priority(x[1]["level"]))
        best = matched[0][1]
        return best["template"].get(lang, best["template"]["en"])
    else:
        return {
            "en": "No strong presence detected here…",
            "ja": "ここでは特に霊的な気配は感じません。",
            "ko": "이곳에서는 특별한 기운이 느껴지지 않네요.",
            "zh": "這裡似乎沒有什麼特別的靈異氣息……"
        }.get(lang, "No strong presence detected here…")

def _level_priority(level):
    return {
        "extreme": 3,
        "high": 2,
        "medium": 1,
        "low": 0
    }.get(level, 0)

# 예시 실행
if __name__ == "__main__":
    test_keywords = ["tunnel", "school"]
    msg = match_keywords_to_template(test_keywords, lang="ko")
    print(f"🗨️ {msg}")
