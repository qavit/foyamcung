from django.db import models


class Sentence(models.Model):
    chinese_sentence = models.TextField()  # 華語句子
    hakka_words = models.JSONField()       # 客語斷詞後的詞組（存放為字卡的列表）

    def __str__(self):
        return self.chinese_sentence
