from fastapi import FastAPI, Request
from pydantic import BaseModel
import faiss
import json
import numpy as np
from sentence_transformers import SentenceTransformer
from template_matching import match_keywords_to_template

# === 초기 세팅 ===

app = FastAPI()
model = SentenceTransformer('all-MiniLM-L6-v2')
index = faiss.read_index("faiss_index_kairescope.faiss")

with open("caption_lookup_kairescope.json", "r", encoding="utf-8") as f:
    lookup = json.load(f)

KEYWORDS = ["tunnel", "abandoned_hospital", "school", "shrine", "forest", "bridge", "cemetery", "ruins"]

# === 데이터 모델 ===

class CaptionInput(BaseModel):
    caption: str
    lang: str = "en"

# === 헬퍼 ===

def extract_keywords_from_caption(caption):
    caption = caption.lower()
    return [kw for kw in KEYWORDS if kw in caption]

def convert_distance_to_level(distance):
    norm = min(distance / 5.0, 1.0)
    return round((1.0 - norm) * 100)

# === 엔드포인트 ===

@app.post("/predict")
def predict(input: CaptionInput):
    caption = input.caption
    lang = input.lang.lower()

    query_embedding = model.encode([caption], convert_to_numpy=True)
    D, I = index.search(query_embedding, k=1)

    matched = lookup[str(I[0][0])]
    matched_caption = matched["caption"]
    keywords = extract_keywords_from_caption(matched_caption)
    level = convert_distance_to_level(D[0][0])

    template = match_keywords_to_template(keywords, lang=lang)
    message = template.replace("{level}", str(level))

    return {
        "input_caption": caption,
        "matched_caption": matched_caption,
        "keywords": keywords,
        "interference_level": level,
        "message": message,
        "lang": lang
    }
