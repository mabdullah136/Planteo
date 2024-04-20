from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User,UserSubmittedImage,Feedback

@admin.register(User)
class UserAdmin(BaseUserAdmin):
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'password1', 'password2', 'email', 'first_name', 'last_name','phone','image'),
        }),
    )
    list_display=['username','email','image']
    list_editable = ['image','email'] 


@admin.register(UserSubmittedImage)
class UserSubmittedImageAdmin(admin.ModelAdmin):
    list_display=['user','subject','upload_date']


@admin.register(Feedback)
class FeedbackAdmin(admin.ModelAdmin):
    list_display=['user','info','feedback_text']