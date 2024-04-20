from rest_framework import permissions
from rest_framework.exceptions import AuthenticationFailed

'''
Permission class to check if the user is authenticated.
'''
class IsOwnerOrAdmin(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.user.is_authenticated:
            return True
        raise AuthenticationFailed('Authentication credentials not provided')
    
'''
Permission class to check if the user is a superuser (admin).
'''
class IsAdminUser(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user and request.user.is_superuser
    
class IsQueryOwner(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        return obj.user == request.user
