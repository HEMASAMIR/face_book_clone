# FaceBook Clone - Flutter Project

Welcome to **FaceBook Clone**, a modern and fully-featured social media mobile application built with **Flutter**, using **BLoC/Cubit** state management and **Clean Architecture** principles.  

This project implements a scalable architecture and best practices for building production-ready apps.

---
## 🚀 Project sturucure : 
![Uploading ChatGPT Image Dec 12, 2025, 07_26_41 AM.png…]()

## 🚀 Features

### Authentication
- User registration and login using **Firebase Authentication**.
- Form validation and error handling.
- Clean and responsive UI with animations.

### Social Features
- **Stories**: Upload, view, and remove stories.
- **Posts**: Create, like, comment, and delete posts.
- **Follow/Following System**: Follow other users and see their posts.
- **Favorites**: Mark posts as favorite.
- **Search**: Search users and posts.

### Profile Management
- View and update user profile.
- Change profile picture.
- View followers and following lists.

### Animations & UX
- **Shimmer Loading** for better UX while fetching data.
- Smooth transitions and animations across screens.

---

## 🏗 Architecture

This project is built with **Clean Architecture + MVVM + Design Patterns**, organized into layers:

- **Data Layer**
  - `Repository` interfaces and implementations.
  - Remote data sources (Firebase Firestore, Cloudinary for image uploads).
  - Local data sources if needed.

- **Domain Layer**
  - Core models like `UserModel`, `PostModel`, `StoryModel`.
  - Use cases and entities.

- **Presentation Layer**
  - **BLoC/Cubit** for state management.
  - Flutter UI screens:
    - Login & Registration
    - Home Layout
    - Profile
    - Stories UI
    - Search
    - Favourites
    - Comments & Likes
  - Animations & Shimmer effects.

---

## 📂 Project Structure


---

## 🔹 Repository Pattern

We use **Repository Pattern** to separate **data handling** from **UI**:

- `StoriesRepository` → Interface for story operations.
- `StoriesRepositoryImpl` → Firestore + Cloudinary implementation.
- Similarly, `HomeRepository`, `AuthRepository`, etc.

**Advantages:**
- Clear separation of concerns.
- Easy testing and mocking.
- Scalable for adding new features.

---

## 📌 Packages & Tools

- **Flutter SDK**
- **Firebase**: Auth, Firestore, Storage
- **Dartz**: Functional error handling (`Either`)
- **Cloudinary**: Image uploads
- **Bloc/Cubit**: State management
- **Shimmer**: Loading animations
- **ImagePicker**: Select images from gallery
- **Flutter SVG**: SVG assets support

---

## 🎨 UI & UX

- Modern, responsive design.
- Smooth animations for story viewing, loading, and transitions.
- Shimmer effect for loading placeholders.
- Floating buttons and icons consistent with social media apps.

---

## 💡 Notes

- All data is persisted in **Firebase Firestore**.
- Images uploaded via **Cloudinary**.
- Real-time updates are implemented with Firestore streams.
- The app follows **MVVM + Clean Architecture** for maintainability.

---

## 📌 How to Run

1. Clone the repo:
   ```bash
   git clone <your_repo_url>








![WhatsApp Image 2025-12-12 at 7 13 08 AM (4)](https://github.com/user-attachments/assets/5bed1999-8857-473f-ba7f-b6edc51ffe7d)
![WhatsApp Image 2025-12-12 at 7 13 08 AM (3)](https://github.com/user-attachments/assets/07bc9ef5-7ee8-47c5-ad63-6a0a39586fac)
![WhatsApp Image 2025-12-12 at 7 13 08 AM (2)](https://github.com/user-attachments/assets/10457428-3454-4d3b-995d-05dbde20d2c7)
![WhatsApp Image 2025-12-12 at 7 13 08 AM (1)](https://github.com/user-attachments/assets/9559fdfd-d604-484a-b289-64063a1b5d6f)
![WhatsApp Image 2025-12-12 at 7 13 07 AM](https://github.com/user-attachments/assets/8d60ebd0-792a-43d7-8499-ed27b3b2d5ef)
![WhatsApp Image 2025-12-12 at 7 13 07 AM (1)](https://github.com/user-attachments/assets/8ebbf290-b215-4594-adf5-45a9d75b2f26)
![WhatsApp Image 2025-12-12 at 7 13 09 AM](https://github.com/user-attachments/assets/64db9791-400c-4f87-9aee-dc6ee7e27028)
![WhatsApp Image 2025-12-12 at 7 13 09 AM (4)](https://github.com/user-attachments/assets/0aed2b52-ee0b-49f2-83a3-5ad0ec7cb127)
![WhatsApp Image 2025-12-12 at 7 13 09 AM (3)](https://github.com/user-attachments/assets/3a198acd-ecc4-427e-a50e-f46148b90d4d)
![WhatsApp Image 2025-12-12 at 7 13 09 AM (2)](https://github.com/user-attachments/assets/7f9fd818-55df-4e60-a38b-1ca491885ba4)
![WhatsApp Image 2025-12-12 at 7 13 09 AM (1)](https://github.com/user-attachments/assets/06cc69e4-6aa0-4844-ba85-46453bcf7afb)
![WhatsApp Image 2025-12-12 at 7 13 08 AM](https://github.com/user-attachments/assets/9d99abdf-39e9-45fe-80ed-a88aa229bc00)
