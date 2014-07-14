import datetime

from django.test.runner import DiscoverRunner 
from django.test import TestCase

from liuyun.models import Posts, Sites

# copy from http://www.caktusgroup.com/blog/2010/09/24/simplifying-the-testing-of-unmanaged-database-models-in-django/
class LiuyunTestRunner(DiscoverRunner):
    """
    Test runner that automatically makes all unmanaged models in your Django
    project managed for the duration of the test run, so that one doesn't need
    to execute the SQL manually to create them.
    """
    def setup_test_environment(self, *args, **kwargs):
        from django.db.models.loading import get_models
        self.unmanaged_models = [m for m in get_models()
                                 if not m._meta.managed]
        for m in self.unmanaged_models:
            m._meta.managed = True
        super(LiuyunTestRunner, self).setup_test_environment(*args,
                                                             **kwargs)

    def teardown_test_environment(self, *args, **kwargs):
        super(LiuyunTestRunner, self).teardown_test_environment(*args,
                                                                **kwargs)
        # reset unmanaged models
        for m in self.unmanaged_models:
            m._meta.managed = False

class PostsTest(TestCase):
    def test_get_post(self):
        Sites.objects.create(id=0, host='example.com')
        Posts.objects.create(created=datetime.datetime(2014, 5, 26),
                link='1.html', title='hello', abstract='hello world', site_id=0)
        expected = '[{"id": 1, "created": "2014-05-26T00:00:00Z", ' \
                '"link": "1.html", "title": "hello", "abstract": "hello world", ' \
                '"content": "", "clicked": null, "starts": null, ' \
                '"site": "example.com", "pans": []}]'
        
        response = self.client.get('/posts?sort=created&limit=10&start=0')
        self.assertEqual(response.content, expected)
        response = self.client.get('/posts')
        self.assertEqual(response.content, expected)
        response = self.client.get('/posts?sort=create')
        self.assertEqual(response.status_code, 400)
        response = self.client.get('/posts?sort=invalid')
        self.assertEqual(response.status_code, 400)
