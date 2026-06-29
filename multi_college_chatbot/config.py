"""
config.py
----------

Production-safe configuration (Render / Railway friendly)
"""

import os


class Config:
    # Flask session secret
    SECRET_KEY = os.getenv("SECRET_KEY")

    # MySQL config (from Railway / Render variables)
    MYSQL_HOST = os.getenv("MYSQL_HOST")
    MYSQL_PORT = int(os.getenv("MYSQL_PORT", 3306))
    MYSQL_USER = os.getenv("MYSQL_USER")
    MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD")
    MYSQL_DB = os.getenv("MYSQL_DB")

    # App info
    APP_NAME = "Multi College Enquiry Chatbot System"
    INSTITUTION_NAME = "Sri Shanmugha Institutions"