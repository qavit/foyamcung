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

class Word(models.Model):
    hakka_text = models.CharField(max_length=50)  # 客家文字
    meaning = models.TextField()  # 語義
    image = models.ImageField(upload_to='word_images/', blank=True, null=True)  # 圖片
    image_base64 = models.TextField(blank=True, null=True)  # 存放Base64編碼的圖片
    pinyin = models.CharField(max_length=50)  # 拼音

    def __str__(self):
        return self.hakka_text
    
    '''
    def save_image_as_base64(self, image_file):
        """
        將上傳的圖片轉換為Base64字串並儲存在 `image_base64` 欄位。
        """
        image = Image.open(image_file)
        buffered = BytesIO()
        image.save(buffered, format="PNG")
        img_str = base64.b64encode(buffered.getvalue()).decode('utf-8')
        self.image_base64 = img_str
    '''
    