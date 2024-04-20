from .models import EmailOtp
from django.utils import timezone

def delete_otp():
    current_time = timezone.localtime()
    time_string = current_time.strftime('%H:%M:%S')
    EmailOtp.objects.filter(expiration_time__lt=time_string).delete()

delete_otp()