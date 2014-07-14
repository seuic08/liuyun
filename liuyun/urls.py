from django.conf.urls import patterns, include, url

from liuyun.views import index, get_posts, search_posts

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'liuyun.views.home', name='home'),
    url(r'^$', index),
    url(r'^posts$', get_posts),
    url(r'^search$', search_posts),
    #url(r'^admin/', include(admin.site.urls)),
)

'''
if settings.DEBUG:
    urlpatterns += patterns(
        'django.contrib.staticfiles.views',
        url(r'^static/(?P<path>.*)$', 'serve'),
    )
'''
