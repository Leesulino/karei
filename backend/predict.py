import re
import faiss
import json
import numpy as np
from sentence_transformers import SentenceTransformer
from template_matching import match_keywords_to_template

# 모델 및 인덱스 로딩
model = SentenceTransformer('all-MiniLM-L6-v2')
index = faiss.read_index("faiss_index_kairescope.faiss")

with open("caption_lookup_kairescope.json", "r", encoding="utf-8") as f:
    lookup = json.load(f)

# 추출 키워드 목록 (유저가 확장 가능)
KEYWORDS = ["tunnel", "abandoned_hospital", "school", "shrine", "forest", "bridge", "cemetery", "ruins"]

def extract_keywords_from_caption(caption):
    caption = caption.lower()
    return [kw for kw in KEYWORDS if kw in caption]

def convert_distance_to_level(distance):
    # 예: cosine 유사도 대신 L2 사용 시
    # 0에 가까울수록 유사하므로 100 - 정규화된 거리 사용
    norm = min(distance / 5.0, 1.0)  # 거리 0~5 기준 정규화
    return round((1.0 - norm) * 100)

def predict_result(query_caption, lang="en"):
    print(f"\n📝 Caption: {query_caption}")

    # 벡터화 & 검색
    query_embedding = model.encode([query_caption], convert_to_numpy=True)
    D, I = index.search(query_embedding, k=1)

    matched = lookup[str(I[0][0])]
    matched_caption = matched["caption"]
    print(f"🔍 Top Match: {matched_caption}")

    # 간섭도 계산
    distance = D[0][0]
    level_percent = convert_distance_to_level(distance)

    # 키워드 추출
    keywords = extract_keywords_from_caption(matched_caption)
    print(f"🔑 Keywords: {keywords}")

    # 템플릿 메시지 선택
    message_template = match_keywords_to_template(keywords, lang=lang)
    final_message = message_template.replace("{level}", str(level_percent))

    print(f"\n🎭 Final Output: {final_message}")
    return {
        "matched_caption": matched_caption,
        "keywords": keywords,
        "interference_level": level_percent,
        "message": final_message
    }

# 테스트 실행
if __name__ == "__main__":
    query = input("Enter BLIP2-style caption: ")
    lang = input("Language (en/ja/ko/zh): ").strip().lower()
    result = predict_result(query, lang=lang)
