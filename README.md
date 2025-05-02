# NORA - Nutrition & Goal Tracking Assistant

NORA is a SwiftUI-based iOS application designed to help users track their nutritional intake and achieve their health goals. It features an intuitive onboarding process, camera-based nutrition label scanning, personalized macro targets, a dynamic health score, and persistent storage for user data and history.

Unlike traditional trackers, NORA aims to educate users on managing their nutrition effectively based on personalized goals like Weight Loss, Muscle Gain, or General Health.

## Key Features

* **Modern Onboarding Experience:** A multi-step, animated onboarding flow (`IntroductoryScreens`) to welcome users, explain features, set health goals (`GoalsPage`), input weight (`NutritionPage`), and enter their name (`NamePage`). Uses `@AppStorage` to show only once.
* **Nutrition Label Scanner:**
    * Uses the device camera (`AVFoundation`, `UIKit` bridge via `UIViewControllerRepresentable`) and the `Vision` framework (`VNRecognizeTextRequest`) to scan and extract nutritional information (Fat, Cholesterol, Sodium, Carbs, Protein, Sugar) directly from food labels (`ImageScannerView`, `extractNutritionValues`).
    * Presents extracted data in an alert (`isShowingConfirmation`) for user confirmation before adding to daily totals.
* **Personalized Macro Targets:** Calculates daily target grams for Protein, Carbohydrates, and Fats based on the user's weight (`userWeight`), stored using `@AppStorage`.
* **Dynamic Health Score:** Calculates a daily "Health Score" (0-100) based on consumed macros versus targets, and intake of Sodium, Sugar, and Cholesterol against recommended maximums (`calculateHealthScore`). Displayed with an animated circular gauge (`AnimatedHealthScore`).
* **Dashboard (`TabOneView`):**
    * Displays the animated Health Score gauge.
    * Shows progress towards daily macro goals (Protein, Carbs, Fats) using clear progress bars (`MacroTrackerView`, `MacroProgressView`).
    * Features a prominent, custom-styled button (`FancyGreenButtonStyle`) to initiate the nutrition label scan.
* **Profile Management (`TabTwoView`):**
    * Displays the user's saved Name, selected Goal, and Weight (converted to lbs for display) using reusable info cards (`ProfileInfoCard`).
    * Includes a "Reset Profile" button to clear all stored data (`UserDefaults`, `@AppStorage`) and restart the onboarding process.
* **Nutrition History (`TabThreeView`):**
    * Logs each confirmed nutritional entry (`NutritionEntry`) including macros, score, and date.
    * Persistently stores history using `JSONEncoder`/`JSONDecoder` with `@AppStorage`.
    * Displays history entries in scrollable cards (`NutritionHistoryCard`).
* **Custom UI & Styling:**
    * Utilizes modern SwiftUI features like gradients (`LinearGradient`), custom button styles (`modernButtonStyle`, `FancyGreenButtonStyle`), tab views (`TabView`), and animations.
* **Data Persistence:** Uses `@AppStorage` and `UserDefaults` extensively to save user preferences (`hasSeenIntro`, `userName`, `selectedGoal`, `userWeight`) and nutritional history (`nutritionHistoryData`).

## Technology Stack

* **UI Framework:** SwiftUI
* **Camera Interaction:** AVFoundation (via UIKit bridge)
* **Text Recognition:** Vision Framework
* **Data Persistence:** `@AppStorage`, `UserDefaults`, `Codable` (for history)
* **Language:** Swift
* **Project Format:** Swift Playgrounds App (`.swiftpm`)
* **Platform:** iOS


## Project Structure
Okay, here is the README.md content with all emojis removed:

Markdown

# NORA - Nutrition & Goal Tracking Assistant

NORA is a SwiftUI-based iOS application designed to help users track their nutritional intake and achieve their health goals. It features an intuitive onboarding process, camera-based nutrition label scanning, personalized macro targets, a dynamic health score, and persistent storage for user data and history.

Unlike traditional trackers, NORA aims to educate users on managing their nutrition effectively based on personalized goals like Weight Loss, Muscle Gain, or General Health.

## Key Features

* **Modern Onboarding Experience:** A multi-step, animated onboarding flow (`IntroductoryScreens`) to welcome users, explain features, set health goals (`GoalsPage`), input weight (`NutritionPage`), and enter their name (`NamePage`). Uses `@AppStorage` to show only once.
* **Nutrition Label Scanner:**
    * Uses the device camera (`AVFoundation`, `UIKit` bridge via `UIViewControllerRepresentable`) and the `Vision` framework (`VNRecognizeTextRequest`) to scan and extract nutritional information (Fat, Cholesterol, Sodium, Carbs, Protein, Sugar) directly from food labels (`ImageScannerView`, `extractNutritionValues`).
    * Presents extracted data in an alert (`isShowingConfirmation`) for user confirmation before adding to daily totals.
