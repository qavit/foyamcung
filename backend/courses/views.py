from django.http import HttpResponse
from rest_framework import viewsets

from .models import Sentence, Course, Word
from .serializers import SentenceSerializer, CourseSerializer, WordSerializer
import random
from rest_framework.decorators import action
from django.http import JsonResponse


class SentenceViewSet(viewsets.ModelViewSet):
    queryset = Sentence.objects.all()
    serializer_class = SentenceSerializer


class CourseViewSet(viewsets.ModelViewSet):
    queryset = Course.objects.all()
    serializer_class = CourseSerializer

    def filter_queryset(self, queryset):
        level = self.request.query_params.get('level', None)
        if level is not None:
            queryset = queryset.filter(level=level)
        return queryset

class WordViewSet(viewsets.ModelViewSet):
    queryset = Word.objects.all()
    serializer_class = WordSerializer

     # 自訂的 action
    @action(detail=False, methods=['get'])
    def questionList(self, request):
        # 隨機選擇一個字作為題目
        question_word = random.choice(Word.objects.all())
        print(question_word)
        # 選擇題目時，隨機決定顯示的屬性：拼音、圖片或語義
        option_type = random.choice(['pinyin', 'image', 'meaning'])
        
        # 根據選擇的類型獲取正確答案選項
        if option_type == 'pinyin':
            correct_answer = question_word.pinyin
        elif option_type == 'image' and question_word.image:
            correct_answer = question_word.image.url
        else:
            correct_answer = question_word.meaning

        # 添加正確答案選項
        options = [correct_answer]
        
        # 從其餘單字中隨機挑選兩個，並根據選擇的類型生成干擾選項
        other_words = Word.objects.all().exclude(id=question_word.id)
        while len(options) < 3:
            word = random.choice(other_words)
            if option_type == 'pinyin':
                option = word.pinyin
            elif option_type == 'image' and word.image:
                option = word.image.url
            else:
                option = word.meaning
            # 確保選項不重複
            if option not in options:
                options.append(option)

        # 將選項隨機打亂
        random.shuffle(options)

        # 返回 JSON 格式的題目資料
        return JsonResponse({
            'question': question_word.hakka_text,
            'options': options,
            'correct_answer_index': options.index(correct_answer)
        })



def temp_home(request):
    return HttpResponse("Welcome to the Hakka Learning App!")
