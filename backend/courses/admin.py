# courses/admin.py
from django.contrib import admin
from .models import Course, Sentence

admin.site.register(Course)
admin.site.register(Sentence)
