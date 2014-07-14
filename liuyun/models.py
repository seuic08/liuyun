# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Remove `managed = False` lines for those models you wish to give write DB access
# Feel free to rename the models, but don't rename db_table values or field names.
#
# Also note: You'll have to insert the output of 'django-admin.py sqlcustom [appname]'
# into your database.
from __future__ import unicode_literals

from django.db import models

class Pans(models.Model):
    id = models.AutoField(primary_key=True)
    #link = models.TextField(unique=True)
    link = models.URLField(unique=True)
    clicked = models.IntegerField()
    class Meta:
        managed = False
        db_table = 'pans'

class PostPans(models.Model):
    id = models.AutoField(primary_key=True)
    post = models.ForeignKey('Posts')
    pan = models.ForeignKey(Pans)
    class Meta:
        managed = False 
        db_table = 'post_pans'
        unique_together = (('post', 'pan'),)

class Posts(models.Model):
    id = models.AutoField(primary_key=True)
    created = models.DateTimeField()
    #link = models.TextField(unique=True)
    link = models.URLField(unique=True)
    update_date = models.DateTimeField()
    title = models.TextField()
    abstract = models.TextField()
    tags = models.TextField(blank=True)
    pans = models.IntegerField(blank=True, null=True)
    viewed = models.IntegerField(blank=True, null=True)
    clicked = models.IntegerField(blank=True, null=True)
    starts = models.IntegerField(blank=True, null=True)
    site = models.ForeignKey('Sites', related_name='from_site')
    class Meta:
        managed = False
        db_table = 'posts'
    def __unicode__(self):
        return str(self.id)

class Sites(models.Model):
    id = models.AutoField(primary_key=True)
    host = models.TextField(unique=True)
    posts = models.IntegerField(blank=True, null=True)
    class Meta:
        managed = False
        db_table = 'sites'

