from rest_framework import serializers


class PostData(object):
    def __init__(self, post):
        self.id = post.id
        self.created = post.created
        self.update_date = post.update_date
        self.link = post.link
        self.title = post.title
        self.abstract = post.abstract
        self.tags = post.tags
        self.clicked = post.clicked
        self.starts = post.starts
        self.site = post.site.host
        pans = [pp.pan for pp in post.postpans_set.all()]
        self.pans = [{'id': p.id, 'link': p.link, 'clicked': p.clicked} for p in pans]

class PanSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    link = serializers.URLField()
    clicked = serializers.IntegerField()

class PostSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    created = serializers.DateTimeField()
    update_date = serializers.DateTimeField()
    link = serializers.URLField()
    title = serializers.CharField()
    abstract = serializers.CharField()
    tags = serializers.CharField()
    clicked = serializers.IntegerField()
    starts = serializers.IntegerField()
    site = serializers.CharField()
    pans = PanSerializer(many=True)

