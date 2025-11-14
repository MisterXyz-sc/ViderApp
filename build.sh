#!/usr/bin/env bash
echo "Installing dependencies..."
pip install -r requirements.txt

echo "Running database migrations..."
python -c "
from app import app, db
with app.app_context():
    db.create_all()
    print('Database tables created')
"
