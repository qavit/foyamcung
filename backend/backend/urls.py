from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from courses.views import temporary_homepage, SentenceViewSet

router = DefaultRouter()
router.register(r'sentences', SentenceViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include(router.urls)),
    path('', temporary_homepage),
]
