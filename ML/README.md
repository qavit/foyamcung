# ML API 使用說明

本目錄目前包含三個主要的 Python 腳本，用於處理文本轉語音（TTS）的功能，並將結果儲存為 WAV 檔案。

## 目錄

- [環境需求](#環境需求)
- [腳本說明](#腳本說明)
  - [`app.py`](#apppy)
  - [`test_api.py`](#test_apipy)
  - [`convert_to_wav.py`](#convert_to_wavpy)
- [使用方法](#使用方法)
  - [啟動 FastAPI 服務](#啟動-fastapi-服務)
  - [測試 API](#測試-api)
  - [轉換 JSON 到 WAV](#轉換-json-到-wav)

## 環境需求

- Python 3.9+
- 安裝必要套件：
  ```bash
  pip install fastapi uvicorn requests transformers torch soundfile
  ```

## 腳本說明

### `app.py`

這個腳本使用 FastAPI 建立一個 TTS API 服務，TTS 模型來自 **[`facebook/mmt-tts-hak`](https://huggingface.co/facebook/mms-tts-hak)**。我們使用 `Transformers` 函式庫中的 `VitsModel` 和 `AutoTokenizer` 來將載入模型及其 tokenizer。

- **端點**：`/predict/tts`
- **方法**：POST
- **請求格式**：JSON，包含 `text` 欄位
- **回應格式**：JSON，包含 `sampling_rate` 和 `audio_base64`

### `test_api.py`

這個腳本用於測試部署在 Cloud Run 上的 TTS API。它發送一個 POST 請求到 API，並將回傳的音訊儲存為 WAV 檔案。

- **引數**：
  - `--api_url`：API 的 URL（預設為 Cloud Run 的 URL `https://foyamcung-tts-api-test-367294676317.asia-east1.run.app/predict/tts`）
  - `--text`：要轉換的文本（預設為範例文本 `Fó-yam-chhùng he yit chak khiam-phiàng-thòi ke app, cho-tet thùng ngì ho̍k Si-yen Hak-fa.`）
  - `--output`：輸出 WAV 檔案的路徑（預設為 `test.wav`）

### `convert_to_wav.py`

這個腳本將包含 Base64 編碼音訊的 JSON 檔案轉換為 WAV 檔案。

- **函式**：`save_base64_to_wav(json_path, output_wav_path)`
- **使用**：直接執行腳本，將 `test.json` 轉換為 `test.wav`

## 使用方法

### 啟動 FastAPI 服務

1. 在終端機中執行以下命令以啟動 FastAPI 服務：
   ```bash
   uvicorn app:app --host 0.0.0.0 --port 8000
   ```

2. 服務啟動後，可以在 `http://localhost:8000/docs` 查看自動生成的 API 文件。

### 測試 API

1. 使用 `test_api.py` 腳本測試 API：
   ```bash
   python test_api.py
   ```

2. 你可以使用命令列引數來覆蓋預設值，例如：
   ```bash
   python test_api.py --text "Sîn ke vùn-pún" --output "new_test.wav"
   ```
    注意 **[`facebook/mmt-tts-hak`](https://huggingface.co/facebook/mms-tts-hak)** 模型能接受的文本是客語白話字，否則無法產生正常的語音。
### 轉換 JSON 到 WAV

1. 使用 `convert_to_wav.py` 腳本將 JSON 檔案轉換為 WAV 檔案：
   ```bash
   python convert_to_wav.py
   ```

2. 確保 `test.json` 文件存在且格式正確。

這樣，你就可以使用這些腳本來進行文本轉語音的處理，並將結果儲存為 WAV 檔案。若有任何問題或需要進一步的幫助，請隨時聯繫。 