# Contributing to Run Revenue

Thank you for considering contributing to Run Revenue! Your contributions are valuable and help improve the product.

## Table of Contents

- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
  - [Bug Reports](#bug-reports)
  - [Feature Requests](#feature-requests)
- [Code Contributions](#code-contributions)
- [Pull Request Process](#pull-request-process)
- [Contact](#contact)

## Getting Started

1.	Fork the Repository: Click the “Fork” button at the top right of the repository page.
  ```
https://github.com/chetanr25/run-revenue.git

  ```
2.	Clone Your Fork:
   Replace `your-username` with Your username
  	
  ```bash
  git clone https://github.com/<your-username>/run-revenue.git
  cd run-revenue
  ```

3. **Install Dependencies**:

  ```bash
  flutter pub get
  ```


4. Setup Firebase**
      
    <details>
    <summary>⬇️ Click to expand and see the complete Firebase setup instructions.</summary>
      <br/>
    To integrate Firebase with your Flutter project, follow these steps:
    
    1.  **Create a Firebase Project and Add Your App**
    
        - Visit the  [Firebase Console](https://console.firebase.google.com/)  and create a new Firebase project.
        - Once your project is created, go to the  **Project Settings**  and click on  **Add App**.
        - Download the  google-services.json  (for Android) or  GoogleService-Info.plist  (for iOS) and add it to the appropriate directory in your Flutter project.
    
    2.  **Integrate Firebase Firestore**
    Enable Firebase Firestore by navigating to the  **Build**  tab in the Firebase Console and activating Firestore. For more info follow the Firebase documentation to set up Firestore:
    [Firestore Setup Guide](https://firebase.google.com/docs/firestore/quickstart) and 
    [Firestore Flutter Documentation](https://firebase.flutter.dev/docs/firestore/overview)
    
      
    
    3.  **Integrate Firebase Authentication**
    Enable Firebase Authentication by navigating to the  **Build**  tab in the Firebase Console, then select  **Authentication**. Choose  **Email/Password**  as your sign-in method. For more info visit [Authentication Setup Guide](https://firebase.google.com/docs/auth/flutter/start) and  [Authentication Flutter Documentation](https://firebase.flutter.dev/docs/auth/overview)
    
      
    
    4.  **Firebase Documentation**
    
    - For complete details on Firebase setup, Firestore, and Authentication, refer to the following links:
      - [Firebase Setup for Flutter](https://firebase.flutter.dev/docs/overview)
      - [Firestore Documentation](https://firebase.google.com/docs/firestore)
      - [Firebase Authentication Documentation](https://firebase.google.com/docs/auth)
    
  </details>


5. **API Key Configuration**:

   - Obtain your **Gemini API Key** and create a `.env` file.
   - Use `.env.example` as a template:
       ```bash
       cp .env.example .env
       ```
   - Add your API key to the `.env` file:
       ```env
       GEMINI_API_KEY=your_api_key_here
       ```

6. **Run the App**:
   ```bash
   flutter run
   ```
---

## How to Contribute

#### Bug Reports

If you encounter a bug, please report it by creating an issue. Include detailed information to help us understand and reproduce the issue:
- Steps to reproduce the bug.
- Expected behavior.
- Actual behavior.
-	Screenshots or logs, if applicable.

#### Feature Requests

We welcome new feature ideas! To request a feature, open an issue and provide:
- A clear and descriptive title.
- The motivation for the feature.
-	Detailed description of the proposed solution.
-	Any alternatives considered.

## Code Contributions

We appreciate code contributions! To contribute:
	
  1.	Create a Branch:
     
  ```
  git checkout -b feature/your-feature-name
  ```
2.	Make Changes: Implement your changes following the Development Guidelines.
3.	Commit Changes:
   
  ```
  git add .
  git commit -m "Add feature: your feature name"
  ```

4.	Push to Your Fork:
   
  ```
  git push origin feature/your-feature-name
  ```

## Pull Request Process

1.	Add the Original Repository as a Remote (Upstream)
If you haven’t already added the original repository as a remote, run:

  ```
  git remote add upstream https://github.com/chetanr25/run-revenue.git
  ```

2.	Fetch the Latest Changes from Upstream
   
  ```
  git fetch upstream
  ```  

3.	Merge the Latest Changes from Upstream/Main into Your Feature Branch
  ```
  git checkout feature/your-feature-name
  git merge upstream/main
  ```

4.	Create a Pull Request
After merging the latest changes, go to the original repository and open a Pull Request (PR). Provide a clear and descriptive title and a detailed explanation of your changes.

Development Guidelines
- Code Style: Follow the Dart Style Guide and Flutter conventions to maintain consistency.
- Documentation: Update code comments and the README.md file as needed to reflect your changes.

## Contact

For questions or further assistance, feel free to reach out by opening an issue or contacting the maintainers directly.
<a href="https://linktr.ee/chetanr25">
  <img src="https://github.com/user-attachments/assets/59432b27-bddb-4d8a-a2a2-903bc78168c2" height="35" alt="Linktree" />
</a>
&nbsp;&nbsp;&nbsp;
<a href="https://www.linkedin.com/in/chetanr25">
  <img src="https://img.shields.io/static/v1?message=LinkedIn&logo=linkedin&label=&color=0077B5&logoColor=white&labelColor=&style=for-the-badge" height="35" alt="LinkedIn" />
</a>
&nbsp;&nbsp;&nbsp;
<a href="mailto:chetan250204@gmail.com">
  <img src="https://img.shields.io/static/v1?message=Gmail&logo=gmail&label=&color=D14836&logoColor=white&labelColor=&style=for-the-badge" height="35" alt="Gmail" />
</a>

We appreciate your contributions and look forward to collaborating with you!
