from rest_framework import serializers
from .models import Farmer, Buyer
from django.contrib.auth.hashers import make_password

class FarmerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Farmer
        fields = '__all__'

    # Automatically hash passwords when creating or updating
    def create(self, validated_data):
        validated_data['password'] = make_password(validated_data['password'])
        return super().create(validated_data)

    def update(self, instance, validated_data):
        if 'password' in validated_data:
            validated_data['password'] = make_password(validated_data['password'])
        return super().update(instance, validated_data)

class BuyerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Buyer
        fields = '__all__'

    # Automatically hash passwords when creating or updating
    def create(self, validated_data):
        validated_data['password'] = make_password(validated_data['password'])
        return super().create(validated_data)

    def update(self, instance, validated_data):
        if 'password' in validated_data:
            validated_data['password'] = make_password(validated_data['password'])
        return super().update(instance, validated_data)