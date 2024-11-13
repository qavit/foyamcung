import requests
import base64
import argparse

tts_api_url = 'https://foyamcung-tts-api-test-367294676317.asia-east1.run.app/predict/tts'
test_text = 'Fó-yam-chhùng he yit chak khiam-phiàng-thòi ke app, cho-tet thùng ngì ho̍k Si-yen Hak-fa.'
output_wav_path = 'test.wav'


def save_base64_to_wav(audio_base64, output_wav_path):
    # 解碼 base64 字串
    audio_bytes = base64.b64decode(audio_base64)

    # 寫入 WAV 檔案
    with open(output_wav_path, 'wb') as f:
        f.write(audio_bytes)


def test_tts_api(api_url, text, output_wav_path):
    # 準備請求資料
    payload = {
        "text": text
    }

    # 發送 POST 請求
    response = requests.post(api_url,
                             json=payload,
                             headers={'Content-Type': 'application/json'}
                             )

    # 檢查回應狀態
    if response.status_code == 200:
        # 解析 JSON 回應
        data = response.json()
        audio_base64 = data['audio_base64']

        # 將 base64 轉換成 WAV
        save_base64_to_wav(audio_base64, output_wav_path)
        print(f"WAV 檔案已儲存至 {output_wav_path}")
    else:
        print(f"請求失敗，狀態碼：{response.status_code}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Test TTS API and save output as WAV file.')
    parser.add_argument('--api_url', type=str, default=tts_api_url, help='The URL of the TTS API.')
    parser.add_argument('--text', type=str, default=test_text, help='The text to convert to speech.')
    parser.add_argument('--output', type=str, default=output_wav_path, help='The output WAV file path.')

    args = parser.parse_args()

    test_tts_api(args.api_url, args.text, args.output)