* **Personalized Macro Targets:** Calculates daily target grams for Protein, Carbohydrates, and Fats based on the user's weight (`userWeight`), stored using `@AppStorage`.
* **Dynamic Health Score:** Calculates a daily "Health Score" (0-100) based on consumed macros versus targets, and intake of Sodium, Sugar, and Cholesterol against recommended maximums (`calculateHealthScore`). Displayed with an animated circular gauge (`AnimatedHealthScore`).
* **Dashboard (`TabOneView`):**
    * Displays the animated Health Score gauge.
    * Shows progress towards daily macro goals (Protein, Carbs, Fats) using clear progress bars (`MacroTrackerView`, `MacroProgressView`).
    * Features a prominent, custom-styled button (`FancyGreenButtonStyle`) to initiate the nutrition label scan.
* **Profile Management (`TabTwoView`):**
    * Displays the user's saved Name, selected Goal, and Weight (converted to lbs for display) using reusable info cards (`ProfileInfoCard`).
    * Includes a "Reset Profile" button to clear all stored data (`UserDefaults`, `@AppStorage`) and restart the onboarding process.
* **Nutrition History (`TabThreeView`):**
    * Logs each confirmed nutritional entry (`NutritionEntry`) including macros, score, and date.
    * Persistently stores history using `JSONEncoder`/`JSONDecoder` with `@AppStorage`.
    * Displays history entries in scrollable cards (`NutritionHistoryCard`).
* **Custom UI & Styling:**
    * Utilizes modern SwiftUI features like gradients (`LinearGradient`), custom button styles (`modernButtonStyle`, `FancyGreenButtonStyle`), tab views (`TabView`), and animations.
* **Data Persistence:** Uses `@AppStorage` and `UserDefaults` extensively to save user preferences (`hasSeenIntro`, `userName`, `selectedGoal`, `userWeight`) and nutritional history (`nutritionHistoryData`).

## Technology Stack

* **UI Framework:** SwiftUI
* **Camera Interaction:** AVFoundation (via UIKit bridge)
* **Text Recognition:** Vision Framework
* **Data Persistence:** `@AppStorage`, `UserDefaults`, `Codable` (for history)
* **Language:** Swift
* **Project Format:** Swift Playgrounds App (`.swiftpm`)
* **Platform:** iOS

## Screenshots

*(Add screenshots or a GIF of the app in action here!)*
* *Onboarding Screens*
* *Dashboard View (Home Tab)*
* *Camera Scanning View*
* *Profile Tab*
* *History Tab*

## Project Structure

The project is organized within a Swift Playgrounds App package (`.swiftpm`).

NORA/
├── README.md                 <-- This file
└── testwwdc.swiftpm/
├── ContentView.swift     <-- Main view logic, TabView setup, Onboarding flow, Tab Views (TabOneView, TabTwoView, TabThreeView), Helper Views (e.g., MacroTrackerView, AnimatedHealthScore, ProfileInfoCard, etc.), Data Extraction logic, Health Score calculation.
├── MyApp.swift           <-- App entry point (@main struct)
├── Assets.xcassets/      <-- Contains app icons (like icon.png) and other image assets.
└── Package.swift         <-- Swift Package Manager manifest (may be minimal for a .swiftpm project unless external packages are added).

## Getting Started

1.  **Clone the Repository:**
    ```bash
    git clone <your-github-repo-url>
    ```
2.  **Open the Project:** Navigate to the `NORA` directory and open the `testwwdc.swiftpm` file using Xcode (a recent version that supports Swift Playgrounds App projects is recommended).
3.  **Run the App:**
    * Select an iOS Simulator or connect a physical iOS device.
    * **Note:** Camera functionality (`ImageScannerView`) requires a physical device.
    * Build and run the project (Cmd+R).

## How to Use

1.  **Onboarding:** Launch the app for the first time and follow the introductory screens. Enter your name, select a health goal (Weight Loss, Muscle Gain, General Health), and adjust the slider to set your current weight (in kg).
2.  **Scan Nutrition Label:** Navigate to the "Home" tab. Tap the "Take Photo of Nutrition Label" button. Grant camera permissions if prompted. Point the camera steadily at a nutrition label.
3.  **Confirm Data:** The app uses live text recognition. Once it detects data, an alert will show the extracted values (Protein, Carbs, Fat, etc.). Review the data and tap "Yes" to add it to your daily log or "No" to cancel/rescan.
4.  **Track Progress:** On the "Home" tab, observe your Health Score and how close you are to your daily macro targets.
5.  **View Profile:** Go to the "Profile" tab to see your stored name, goal, and weight. You can reset the app data here.
6.  **Check History:** Visit the "History" tab to see a log of all the nutritional entries you've confirmed.

## Future Enhancements (Ideas)

* Manual entry option for foods without labels.
* Barcode scanning with integration to a food database (like Open Food Facts).
* More detailed charts and graphs for historical data analysis.
* Cloud synchronization (e.g., iCloud) for data backup and multi-device use.
* Integration with Apple HealthKit.
* Recipe analysis feature.
