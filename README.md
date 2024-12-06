# 🚀 Run Revenue

A dynamic platform that bridges the gap between Small and Medium Enterprises (SMEs) and Investors, offering seamless funding opportunities and investment tracking. SMEs get the exposure they need to scale their businesses, while investors gain access to a wide range of lucrative investment opportunities.

---

### Download APK

<a href="https://github.com/chetanr25/run-revenue/raw/refs/heads/main/apk_file/app-release.apk">
<img src="https://camo.githubusercontent.com/2b0b605d77141fd0ff5f5aa8159f6121c4d4bd213d5ee2aba1753d678faaf28c/68747470733a2f2f692e6962622e636f2f71306d6463345a2f6765742d69742d6f6e2d6769746875622e706e67" width=350/>
</a>

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

<table align="center">
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/6ef34445-c3ab-4e45-aa36-bfed22c773e9" width="220"/><br/>Login Page</td>
    <td align="center"><img src="https://github.com/user-attachments/assets/2983140f-26bb-44d7-8c22-ea4731b2b254" width="220"/><br/>Registration (SME/Investor)</td>
    <td align="center"><img src="https://github.com/user-attachments/assets/7563506a-5aa3-4461-83a1-4fdfe0b0a973" width="220"/><br/>Registration Page</td>
  </tr>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/279c8612-4245-4d8e-9a44-01cb617041d1" width="220"/><br/>Profile<br/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/737fa760-c0ee-4b94-972f-a7bbe907ffd5" width="220"/><br/>Edit Profile<br/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/aca83a30-6b5e-4168-8f5a-11be1b266e16" width="220"/><br/>Select Area of interest page<br/></td>
  </tr>
  
   <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/9a829902-89f7-462a-a759-7350487368da" width="220"/><br/>SME Listings for Investors<br/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/bec5c475-8836-4572-a66c-06599ccedd11" width="220"/><br/>Amount investor invests<br/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/eb3b7d9e-2a53-4665-b062-d1cb644ae8f2"  width="220"/><br/>Investors portfolio/Dashboard<br/></td>
  </tr>

<tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/dd722979-5a74-4c02-9597-1626ffa6e892" width="220"/><br/>SME initial dashboard<br/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/cbf7d8cc-3c83-4f0b-a8e9-16d0644506d0" width="220"/><br/>SME Dashboard<br/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/20691fa2-cdae-46fe-ada3-8ddc4ff88a85" width="220"/><br/>AI based recommendation for SME<br/></td>
  </tr>
</table>

## Demo Video
<p align="center" width="300">

https://github.com/user-attachments/assets/9a16fd8e-67e1-4940-8cb1-e0d8405d87f4
   
</p>

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
   git clone https://github.com/chetanr25/run-revenue.git
   cd run-revenue
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

This project is licensed under the [MIT LICENSE](LICENSE)
