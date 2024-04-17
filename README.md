# Ayoto App Project

An AI based flutter app used to make diagnosis of a sick person through NLP and Machine learning and give you appropriate results. Moreover you can see the list of available doctors according to the identified problems and book an appointment.

## Getting Started

Currently the app is in demo phase and still in testing. Available features are:

-Account Management (Sign up and Log in)

-Chat bot

-Appointment system

-Booking System

-Profile pages

-Localization and contacts for doctors

-Main Screen showing details about future appointments

## How to Use 

**Step 1:**

[Download or clone this repo by using this link:](https://github.com/AyotoAI/ayoto-mobile-frontend)

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

**Step 3:**

Connect your mobile device in debug mode or open a virtual machine

**Step 4:**

Run 
```
flutter.bat --no-color build apk
```

Or just click on play button on Android Studio


### Packages used:

-cupertino_icons: 1.0.2

-http: 1.0.0

-flutter_map: 5.0.0

-latlong2: 0.9.0

-url_launcher: 6.1.11

-buttons_tabbar: 1.3.7

-geolocator: 9.0.2

-geocoding: 2.1.0

-jwt_decoder: 2.0.1


### Folder Structure

```
flutter-app/
|- android
|- assets
|- fonts
|- ios
|- lib
|- test
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- main.dart - This is the starting point of the application. From there you can access the rest of the major screens of the app. You can also control some important states like user_id and authentifications
2- AppointmentScreen.dart - This screen is used to give details about a specific appointment (Date, Time, doctor, location). you can also create an appointment from this screen
3- ChoosingScreen.dart - This screen is displayed after the chatbot finishes its diagnosis. It gives you a list of possible appointments you can have
4- ChatScreen.dart - The main screen of the chat bot, it updates and displays your messages as well as the options you have for replying to the bot
5- ProfileScreen.dart - Screen to see details about your profile
6- authentication/LoginScreen - Write your credentials to access your account
7- authentication/SignupScreen - You're able to create an account here and specify details that will help later for the diagnosis
```

### UI

You can find some screenshots of the app here:

<img src="https://github.com/AyotoAI/ayoto-mobile-frontend/assets/54815296/a165ef57-406a-4271-b966-97be50448c05" width="200">
<img src="https://github.com/AyotoAI/ayoto-mobile-frontend/assets/54815296/8443a9d7-4361-4923-ae29-914881acda01" width="200">
<img src="https://github.com/AyotoAI/ayoto-mobile-frontend/assets/54815296/0a92083e-bdc6-4bd9-8310-bc8cf01dcc72" width="200">
<img src="https://github.com/AyotoAI/ayoto-mobile-frontend/assets/54815296/d9998e14-37d4-4eb9-8757-b2c9cd1d858f" width="200">
<img src="https://github.com/AyotoAI/ayoto-mobile-frontend/assets/54815296/2134f009-3dc5-4549-a824-7795ba1dd5fb" width="200">
<img src="https://github.com/AyotoAI/ayoto-mobile-frontend/assets/54815296/8cfa59a0-34f4-449d-bff9-59ec8f707237" width="200">
<img src="https://github.com/AyotoAI/ayoto-mobile-frontend/assets/54815296/8011045b-c1c8-4c2b-a2c9-b8657ee5b3a7" width="200">



### Demo Video:

https://drive.google.com/file/d/1BZNND7Jt2V-2SncmBhAyZOgMO3bPTaXY/view?usp=sharing

### APK Download:

https://drive.google.com/file/d/12wBofeks4hx5sZm04EMYhSCY_UnOkBfF/view?usp=sharing

