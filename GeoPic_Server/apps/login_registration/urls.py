from django.conf.urls import url
from . import views

urlpatterns=[
    url(r'^$', views.index),
    url(r'^processLogin/$', views.processLogin),
    url(r'^processRegister/$', views.processRegister),
    url(r'^getRecentPosts/$', views.getRecentPosts),
    url(r'^getPost/$', views.getPost),
    url(r'^uploadFile/$', views.uploadFile),
    url(r'^processUpload/$', views.processUpload),
    url(r'^uploadImage/$', views.uploadImage),
    url(r'^fetchAll/$', views.fetchAll),
    url(r'^searchPosts/$', views.searchPosts),
    url(r'^alamoTest/$', views.alamoTest),
    url(r'^alamoDataUpload/$', views.alamoDataUpload),
    url(r'^getPostAlamo/(?P<post_id>\d+)/$', views.getPostAlamo),
    url(r'^viewPicture/$', views.viewPicture)
]