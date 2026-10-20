# 🎓 School Management System

**A bilingual School Management System for Unit 1 and Unit 2, with English and Gujarati language support.**

The project aims to provide a centralized website and mobile application for managing school operations, students, teachers, parents, and administrators.

## 📌 Project Overview

This system is designed for two school campuses:

- **Unit 1 – Hostel Campus:** Approximately 2,000 students
- **Unit 2 – City Campus:** Approximately 1,000 students
- **Total:** Approximately 3,000 students

Users will select their preferred language when opening the website or mobile application.

## ✨ Planned Features

- English and Gujarati language selection at startup
- Student, parent, teacher, and admin login
- Separate campus management
- Student and teacher records
- Attendance management
- Fees and payment records
- Timetable and homework
- Exams and results
- Hostel management for Unit 1
- Notifications and announcements
- Reports and analytics
- Role-based access control
- Responsive website and mobile application

## 🛠️ Technology Stack

| Component | Technology |
|---|---|
| Website Frontend | Next.js |
| Frontend Language | TypeScript |
| UI Styling | Tailwind CSS |
| Mobile App | Flutter |
| Backend Language | Python |
| Backend Framework | Django REST Framework |
| Database | PostgreSQL |
| Cache | Redis |
| Cloud Hosting | AWS |
| Version Control | Git and GitHub |

## 🏗️ Project Architecture

```text
School-Project/
│
├── frontend/             # Next.js website
├── backend/              # Django REST API
├── mobile/               # Flutter mobile application
├── docs/                 # Project documentation
├── .gitignore
└── README.md
```

*This is the proposed structure. Create these folders as you implement each component.*

# 🚀 Project Setup Guide

## 1. Prerequisites

Install the following tools on your computer:

- [Git](https://git-scm.com/downloads)
- [Python](https://www.python.org/downloads/)
- [Node.js LTS](https://nodejs.org/)
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [PostgreSQL](https://www.postgresql.org/download/)
- [Visual Studio Code](https://code.visualstudio.com/)

For Windows, ensure Python and Git are added to PATH during installation.

Verify the installations in Command Prompt or PowerShell:

```powershell
git --version
py --version
node --version
npm --version
flutter --version
psql --version
```

Some commands may not work until the relevant tool is installed and configured.

## 2. Clone the Repository

Open Command Prompt or the VS Code terminal:

```powershell
git clone https://github.com/maulikcmr05/School-Project.git
cd School-Project
```

If the repository is private, sign in to GitHub when prompted.

## 3. Set Up the Backend

Create the backend folder and a Python virtual environment:

```powershell
mkdir backend
cd backend

py -m venv .venv
```

Activate the environment on Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

If PowerShell blocks activation, use Command Prompt instead:

```cmd
.venv\Scripts\activate.bat
```

Install the backend packages:

```powershell
python -m pip install --upgrade pip
python -m pip install django djangorestframework django-cors-headers "psycopg[binary]" python-dotenv
```

Create the Django project:

```powershell
django-admin startproject config .
```

Run the initial migrations:

```powershell
python manage.py migrate
```

Create an administrator account:

```powershell
python manage.py createsuperuser
```

Start the development server:

```powershell
python manage.py runserver
```

Open the following URLs:

- API/backend root: http://127.0.0.1:8000/
- Django admin: http://127.0.0.1:8000/admin/

*The API endpoints, campus modules, and authentication must be implemented before their functionality is available.*

## 4. Set Up the Website Frontend

Open a second terminal in the repository root:

```powershell
cd frontend
```

Create the Next.js application if it has not been created yet:

```powershell
npx create-next-app@latest . --typescript --tailwind --eslint --app
```

Install the internationalization library:

```powershell
npm install next-intl
```

Start the website:

```powershell
npm run dev
```

Open:

http://localhost:3000

The English/Gujarati selection screen and translated pages must be implemented in the frontend.

## 5. Set Up the Mobile Application

From the repository root:

```powershell
flutter create mobile
cd mobile
flutter pub get
flutter run
```

To support English and Gujarati localization, configure Flutter's localization packages and translation files.

For Android development, install Android Studio and configure an emulator or connect a physical Android device.

## 6. Configure PostgreSQL

Create a PostgreSQL database for local development:

```sql
CREATE DATABASE school_management;
```

Create a dedicated database user and grant appropriate permissions instead of using the PostgreSQL superuser for the application.

Configure Django's database settings to use PostgreSQL and read credentials from environment variables.

**Important:** The commands above create the database only. The Django project must be configured to connect to PostgreSQL before the application uses it.

## 7. Environment Variables

Create a local `.env` file in the backend directory. Do not commit this file to GitHub.

Example:

```env
DJANGO_SECRET_KEY=replace-with-a-secure-secret
DJANGO_DEBUG=True
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1

DB_NAME=school_management
DB_USER=school_app
DB_PASSWORD=replace-with-your-local-password
DB_HOST=localhost
DB_PORT=5432
```

Update Django settings to read these variables. Use a strong secret key and `DEBUG=False` in production.

Never publish passwords, secret keys, API tokens, or real student information.

## 8. Run the Complete Project

Start each component in its own terminal.

**Terminal 1 — Backend**

```powershell
cd backend
.\.venv\Scripts\Activate.ps1
python manage.py runserver
```

**Terminal 2 — Website**

```powershell
cd frontend
npm run dev
```

**Terminal 3 — Mobile App**

```powershell
cd mobile
flutter run
```

Ensure PostgreSQL is running and the backend database settings are configured before starting the application.

## 🌐 Language Support

The application is planned to support:

- English
- ગુજરાતી (Gujarati)

The language selection screen will appear at startup. The chosen language should remain selected as the user navigates through the application.

## 🔐 Security and Reliability

Before production deployment:

- Implement role-based access control.
- Enforce Unit 1 and Unit 2 data permissions on the backend.
- Use HTTPS.
- Configure automated database backups and test recovery.
- Use secure environment variables.
- Perform load and failover testing.
- Monitor application errors and server performance.

High availability reduces downtime but cannot guarantee that the system will never go offline.

## 🚀 Deployment

Production deployment can use AWS services for application hosting, load balancing, database availability, file storage, monitoring, and backups.

Complete the local development, security review, and load testing before publishing the production application.

## 📋 Development Roadmap

- [ ] Requirements and UI design
- [ ] English/Gujarati selection screen
- [ ] Website frontend
- [ ] Django backend API
- [ ] PostgreSQL configuration
- [ ] Authentication and permissions
- [ ] Unit 1 and Unit 2 management
- [ ] Student and teacher modules
- [ ] Attendance and timetable
- [ ] Fees and examinations
- [ ] Parent and student dashboards
- [ ] Flutter mobile app
- [ ] Notifications and reports
- [ ] Security and load testing
- [ ] Production deployment

## 👨‍💻 Author

**Maulik Chothani**

GitHub: [@maulikcmr05](https://github.com/maulikcmr05)

## 📌 Project Status

**In Development**

Features and setup instructions may change as development progresses.
