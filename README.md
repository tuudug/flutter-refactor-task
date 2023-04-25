# Flutter Refactoring Task

This is a simple Flutter application that fetches data from a REST API, manages the state using the Provider package, and stores the data in a local SQLite database using the sqflite package. The application uses Streams, null-aware operators, and complex widgets.

The main objective of this project is to refactor the existing code, improve code readability, maintainability, and performance. Additionally, the app should support dark mode and include a button to toggle between list and grid view. The refactoring process should include using GetX for state management and navigation, as well as Hive for local data storage.

## Requirements

1. Refactor the code by applying best practices such as using state management, following SOLID principles, and adhering to the DRY (Don't Repeat Yourself) principle.
2. Replace the current state management solution (Provider) with GetX. Utilize GetX for both state management and navigation.
3. Replace the current local data storage solution (sqflite) with Hive for better performance and easier usage.
4. Optimize the performance of the application by using appropriate widgets and techniques.
5. Ensure that the code is maintainable and readable by adding comments and documentation.
6. Write unit and widget tests to validate the functionality and performance of the application.
7. Add support for dark mode. The app should automatically switch between light and dark mode based on the system settings or user preference.
8. Implement a button to toggle between list and grid view. The fetched data should be displayed in either a list or a grid, based on the user's selection.

## Deliverables

1. The refactored Flutter application code, including all necessary files and dependencies.
2. A brief document explaining the changes made, the reasons for those changes, and the benefits of the refactoring.
3. Unit and widget tests validating the functionality and performance of the application.

## Evaluation Criteria

1. The candidate demonstrates a clear understanding of Flutter best practices, GetX, and Hive.
2. The refactored code is more maintainable, readable, and efficient than the original code.
3. The performance of the application is optimized using appropriate widgets and techniques.
4. The candidate provides clear explanations for their changes and the benefits of the refactoring.
5. The tests are well-written and validate the application's functionality and performance.
6. The app correctly supports dark mode and allows users to toggle between list and grid view.

## Getting Started

1. Clone the repository.
2. Navigate to the project directory and run `flutter pub get` to fetch the dependencies.
3. Open the project in your preferred IDE and run the application on an emulator or a physical device.

Note: Make sure you have Flutter and Dart SDK installed, and your IDE is set up for Flutter development. For more information, refer to the official Flutter documentation: https://flutter.dev/docs/get-started/install
