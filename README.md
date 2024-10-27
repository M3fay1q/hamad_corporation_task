# Hamad Corporation Task

This Flutter application provides user login, account management, and background notifications with a 2-minute automatic logout for inactivity. Notifications are managed by `flutter_local_notifications`.

## Features

- **Login & Registration:** Secure login and registration with Hive storage and Flutter Secure Storage.
- **Account Renewal:** Users can renew their account, which resets the inactivity timer.
- **Automatic Logout:** Automatically logs out the user after 2 minutes of inactivity, with background tasks tracking user session.
- **Background Notifications:** Sends notifications to remind users of upcoming logout due to inactivity.
- **Local Storage:** Stores user data securely in Hive and Flutter Secure Storage.
- **Permissions Handling:** Dynamically requests and manages notification permissions.

## Packages Used

- **`flutter_bloc`**: Manages state across the app.
- **`hive`**: Lightweight, fast key-value database for data storage.
- **`hive_flutter`**: Integration between Hive and Flutter.
- **`flutter_secure_storage`**: Securely stores sensitive user data.
- **`flutter_local_notifications`**: Manages notifications, including scheduled reminders.
- **`intl`**: Provides internationalization and localization.
- **`permission_handler`**: Requests runtime permissions.
- **`workmanager`**: Manages background tasks to track user inactivity and trigger notifications.

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/M3fay1q/hamad_corporation_task.git
   cd hamad_corporation_task
