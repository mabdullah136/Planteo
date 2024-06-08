from rest_framework import serializers
from djoser.serializers import UserSerializer as BaseUserSerializer,UserCreateSerializer as BaseUserCreateSerializer
from django.contrib.auth.password_validation import validate_password
from .models import User,UserSubmittedImage,Feedback,Votes
from django.conf import settings
from rest_framework.exceptions import ValidationError


class UserCreateSerializer(BaseUserCreateSerializer):
    class Meta(BaseUserCreateSerializer.Meta):
        fields=['username','password','email','first_name','last_name','phone']

    def create(self, validated_data):
        if 'first_name' not in validated_data:
            validated_data['first_name'] = validated_data.get('username', '')

        return super().create(validated_data)

class ChangePasswordserializer(serializers.Serializer):
    old_password = serializers.CharField(write_only=True, required=True)
    new_password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    def validate_old_password(self, value):
        user = self.context['request'].user
        if not user.check_password(value):
            raise serializers.ValidationError("Incorrect old password")
        return value

    def validate(self, data):
        if data['old_password'] == data['new_password']:
            raise serializers.ValidationError("New password must be different from the old password")
        return data

    def save(self):
        user = self.context['request'].user
        user.set_password(self.validated_data['new_password'])
        user.save()

class ForgetPasswordSerializer(serializers.Serializer):
    new_password = serializers.CharField(write_only=True, required=True)

    def validate_new_password(self, value):
        try:
            validate_password(value)
        except ValidationError as e:
            raise serializers.ValidationError(e.messages)
        return value

    def save(self):
        user = self.context['request'].user
        user.set_password(self.validated_data['new_password'])
        user.save()


class UserUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model=User
        fields=['id','first_name','last_name','phone','image','bio']

class CreateUserQuerySerializer(serializers.ModelSerializer):
    class Meta:
        model=UserSubmittedImage
        fields=['user','image','subject','description']

class CreateQuesyFeedbackSerializer(serializers.ModelSerializer):
    class Meta:
        model=Feedback
        fields=['feedback_text','likes']

class UserQuerySerializer(serializers.ModelSerializer):
    class Meta:
        model = UserSubmittedImage
        fields = '__all__'

class FeedbackTextSerializer(serializers.ModelSerializer):
    class Meta:
        model = Feedback
        fields=['info','user','feedback_text']

class VotesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Votes
        fields=['feedback_info','likes']