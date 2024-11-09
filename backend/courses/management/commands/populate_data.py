from django.core.management.base import BaseCommand
from courses.models import Course, Sentence


class Command(BaseCommand):
    help = 'Populate database with initial course and sentence data'

    def handle(self, *args, **kwargs):
        # 清空現有資料
        Course.objects.all().delete()
        Sentence.objects.all().delete()

        # 新增測試課程資料
        course_data = [
            {"name": "初級課程", "description": "適合初學者的客語基礎課程"},
            {"name": "進階課程", "description": "適合有基礎的學習者"},
        ]
        
        # 定義客語句子的中文對應和客語斷詞結果
        sentence_data = [
            {"chinese_sentence": "客語是我的母語。", "hakka_words": ["客話", "係", "吾", "阿姆話"]},
            {"chinese_sentence": "今天要學習新的客語詞彙。", "hakka_words": ["今晡日", "愛", "學習", "新个", "客話", "詞彙"]},
            {"chinese_sentence": "讓我們一起學習客語。", "hakka_words": ["𫣆俚", "共下", "學", "客話"]},
        ]

        for data in course_data:
            course = Course.objects.create(
                name=data["name"],
                description=data["description"]
            )
            print(f"新增課程：{course.name}")

            # 每個課程新增測試句子
            for sentence_info in sentence_data:
                sentence = Sentence.objects.create(
                    chinese_sentence=sentence_info["chinese_sentence"],
                    hakka_words=sentence_info["hakka_words"]
                )
                print(f"    新增句子：{sentence.chinese_sentence}")

