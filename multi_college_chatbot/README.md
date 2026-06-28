# Multi College Enquiry Chatbot System

Full-stack mini project for **Sri Shanmugha Institutions** using:
- Frontend: HTML, CSS, JavaScript, Bootstrap (glassmorphism + animations)
- Backend: Python Flask
- Database: MySQL

## 1) Create Database + Tables
1. Open MySQL Workbench / phpMyAdmin.
2. Run the file: `database.sql`

It will create the database: `multi_college_chatbot` and insert sample data.

## 2) Configure MySQL Credentials
Open `config.py` and update:
- `MYSQL_HOST`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `MYSQL_DB`

## 3) Install Python Dependencies
```bash
pip install -r requirements.txt
```

## 4) Run the Flask App
```bash
python app.py
```
Then open:
http://127.0.0.1:5000

## 5) Sample Logins
### Existing Student (from `student_login` table)
- `student.eng@ssi.edu` / `student123`
- `student.pharm@ssi.edu` / `student123`
- `student.nurs@ssi.edu` / `student123`
- `student.ahs@ssi.edu` / `student123`

### New Student (from `users` table)
- `demo@gmail.com` / `demo123`
Or use the **Register** option on the login page.

### Visitor / Parent
- Enter any name + solve captcha.

## 6) Hostel Image Feature
In chat, try:
- `hostel image`
- `show hostel room`
- `boys hostel room`
- `girls hostel room`

Images are stored in `static/images/hostel/`.
Currently the project uses **SVG placeholders**. You can replace them with real `.jpg/.png` photos and update `hostel_images` table.

## 7) Facility Images Feature (Labs / Classroom / Library / Infrastructure / Placements / Campus)
In chat, try:
- `show lab images`
- `classroom image`
- `library photo`
- `infrastructure images`
- `placement images`
- `campus facilities image`

Images are stored in:
- `static/images/facilities/`

The mapping is stored in MySQL table:
- `facility_images`

You can replace SVG placeholders with real images (`.jpg/.png`) and keep the same filenames (or update DB rows).

## Notes
- This is a beginner-friendly demo project.
- Passwords accept both **plain text** (demo inserts) and **hashed** values (created via the Register page).
