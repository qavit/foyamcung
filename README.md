# Foyamcung ᖭི༏ᖫྀ⋆｡˚𖦹

**Foyamcung** is a cross-platform app that can help you learn Siyen Hakka.

**火焰蟲**係一隻𨃰平台个 app，做得同你學四縣客話。 [[▶️ Play audio]](/frontend/assets/audio/foyamcung_intro.wav)

**foˋ iam cungˇ** he id zagˋ kiam piangˇ toiˇ ge app ， zo do tungˇ ngiˇ hog xi ien hagˋ fa。

**Fó-yam-chhùng** he yit chak khiam-phiàng-thòi ke app, cho-tet thùng ngì ho̍k Si-yen Hak-fa.

## Future work

### More modules

- Video module
- Dictionary module
- ~~News module~~
- ~~Chatbot module~~


### Integrate with AI models

#### Text-To-Speech (TTS)

| Model | Demo |
| --- | --- |
| [`facebook/mms-tts-hak`](https://huggingface.co/facebook/mms-tts-hak) | [`ninumm/mms-tts-en`](https://huggingface.co/spaces/ninumm/mms-tts-en) |
| [`formospeech/yourtts-htia-240704`](https://huggingface.co/formospeech/yourtts-htia-240704) | [`united-link/taiwanese-hakka-tts`](https://huggingface.co/spaces/united-link/taiwanese-hakka-tts) |

#### Neural Machine Translation (NMT)

| Model | Demo |
| --- | --- |
| [`facebook/m2m100_418M`](https://huggingface.co/facebook/m2m100_418M)\* | [`qavit/MT_demo.m2m100_418M`](https://huggingface.co/spaces/qavit/MT_demo.m2m100_418M) |
| [`facebook/nllb-200-distilled-600M`](https://huggingface.co/facebook/nllb-200-distilled-600M)\* | [`qavit/MT_demo.nllb-200`](https://huggingface.co/spaces/qavit/MT_demo.nllb-200) |

\* Requires fine-tuning to translate Hakka

#### Automatic Speech Recognition (ASR)

## Acknowledgements

- Video sample: [暗夜新聞-氣象氣象主播黃脩筑(四縣腔)-太平洋熱帶系統活躍 東北風迎風面雨稍增 【客家新聞20241111】](https://www.youtube.com/watch?v=kOkqJlJM0Sw) by  HakkaTV
- Font: [Open Huninn Font](https://github.com/justfont/open-huninn-font) by JustFont
