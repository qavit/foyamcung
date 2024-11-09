from django.http import HttpResponse
from rest_framework import viewsets
from .models import Sentence, Course
from .serializers import SentenceSerializer, CourseSerializer


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


def temp_home(request):
    return HttpResponse("Welcome to the Hakka Learning App!")
