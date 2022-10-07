# Kumi

## Description
Kumi is a budget-tracking application that aims to improve users’ shopping experience and raise financial wellbeing by acting as a digital membership card wallet and provide analytics on their recent expenditure.

![Kumi - Save Money](https://user-images.githubusercontent.com/49807719/177492625-9a0dc5d5-8627-4863-a415-c21c6a7ac732.png)

 Part of what it sets out to enhance include:
- Memberships: Digital (and virtual) store card wallet 
- Explore: Search and compare deals from various grocery stores
- Analyse: Compare budget against daily, weekly, or monthly expenditure 
- Record: Jot down shopping records to track spending

The project is currently supported in Android, built with the Flutter framework.

## Installation
This project assumes you have Flutter installed and set up properly. (For more information, visit https://docs.flutter.dev/get-started/install)

Run the following commands to produce the Android APK:
```
cd app
flutter packages get
flutter clean
flutter build apk --release
```
The APK will now be produced inside the directory `app/build/app/outputs/apk/release` and ready to be installed.

## Roadmap
- [ ] Introduce OCR to parse receipts. This eliminates the need to prompt for user inputs and improves user experience.
- [ ] Provide an estimate on how much user may spend at the end of month based on trends
- [ ] iOS support
- [ ] Display largest purchase entries sorted by descending order 
- [ ] Integrate store location to factor in distance from user

## Authors and acknowledgment
- Jacqueline Lee 
- Khemi Chew 
- "Max" Herong Meng 
- Yutong Jiang

## Project status
This project is not actively maintained at the moment. If you are interested in extending the project, please contact the contributors of the project.
