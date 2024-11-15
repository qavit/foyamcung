from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from courses.views import temp_home, SentenceViewSet, CourseViewSet, WordViewSet

router = DefaultRouter()
router.register(r'sentences', SentenceViewSet)
router.register(r'courses', CourseViewSet)  # 註冊 courses 路由
router.register(r'words', WordViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include(router.urls)),
    path('', temp_home),
]
