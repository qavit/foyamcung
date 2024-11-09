from rest_framework import serializers
from .models import Sentence, Course


class SentenceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sentence
        fields = '__all__'

class CourseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Course
        fields = '__all__'  # 包含所有欄位