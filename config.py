"""
config.py
----------
Beginner-friendly configuration file.

IMPORTANT:
1) Update the MySQL credentials below to match your PC.
2) Keep SECRET_KEY random for sessions.
"""

import os


class Config:
    # Flask session secret (change this in production)
    SECRET_KEY = os.getenv("SECRET_KEY", "change-this-secret-key")

    # MySQL database configuration (EDIT THESE VALUES)
    MYSQL_HOST = os.getenv("MYSQL_HOST", "localhost")
    MYSQL_PORT = int(os.getenv("MYSQL_PORT", "3306"))
    MYSQL_USER = os.getenv("MYSQL_USER", "root")
    MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD", "root123")
    MYSQL_DB = os.getenv("MYSQL_DB", "multi_college_chatbot")

    # App settings
    APP_NAME = "Multi College Enquiry Chatbot System"
    INSTITUTION_NAME = "Sri Shanmugha Institutions"

