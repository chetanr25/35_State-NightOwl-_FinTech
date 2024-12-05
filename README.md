# 🚀 Invest-Bridge

A dynamic platform that bridges the gap between Small and Medium Enterprises (SMEs) and Investors, offering seamless funding opportunities and investment tracking. SMEs get the exposure they need to scale their businesses, while investors gain access to a wide range of lucrative investment opportunities.

---

## 📑 Table of Contents
1. [Introduction](#-introduction)
2. [Project Overview](#-project-overview)
3. [Key Features](#-key-features)
4. [Use Cases](#-use-cases)
5. [Screenshots](#-screenshots)
6. [Getting Started](#-getting-started)
7. [Tech Stack](#-tech-stack)
8. [License](#-license)

---

## 🌟 Introduction
SME-Investor Connect is a cutting-edge platform designed to revolutionize how SMEs and investors collaborate. SMEs seeking funding can present their projects to potential investors, while investors can diversify their portfolios by exploring various industries and areas of interest.

Our platform provides a **secure, user-friendly, and efficient** environment for both SMEs and investors. Powered by Firebase for secure authentication and Flutter for a beautiful, responsive interface, this project ensures a seamless experience for all users.

---

## 📋 Project Overview

- **SMEs register**, create funding campaigns, and manage investments via their personalized **SME Dashboard**.
- **Investors** explore funding opportunities, monitor investments, and track progress through their **Investor Portfolio**.
- Authentication powered by **Firebase Auth** ensures secure login.
- Over **30+ industry categories** enable precise matching between SMEs and investors.

---

## 🚀 Key Features

#### 🔐 Secure Authentication
- Email and password login using **Firebase Authentication**.
  
#### 🏢 Registration for SMEs and Investors
- **Full Name** and **Phone Number** required.
- Role selection: **SME** or **Investor**.
- Industry and interest area from **30+ categories** for enhanced connections.

#### 📊 SME Dashboard
- Create investment campaigns and monitor funding.
- View, Approve or reject investor proposals.
- **AI-Powered Decision Support**: Leverages AI to assist SMEs in making informed decisions on approving or rejecting investor proposals, ensuring smarter and more strategic funding choices.
- Real-time funding status updates.

#### 💼 Investor Portfolio
- Track all investments in one place.
- See pending or approved investment statuses.
- Stay informed with a detailed portfolio overview.

#### 🖥️ User Profiles
- Edit profile anytime.
- Display comprehensive user details.

---

## 💡 Use Cases

1. **For SMEs**:
   - Quickly raise funds from investors.
   - Manage investments in real-time.
   - Build credibility in the investor community.

2. **For Investors**:
   - Discover a wide range of funding opportunities.
   - Monitor the status of all investments seamlessly.
   - Diversify portfolios across multiple industries.

---
## 📸 Screenshots
#### (Adding screenshots soon)
---

## 🛠 Getting Started

<details>
<summary>Click to expand setup instructions</summary>

### Prerequisites
Ensure you have the following installed:
- **Flutter**: [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Firebase CLI**: [Set up Firebase](https://firebase.google.com/docs/cli)
- **Git**: [Download Git](https://git-scm.com/downloads)

### Setup Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/chetanr25/invest-bridge.git
   cd invest-bridge
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Setup Firebase**:
   - Follow [Firebase Setup Guide](https://firebase.google.com/docs/flutter/setup) to connect your project to Firebase.

4. **API Key Configuration**:
   - Obtain your **Gemini API Key** and create a `.env` file.
   - Use `.env.example` as a template:
     ```bash
     cp .env.example .env
     ```
   - Add your API key to the `.env` file:
     ```env
     GEMINI_API_KEY=your_api_key_here
     ```

5. **Run the App**:
   ```bash
   flutter run
   ```

</details>

---

## 🛠 Tech Stack
- **Flutter**: Frontend framework for a responsive, cross-platform UI.
- **Firebase Authentication**: Secure and scalable authentication solution.
- **Firebase Firestore**: Highly scalable No-SQL data storage solution.
- **Dart**: High-performance backend logic with Flutter.

---

## 📜 License
This project is licensed under the [LICENSE](LICENSE)

