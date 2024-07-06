import firebase_admin
from firebase_admin import messaging, credentials
from user.models import User
from .models import Notification
from django.utils import timezone
from datetime import timedelta

def send_notification():
    print("Starting send_notification function")
    try:
        current_time = timezone.localtime()
        time_string = current_time.strftime('%H:%M:%S')
        print(f"Current time: {current_time}")
        print(f"Time string: {time_string}")
        notifications = Notification.objects.filter(time__lte=time_string, date__lte=current_time.date())
        print(f"Found {notifications.count()} notifications to send")
        for notification in notifications:
            try:
                print(f"Processing notification for user: {notification.user.username}")
                user = notification.user
                fcm_token = user.fcm_token
                print(f"FCM token: {fcm_token}")
                if not fcm_token:
                    raise ValueError(f"No FCM token for user: {user.username}")
                message_body = f"It's time to feed your {notification.garden_name} plants."
                message_title = "Planteo"
                message = messaging.Message(
                    notification=messaging.Notification(
                        title=message_title,
                        body=message_body
                    ),
                    token=fcm_token
                )
                response = messaging.send(message)
                print(f'Successfully sent message: {response}')
                notification.date = current_time.date() + timedelta(days=3)
                notification.save()
                print('Notification updated successfully')
            except firebase_admin.exceptions.FirebaseError as e:
                print(f'Error sending message to {user.username}: {e}')
                if "Requested entity was not found" in str(e):
                    print(f'Invalid FCM token for user: {user.username}, token: {fcm_token}')
            except Exception as e:
                print(f'Error processing notification for user {notification.user.username}: {e}')
    except ValueError as e:
        print(f'ValueError: {e}')
    except Exception as e:
        print(f'Error in send_notification: {e}')

send_notification()




