# Task Management App

A Flutter application for managing tasks, built with Flutter Bloc and Sqflite for state management and local storage.

## ✨ Features

- **Add Tasks**: Create new tasks with a title and description.
- **Update Tasks**: Modify existing task details.
- **Delete Tasks**: Remove tasks from the list.
- **Toggle Task Completion**: Mark tasks as complete or incomplete.
- **Search Tasks**: Filter tasks by title or description.
- **Persistent Storage**: Tasks are saved locally using Sqflite.

## 🚀 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/task_management_app.git
   cd task_management_app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   dart run build_runner build
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## 🛠️ Usage

### Adding a Task

1. Tap the Add button (➕).
2. Enter the task title and description.
3. Tap Save.

### Updating a Task

1. Tap on a task to open its details.
2. Edit the title or description.
3. Tap Save.

### Deleting a Task

1. Tap on a task to open its details.
2. Tap Delete (❌).

### Toggling Task Completion

1. Tap the check button (✅) next to the task.

### Searching Tasks

1. Enter a keyword in the search bar to filter tasks.
