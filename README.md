TO RUN THE DJANGO SERVER:
INSTALLATION:
1. Install django: `python -m pip install Django`
2. Install rest framework: `python -m pip install djangorestframework`
3. Install mysql connectors:
`python -m pip install mysql-connector-python`
`pip install mysqlclient`
4. Install CORS Header: `python -m pip install django-cors-headers`

USAGE:
1. FIRST INSTALL MYSQL AND INSERT ALL TABLES IN THE database.sql (file is in the github repo)

2. IN MYSQL, ADD A NEW USER JUST FOR DJANGO, AND GIVE IT ALL THE PERMISSIONS

3. OPEN THE `greenleaf-survey/mysite/settings.py` FILE AND GO TO THE DATABASE SECTION, AND EDIT THE USERNAME/PASSWORD TO MATCH YOUR NEW USER

4. RUN DJANGO SERVER USING `python manage.py runserver`

TO INSTALL THE REACT FRONTEND:
INSTALLATION:
1. Install dependencies: `npm i`

USAGE:
1. Start dev server: `npm run dev`