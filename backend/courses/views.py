from django.http import HttpResponse
from rest_framework import viewsets
from .models import Sentence
from .serializers import SentenceSerializer


class SentenceViewSet(viewsets.ModelViewSet):
    queryset = Sentence.objects.all()
    serializer_class = SentenceSerializer


def temporary_homepage(request):
    return HttpResponse("Welcome to the Hakka Learning App!")
