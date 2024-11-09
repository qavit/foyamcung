from django.db import models


class Course(models.Model):
    name = models.CharField(max_length=100)  # 課程名稱
    level = models.CharField(max_length=50)  # 課程等級，如：初級、中級
    description = models.TextField(blank=True, null=True)  # 課程描述
    created_at = models.DateTimeField(auto_now_add=True)  # 建立時間
    updated_at = models.DateTimeField(auto_now=True)      # 更新時間

    def __str__(self):
        return self.name

class Sentence(models.Model):
    chinese_sentence = models.TextField()  # 華語句子
    hakka_words = models.JSONField()       # 客語斷詞後的詞組（存放為字卡的列表）

    def __str__(self):
        return self.chinese_sentence
