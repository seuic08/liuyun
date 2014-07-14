from django.template import RequestContext
from django.shortcuts import render_to_response

from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser
from liuyun.models import Pans, PostPans, Posts, Sites 
from liuyun.serializers import PostSerializer, PostData 

# directly use db connetion, the django.db.connection seems not effective.
import psycopg2
db_connection = psycopg2.connect(
    'dbname=liuyun user=liuyun password=123456')

def index(request):
    context = RequestContext(request)
    context_dict = {'poem': 'hello world'}
    return render_to_response('index.html', context_dict, context)


class JSONResponse(HttpResponse):
    def __init__(self, data, **kwargs):
        content = JSONRenderer().render(data)
        kwargs['content_type'] = 'application/json'
        super(JSONResponse, self).__init__(content, **kwargs)


# posts?sort=created&limit=5&start=0
@csrf_exempt
def get_posts(request):
    try:
        sort = request.GET.get('sort', '-update_date')
        limit = int(request.GET.get('limit', '10'))
        start = int(request.GET.get('start', '0'))
    except ValueError:
        return HttpResponse(status=400)
   
    if ((sort not in ('update_date', '-update_date')) or
        (limit < 0 or limit > 100) or
        (start < 0)):
        return HttpResponse(status=400)
        
    posts = Posts.objects.order_by(sort).all()[start:start+limit]
    posts_data = [PostData(p) for p in posts]
    serializer = PostSerializer(posts_data, many=True)
    return JSONResponse(serializer.data)

# search?q=xxxx
# TODO how about its transactions? and pagination..
@csrf_exempt
def search_posts(request):
    query = request.GET.get('q', '')
    result_ids = []
    with db_connection.cursor() as cur:
        cur.execute("SELECT id FROM posts, to_tsquery('jiebacfg', %s) query WHERE \
                     ts_idx_col @@ query ORDER BY \
                     ts_rank(posts.ts_idx_col, query) DESC", [query])
        result_ids = cur.fetchall()

    result_ids = [i[0] for i in result_ids]
    result = Posts.objects.filter(id__in = result_ids)
    posts_data = [PostData(p) for p in result]
    serializer = PostSerializer(posts_data, many=True)
    return JSONResponse(serializer.data)
