# Fit Mirror: Your Virtual Closet & Personal Stylist

### **"Try It. Love It. Own It."**

Shopping for clothes online is exciting, but let’s be real—guessing if a shirt will fit or if a color will look good on you is a headache. We built **Fit Mirror** to fix that. 

Fit Mirror is an AI-powered fashion assistant that lets you visualize clothes on *yourself* before you hit "Buy." By combining realistic image diffusion models with the intelligence of Google Gemini, we’ve created a space where you can manage your wardrobe, get styling advice, and shop with total confidence.

---

## Why Fit Mirror?

- **Virtual Try-On:** No more guessing games. Upload your photo and see how a garment looks on your body using our AI-driven diffusion engine.
- **AI Fashion Bestie:** Stuck on what to wear for a wedding? Our chatbot (powered by Google Gemini 1.5) provides personalized styling tips, color combos, and outfit ideas.
- **Digital Wardrobe:** Save your favorite pieces and organize custom collections. It’s like having your closet in your pocket, synced across all your devices.
- **Smart Shopping:** Explore a unified catalog with smart filters for brand, category, and gender, making it easy to find exactly what you're looking for.
- **Secure & Seamless:** Log in quickly using Google Sign-In or your email. Your data is handled securely via Firebase.
- **Admin Management:** A dedicated portal for uploading new garments, managing catalog inventory, and overseeing user activity.

---

## The Tech Stack

We chose a modern, scalable architecture to ensure Fit Mirror is fast, reliable, and beautiful.

- **Frontend:** Built with **Flutter (3.6.0+)** for a high-performance experience on Android. We use the **BLoC pattern** for clean state management.
- **Backend:** **Firebase** handles the heavy lifting—Authentication for users, Firestore for real-time data, and Cloud Storage for high-res images.
- **AI Integration:** **Google Gemini API** powers our stylist, while specialized Diffusion APIs handle the complex image synthesis for virtual try-ons.

### Key Tools & Libraries

| Tool | Purpose |
| :--- | :--- |
| **Flutter SDK** | Android app foundation. |
| **flutter_bloc** | Predictable and organized state management. |
| **Google Gemini** | The brain behind the personal styling assistant. |
| **Firebase** | Real-time database, Storage, and Secure Auth. |
| **Image Picker** | Seamless photo capture and gallery selection. |
| **flutter_dotenv** | Keeps our API keys safe and secure. |

---

## System Requirements

- **Android:** 8.1 (Oreo) or higher.
- **RAM:** Minimum 4 GB recommended for AI processing.
- **Connection:** Active internet (4G/5G/Wi-Fi) is required for AI and cloud syncing.

---

## Getting Started

Want to run Fit Mirror on your local machine? Just follow these steps:

### 1. Clone the repository
```bash
git clone https://github.com/arfatabid/Fit-Mirror-FYP.git
cd Fit-Mirror-FYP
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Setup Environment Variables
Create a `.env` file in the root directory and add your keys:
```env
GEMINI_API_KEY=your_gemini_api_key_here
DIFFUSION_API_KEY=your_diffusion_api_key_here
```
*Note: Make sure to place your `google-services.json` inside the `android/app/` folder.*

### 4. Run the app
Connect your device and launch:
```bash
flutter run
```

---

## Database Structure (Firestore)

- **Users:** Profiles, preferences, and metadata.
- **Products:** Garment details (Brand, Category, Gender Tags).
- **Wardrobe:** Your personal curated collections.
- **TryOnLogs:** History of your AI-generated try-on looks.
- **AssistantChats:** Real-time synced conversational memory.

---

## The Team

This project was developed as a Final Year Design Project (FYDP) for the BSIT (Session 2022–2026) at **Govt. Graduate College for Women, Wahdat Colony** (Affiliated with University of the Punjab, Lahore).

- **Syeda Fatima Rehman** (Roll No: 085359)
- **Arfat Abid** (Roll No: 085358)
- **Sheeza Shafique** (Roll No: 085318)

**Project Supervisor:** Ms. Umaira Nazar Hussain
