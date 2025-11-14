#!/usr/bin/env bash
echo "=== Installing Python dependencies ==="
pip install -r requirements.txt

echo "=== Running database initialization ==="
python -c "
import os
from app import app, db
from models import User
from werkzeug.security import generate_password_hash

with app.app_context():
    db.create_all()
    print('Database tables created')
    
    # Create admin user if not exists
    admin_email = os.getenv('ADMIN_EMAIL')
    admin_password = os.getenv('ADMIN_PASSWORD')
    if admin_email and admin_password:
        admin = User.query.filter_by(email=admin_email).first()
        if not admin:
            admin = User(
                email=admin_email,
                password=generate_password_hash(admin_password),
                role='admin'
            )
            db.session.add(admin)
            db.session.commit()
            print('Admin user created')
        else:
            print('Admin user already exists')
    
    print('Database initialization completed')
"

echo "=== Build completed ==="
