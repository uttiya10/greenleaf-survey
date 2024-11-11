# surveys/serializers.py
from rest_framework import serializers

class SurveySerializer(serializers.Serializer):
    name = serializers.CharField(max_length=64)
    description = serializers.CharField(max_length=64)