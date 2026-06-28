-- database.sql
-- ------------
-- MySQL schema + sample data for the mini project.
-- Run this file in MySQL Workbench / phpMyAdmin / command line.

CREATE DATABASE IF NOT EXISTS multi_college_chatbot
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE multi_college_chatbot;

-- Drop tables (for re-run during development)
DROP TABLE IF EXISTS chat_history;
DROP TABLE IF EXISTS enquiries;
DROP TABLE IF EXISTS hostel_images;
DROP TABLE IF EXISTS facility_images;
DROP TABLE IF EXISTS chatbot_questions;
DROP TABLE IF EXISTS college_details;
DROP TABLE IF EXISTS student_login;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS colleges;

-- 1) Colleges master
CREATE TABLE colleges (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(10) NOT NULL UNIQUE,
  short_name VARCHAR(120) NOT NULL,
  name VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- 2) New student / visitor users
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_type ENUM('new_student','visitor') NOT NULL,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(190) NULL,
  password_hash VARCHAR(255) NULL,
  created_at DATETIME NOT NULL
) ENGINE=InnoDB;

-- 3) Existing students login
CREATE TABLE student_login (
  id INT AUTO_INCREMENT PRIMARY KEY,
  college_id INT NULL,
  student_name VARCHAR(120) NOT NULL,
  college_email VARCHAR(190) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (college_id) REFERENCES colleges(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 4) College details shown on dashboard
CREATE TABLE college_details (
  id INT AUTO_INCREMENT PRIMARY KEY,
  college_id INT NOT NULL UNIQUE,
  intro_text TEXT,
  infrastructure_text TEXT,
  placements_detail_text TEXT,
  hostel_text TEXT,
  courses_text TEXT,
  contact_text TEXT,
  -- Dashboard "metric" labels (optional)
  students_text VARCHAR(50),
  faculty_text VARCHAR(50),
  campus_text VARCHAR(50),
  placements_text VARCHAR(50),
  FOREIGN KEY (college_id) REFERENCES colleges(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5) Chatbot knowledge base (FAQ)
CREATE TABLE chatbot_questions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  college_id INT NOT NULL,
  category VARCHAR(60) NOT NULL,
  question VARCHAR(255) NOT NULL,
  answer TEXT NOT NULL,
  FOREIGN KEY (college_id) REFERENCES colleges(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6) Hostel images for the special feature
CREATE TABLE hostel_images (
  id INT AUTO_INCREMENT PRIMARY KEY,
  college_id INT NOT NULL,
  gender ENUM('boys','girls','common') NOT NULL DEFAULT 'common',
  image_filename VARCHAR(255) NOT NULL,
  title VARCHAR(120) NULL,
  FOREIGN KEY (college_id) REFERENCES colleges(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6B) Facility images (labs, classrooms, library, infrastructure, placements, campus)
CREATE TABLE facility_images (
  id INT AUTO_INCREMENT PRIMARY KEY,
  college_id INT NOT NULL,
  facility_type ENUM('labs','classrooms','library','infrastructure','placements','campus') NOT NULL,
  image_filename VARCHAR(255) NOT NULL,
  title VARCHAR(120) NULL,
  FOREIGN KEY (college_id) REFERENCES colleges(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 7) Enquiry form data
CREATE TABLE enquiries (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NULL,
  user_type VARCHAR(50) NULL,
  college_id INT NOT NULL,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(190) NULL,
  phone VARCHAR(40) NULL,
  message TEXT NOT NULL,
  created_at DATETIME NOT NULL,
  FOREIGN KEY (college_id) REFERENCES colleges(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 8) Chat history
CREATE TABLE chat_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  session_id VARCHAR(64) NOT NULL,
  user_id INT NULL,
  user_type VARCHAR(50) NULL,
  college_id INT NOT NULL,
  user_message TEXT NOT NULL,
  bot_reply TEXT NOT NULL,
  created_at DATETIME NOT NULL,
  FOREIGN KEY (college_id) REFERENCES colleges(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------
-- Sample Data (4 colleges + details + FAQ)
-- -------------------------------------------------------

INSERT INTO colleges (code, short_name, name) VALUES
('ENG',   'Engineering', 'Sri Shanmugha College of Engineering and Technology'),
('PHARM', 'Pharmacy',    'Sri Shanmugha College of Pharmacy'),
('NURS',  'Nursing',     'Sri Shanmugha College of Nursing'),
('AHS',   'Allied Health Science', 'Sri Shanmugha College of Allied Health Science');

-- College dashboard details (demo text)
INSERT INTO college_details
  (college_id, intro_text, infrastructure_text, placements_detail_text, hostel_text, courses_text, contact_text,
   students_text, faculty_text, campus_text, placements_text)
VALUES
(
  1,
  'Sri Shanmugha College of Engineering and Technology offers industry-focused engineering education with practical labs, innovation clubs, and strong mentoring.',
  'Infrastructure includes smart classrooms, high-speed Wi-Fi, CAD/CAE labs, IoT & embedded labs, computer centers, seminar halls, and a central library.',
  'Placement cell provides aptitude training, soft skills, coding practice, mock interviews, internships, and campus drive support.',
  'Separate hostel facilities with study area, security, dining, and transport support. Ask the chatbot: “show hostel room”.',
  'B.E. Computer Science and Engineering\nB.E. Electronics and Communication Engineering\nB.E. Mechanical Engineering\nB.Tech Information Technology',
  'Admissions Office: +91-00000-00000 • Email: admissions@ssi.edu.in • Timings: 9:00 AM – 5:00 PM',
  '2000+',
  'Experienced',
  'Smart Campus',
  'Strong'
),
(
  2,
  'Sri Shanmugha College of Pharmacy focuses on pharmaceutical sciences with strong lab training, research exposure, and patient-care orientation.',
  'Facilities include pharmaceutics lab, pharmacology lab, medicinal chemistry lab, pharmacognosy lab, and a well-stocked library.',
  'Career support includes hospital pharmacy exposure, industry visits, internships, and guidance for higher studies and jobs.',
  'Safe and hygienic hostel with study-friendly environment and dining. Ask: “hostel image”.',
  'B.Pharm\nD.Pharm\nM.Pharm (as per availability)',
  'Admissions Office: +91-00000-00000 • Email: pharmacy@ssi.edu.in • Timings: 9:00 AM – 5:00 PM',
  '800+',
  'Skilled',
  'Lab Focused',
  'Growing'
),
(
  3,
  'Sri Shanmugha College of Nursing trains compassionate healthcare professionals with clinical exposure, simulation labs, and community service.',
  'Facilities include nursing foundation lab, OBG lab, child health lab, nutrition lab, and simulation training.',
  'Placement guidance includes hospital tie-ups, interview training, and career counseling for domestic and overseas opportunities.',
  'Separate hostel facilities for girls with security and study areas. Ask: “girls hostel room”.',
  'B.Sc Nursing\nGNM (General Nursing and Midwifery)\nPost Basic B.Sc Nursing',
  'Admissions Office: +91-00000-00000 • Email: nursing@ssi.edu.in • Timings: 9:00 AM – 5:00 PM',
  '600+',
  'Qualified',
  'Clinical Labs',
  'Excellent'
),
(
  4,
  'Sri Shanmugha College of Allied Health Science offers career-ready programs in diagnostic and therapeutic health sciences with strong lab and hospital exposure.',
  'Facilities include diagnostic labs, physiology labs, anatomy models, and hands-on training with modern equipment.',
  'Career support includes internships, hospital exposure, skill training, and placement assistance.',
  'Hostel and transport facilities available. Ask: “boys hostel room” or “hostel image”.',
  'B.Sc Medical Laboratory Technology\nB.Sc Radiology and Imaging Technology\nB.Sc Operation Theatre and Anaesthesia Technology',
  'Admissions Office: +91-00000-00000 • Email: ahs@ssi.edu.in • Timings: 9:00 AM – 5:00 PM',
  '700+',
  'Dedicated',
  'Modern Labs',
  'Support'
);

-- Sample existing student logins (passwords are plain-text for demo: student123)
-- In real projects, store hashed passwords. This demo app accepts both hashed and plain passwords.
INSERT INTO student_login (college_id, student_name, college_email, password_hash, created_at) VALUES
(1, 'Arun Kumar',   'student.eng@ssi.edu',   'student123', NOW()),
(2, 'Priya Devi',   'student.pharm@ssi.edu', 'student123', NOW()),
(3, 'Meena Lakshmi','student.nurs@ssi.edu',  'student123', NOW()),
(4, 'Rahul Anand',  'student.ahs@ssi.edu',   'student123', NOW());

-- Sample new student (password is plain-text for demo: demo123)
INSERT INTO users (user_type, name, email, password_hash, created_at) VALUES
('new_student', 'Demo User', 'demo@gmail.com', 'demo123', NOW());

-- Hostel images (we provide SVG placeholders in static/images/hostel)
INSERT INTO hostel_images (college_id, gender, image_filename, title) VALUES
(1, 'boys',   'boys_room_1.svg',   'Boys Hostel Room'),
(1, 'girls',  'girls_room_1.svg',  'Girls Hostel Room'),
(1, 'common', 'common_room_1.svg', 'Common Area'),
(2, 'boys',   'boys_room_1.svg',   'Boys Hostel Room'),
(2, 'girls',  'girls_room_1.svg',  'Girls Hostel Room'),
(3, 'girls',  'girls_room_1.svg',  'Girls Hostel Room'),
(4, 'boys',   'boys_room_1.svg',   'Boys Hostel Room'),
(4, 'common', 'common_room_1.svg', 'Common Area');

-- Facility images (placeholders in static/images/facilities)
-- NOTE: You can replace SVGs with real .jpg/.png and keep the same filenames.
INSERT INTO facility_images (college_id, facility_type, image_filename, title) VALUES
-- Engineering (1)
(1,'labs','labs_1.svg','Engineering Lab'),
(1,'classrooms','classroom_1.svg','Smart Classroom'),
(1,'library','library_1.svg','Central Library'),
(1,'infrastructure','infrastructure_1.svg','Infrastructure'),
(1,'placements','placements_1.svg','Placements & Training'),
(1,'campus','campus_facilities_1.svg','Campus Facilities'),
-- Pharmacy (2)
(2,'labs','labs_1.svg','Pharmacy Lab'),
(2,'classrooms','classroom_1.svg','Classroom'),
(2,'library','library_1.svg','Library'),
(2,'infrastructure','infrastructure_1.svg','Infrastructure'),
(2,'placements','placements_1.svg','Career Support'),
(2,'campus','campus_facilities_1.svg','Campus Facilities'),
-- Nursing (3)
(3,'labs','labs_1.svg','Simulation / Nursing Lab'),
(3,'classrooms','classroom_1.svg','Classroom'),
(3,'library','library_1.svg','Library'),
(3,'infrastructure','infrastructure_1.svg','Infrastructure'),
(3,'placements','placements_1.svg','Hospital Tie-ups'),
(3,'campus','campus_facilities_1.svg','Campus Facilities'),
-- Allied Health Science (4)
(4,'labs','labs_1.svg','Diagnostic Lab'),
(4,'classrooms','classroom_1.svg','Classroom'),
(4,'library','library_1.svg','Library'),
(4,'infrastructure','infrastructure_1.svg','Infrastructure'),
(4,'placements','placements_1.svg','Internships & Placements'),
(4,'campus','campus_facilities_1.svg','Campus Facilities');

-- Chatbot questions (Engineering)
INSERT INTO chatbot_questions (college_id, category, question, answer) VALUES
(1,'fees','What is engineering fees?','Engineering fees depend on the course and quota. For this demo: approx ₹55,000–₹85,000 per year. Please confirm with admissions office for the exact fee.'),
(1,'courses','What engineering courses are available?','We offer programs like CSE, ECE, MECH, and IT (demo list). See the dashboard “Courses Offered” section.'),
(1,'hostel','Tell hostel details','Separate hostel facilities with dining, security, study area, and transport support. Ask: “show hostel room”.'),
(1,'placements','Placement companies?','Training + placement support. Recruiters (demo): TCS, Wipro, Infosys, HCL and more (varies by year).'),
(1,'admission','Engineering admission process?','1) Choose course 2) Submit application 3) Provide marksheets 4) Document verification 5) Pay fee and confirm seat.'),
(1,'scholarship','Scholarships available?','Scholarships may be available based on merit, community, and government schemes. Ask admissions for current year schemes.'),
(1,'transport','Transport facility?','College bus routes are available in nearby regions. Bus routes change yearly; confirm with transport office.'),
(1,'labs','Engineering labs?','Computer labs, IoT labs, electronics labs, mechanical workshops and project labs are available.'),
(1,'library','Library facilities?','Central library with textbooks, journals, e-resources, and reading spaces.'),
(1,'events','Events and clubs?','Technical symposiums, workshops, hackathons, cultural programs and student clubs (demo).');

-- Chatbot questions (Pharmacy)
INSERT INTO chatbot_questions (college_id, category, question, answer) VALUES
(2,'fees','What is pharmacy fees?','Pharmacy fees vary by program. For this demo: approx ₹45,000–₹75,000 per year. Please verify with admissions.'),
(2,'courses','Available pharmacy courses?','B.Pharm, D.Pharm, and (as per availability) M.Pharm. Check dashboard for the current demo list.'),
(2,'admission','Pharmacy admission process?','1) Choose program 2) Submit application + marksheets 3) Verification 4) Fee payment 5) Admission confirmation.'),
(2,'labs','Pharmacy labs?','Pharmaceutics, pharmacology, medicinal chemistry, pharmacognosy labs with hands-on practical sessions.'),
(2,'placements','Placement opportunities?','Industry visits, hospital pharmacy exposure, internships and guidance for jobs/higher studies.'),
(2,'hostel','Hostel facilities?','Hostel with dining, security and study environment. Ask: “hostel image”.'),
(2,'scholarship','Any scholarships?','Merit/government scholarships may be available. Please confirm eligibility with admissions.'),
(2,'library','Library?','Pharmacy textbooks, journals, reference materials and reading space available.'),
(2,'timings','College timings?','Typical working hours (demo): 9:00 AM – 4:30 PM. Exact schedule depends on timetable.'),
(2,'contact','Contact details?','Email: pharmacy@ssi.edu.in • Admissions: +91-00000-00000 (demo).');

-- Chatbot questions (Nursing)
INSERT INTO chatbot_questions (college_id, category, question, answer) VALUES
(3,'fees','What is nursing fees?','Nursing fees depend on program. For this demo: approx ₹40,000–₹70,000 per year. Please confirm with admissions.'),
(3,'courses','Available nursing courses?','B.Sc Nursing, GNM, Post Basic B.Sc Nursing (demo list).'),
(3,'admission','Nursing admission process?','1) Apply 2) Submit certificates 3) Verification 4) Clinical readiness details 5) Pay fee and confirm admission.'),
(3,'hostel','Show girls hostel room','Sure. Type “girls hostel room” or “hostel image” in chat to view images.'),
(3,'labs','Nursing labs?','Nursing foundation lab, OBG lab, child health lab, nutrition lab and simulation training.'),
(3,'placements','Nursing placements?','Hospital tie-ups and placement guidance. Opportunities may include hospitals and healthcare centers.'),
(3,'faculty','Faculty details?','Qualified nursing faculty with clinical and teaching experience (demo).'),
(3,'events','Any events?','Health awareness programs, workshops, community outreach and college events (demo).'),
(3,'library','Library?','Nursing reference books, journals, and study resources available.'),
(3,'contact','Contact?','Email: nursing@ssi.edu.in • Admissions: +91-00000-00000 (demo).');

-- Chatbot questions (Allied Health Science)
INSERT INTO chatbot_questions (college_id, category, question, answer) VALUES
(4,'fees','Allied health science fees?','Fees vary by program. For this demo: approx ₹45,000–₹80,000 per year. Please confirm with admissions.'),
(4,'courses','Allied health science courses?','B.Sc MLT, B.Sc Radiology & Imaging, B.Sc OT & Anaesthesia (demo list).'),
(4,'labs','Allied health science labs?','Diagnostic labs, physiology labs, anatomy models and hands-on training with equipment.'),
(4,'admission','Allied health science admission process?','1) Apply 2) Submit marksheets 3) Verification 4) Fee payment 5) Admission confirmation.'),
(4,'placements','Placement companies?','Internships and hospital exposure. Placement support may include hospitals/diagnostic centers (demo).'),
(4,'hostel','Hostel image','Sure. Ask “hostel image” / “boys hostel room” to see hostel room images.'),
(4,'transport','Transport facility?','Bus routes may be available in nearby regions. Please confirm with transport office.'),
(4,'timings','College timings?','Typical working hours (demo): 9:00 AM – 4:30 PM. Exact schedule depends on timetable.'),
(4,'library','Library?','Books and resources related to allied health programs are available.'),
(4,'contact','Contact details?','Email: ahs@ssi.edu.in • Admissions: +91-00000-00000 (demo).');

-- -------------------------------------------------------
-- EXTRA chatbot responses (more coverage for mini project)
-- Categories covered: departments, faculty, infrastructure, scholarships, transport, timings, contact, events, library
-- -------------------------------------------------------

-- Engineering (college_id=1)
INSERT INTO chatbot_questions (college_id, category, question, answer) VALUES
(1,'departments','Engineering departments?','Departments (demo): Computer Science, ECE, Mechanical, IT. You can ask “CSE department details?”'),
(1,'departments','CSE department details?','CSE focuses on programming, data structures, web development, AI basics, and projects. Labs include programming lab and project lab (demo).'),
(1,'infrastructure','Engineering infrastructure?','Smart classrooms, seminar halls, computer centers, innovation spaces, and a central library (demo).'),
(1,'faculty','Engineering faculty?','Faculty are experienced and student-friendly (demo). For official faculty list, contact the department office.'),
(1,'timings','Engineering college timings?','Typical timings (demo): 9:00 AM – 4:30 PM. Exam/semester schedules may vary.'),
(1,'contact','Engineering contact details?','Admissions: +91-00000-00000 • Email: admissions@ssi.edu.in (demo).'),
(1,'events','Engineering events?','Hackathons, symposiums, workshops, guest lectures, and club activities (demo).'),
(1,'transport','Engineering bus routes?','Bus routes are available in nearby regions and may change yearly. Contact the transport office for current routes (demo).');

-- Pharmacy (college_id=2)
INSERT INTO chatbot_questions (college_id, category, question, answer) VALUES
(2,'departments','Pharmacy departments?','Key areas (demo): Pharmaceutics, Pharmacology, Pharmaceutical Chemistry, Pharmacognosy, Pharmacy Practice.'),
(2,'faculty','Pharmacy faculty?','Qualified faculty support theory + practical learning (demo). For official list, contact the college office.'),
(2,'infrastructure','Pharmacy infrastructure?','Well-equipped labs, practical demo rooms, library, and learning spaces (demo).'),
(2,'scholarship','Pharmacy scholarships?','Scholarships may be available based on merit/government schemes. Confirm current eligibility with admissions (demo).'),
(2,'transport','Pharmacy transport?','College transport is available in selected routes (demo). Contact transport office for route details.'),
(2,'events','Pharmacy events?','Pharma workshops, seminars, health awareness programs, and industry expert sessions (demo).'),
(2,'hostel','Show hostel room','Type “hostel image” to see hostel images (demo). Replace placeholders with real images anytime.'),
(2,'faculty','Pharmacy practical training?','Strong practical sessions with lab experiments, record work, and safety practices (demo).');

-- Nursing (college_id=3)
INSERT INTO chatbot_questions (college_id, category, question, answer) VALUES
(3,'departments','Nursing departments?','Nursing areas (demo): Fundamentals, Medical-Surgical Nursing, OBG, Child Health, Community Health, Mental Health.'),
(3,'infrastructure','Nursing infrastructure?','Simulation lab, nursing foundation lab, OBG & child health labs, nutrition lab (demo).'),
(3,'scholarship','Nursing scholarships?','Scholarships may be available via merit/government schemes. Confirm current options with admissions (demo).'),
(3,'transport','Nursing transport?','College transport may be available on selected routes. Confirm route timing with transport office (demo).'),
(3,'timings','Nursing college timings?','Typical class timings (demo): 9:00 AM – 4:30 PM. Clinical schedules may vary.'),
(3,'library','Nursing library?','Nursing journals, reference books, and study materials available (demo).'),
(3,'contact','Nursing contact details?','Email: nursing@ssi.edu.in • Admissions: +91-00000-00000 (demo).'),
(3,'events','Nursing events?','Health camps, community outreach, workshops and celebrations (demo).');

-- Allied Health Science (college_id=4)
INSERT INTO chatbot_questions (college_id, category, question, answer) VALUES
(4,'departments','Allied health departments?','Programs/areas (demo): Medical Lab Technology, Radiology & Imaging, OT & Anaesthesia Technology.'),
(4,'faculty','Allied health faculty?','Dedicated faculty with practical training focus (demo). Contact office for official faculty list.'),
(4,'infrastructure','Allied health infrastructure?','Modern equipment, diagnostic labs, skill rooms, anatomy models and training support (demo).'),
(4,'scholarship','Allied health scholarships?','Scholarships may be available based on merit and schemes. Confirm current eligibility with admissions (demo).'),
(4,'events','Allied health events?','Workshops, skill demos, guest talks and healthcare awareness programs (demo).'),
(4,'library','Allied health library?','Reference books, journals and learning material related to allied health sciences (demo).'),
(4,'hostel','Show hostel room','Type “hostel image” / “boys hostel room” / “girls hostel room” to see hostel images (demo).'),
(4,'contact','Allied health contact?','Email: ahs@ssi.edu.in • Admissions: +91-00000-00000 (demo).');
