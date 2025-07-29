import os, queue, threading, subprocess, sounddevice as sd, torch, whisper, numpy as np
from datetime import datetime

model = whisper.load_model("medium" if torch.cuda.is_available() else "base")
samplerate = 16000
block_size = 4000
audio_queue = queue.Queue()
cmd_log = []

def callback(indata, frames, time, status):
    if status: print(status, flush=True)
    audio_queue.put(indata.copy())

def execute_cmd(command):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    cmd_log.append((timestamp, command))
    print(f"\n🚀 Executing: {command}\n")
    os.system(command)

def trigger_action(transcript):
    t = transcript.lower().strip()
    if "install" in t:
        execute_cmd("whisper install")
    elif "ci" in t:
        execute_cmd("whisper ci")
    elif "dash" in t:
        execute_cmd("whisper dash")
    elif "compose" in t:
        execute_cmd("whisper compose")
    elif "gcp" in t:
        execute_cmd("whisper gcp")
    elif "hugging face" in t or "huggingface" in t:
        execute_cmd("whisper hf")
    elif "local rc" in t or "localrc" in t:
        execute_cmd("whisper localrc")
    elif "ray" in t:
        execute_cmd("whisper ray")
    elif "exit" in t:
        print("🛑 Whisper listener stopped.")
        os._exit(0)
    else:
        print(f"🤷 Unrecognized command: {t}")

print("🎙️ Whisper Voice Agent ready. Say a command…")

with sd.InputStream(samplerate=samplerate, channels=1, callback=callback, blocksize=block_size):
    buffer = np.zeros((0, 1), dtype=np.float32)
    while True:
        block = audio_queue.get()
        buffer = np.concatenate((buffer, block), axis=0)
        if len(buffer) > samplerate * 4:
            audio = buffer.flatten()[-samplerate*4:]
            result = model.transcribe(audio, fp16=torch.cuda.is_available(), language="en")
            print(f"🔊 Heard: {result['text'].strip()}")
            threading.Thread(target=trigger_action, args=(result["text"],)).start()
