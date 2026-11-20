# -*- coding: utf-8 -*-
"""批量转写 TeamSpeak 音效包所有 wav 的语音内容"""
import json
import os
import sys
from faster_whisper import WhisperModel

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOUND_DIR = os.path.join(ROOT, "src", "sound", "Manbo Soundpack")
OUT_JSON = os.path.join(ROOT, "docs", "transcripts.json")

def main():
    model = WhisperModel("small", device="cpu", compute_type="int8")
    results = []
    files = sorted(
        f for f in os.listdir(SOUND_DIR)
        if f.lower().endswith(".wav")
    )
    for i, fname in enumerate(files, 1):
        path = os.path.join(SOUND_DIR, fname)
        # 短提示音：关闭 VAD 过滤，避免漏掉语音；语言限定英语提高短句准确率
        segments, info = model.transcribe(
            path,
            language="en",
            beam_size=5,
            vad_filter=False,
            condition_on_previous_text=False,
            without_timestamps=True,
        )
        text_parts = []
        prob_sum = 0.0
        n = 0
        for seg in segments:
            t = seg.text.strip()
            if t:
                text_parts.append(t)
                prob_sum += seg.avg_logprob
                n += 1
        text = " ".join(text_parts)
        avg_prob = (prob_sum / n) if n else None
        results.append({
            "file": fname,
            "text": text,
            "avg_logprob": round(avg_prob, 3) if avg_prob is not None else None,
        })
        flag = "" if text else "  <-- (无语音/纯音效?)"
        print(f"[{i}/{len(files)}] {fname}: {text!r}{flag}", flush=True)

    with open(OUT_JSON, "w", encoding="utf-8") as f:
        json.dump(results, f, ensure_ascii=False, indent=2)
    print(f"\nDone. {len(results)} files -> {OUT_JSON}")

if __name__ == "__main__":
    sys.exit(main())
