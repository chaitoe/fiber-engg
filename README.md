# Fiber Duct Planning Tool

An open-source web-based tool for planning and managing fiber optic duct infrastructure. This application provides comprehensive features for designing, documenting, and managing fiber duct networks.

## Features
- Interactive map-based duct planning
- Comprehensive duct and cable configuration management
- Capacity planning and monitoring
- Cost calculation and estimation
- Installation tracking and documentation
- GIS integration with OpenStreetMap
- Multi-user support

## System Requirements
- Linux-based operating system (Ubuntu 20.04 LTS recommended)
- Minimum 4GB RAM
- 20GB free disk space
- Internet connection for map tiles

## Quick Installation
Clone the repository:
```bash
git clone https://github.com/yourusername/fiber-duct-planner.git
cd fiber-duct-planner
````
Run the installation script:
```bash
sudo chmod +x install.sh
sudo ./install.sh
```
Access the application at:
```bash
http://localhost
```
## Detailed Manual Installation Guide for Fiber Duct Planner

### System Requirements (2024)

- Ubuntu 22.04 LTS or newer
- Minimum 4GB RAM (8GB recommended)
- 20GB free disk space
- Internet connection

### System Preparation

Update System
```bash
sudo apt update
sudo apt upgrade -y
````
2 Install System Dependencies
```bash
sudo apt install -y \
    build-essential \
    python3.11 \
    python3.11-dev \
    python3.11-venv \
    python3-pip \
    postgresql-14 \
    postgresql-14-postgis-3 \
    postgresql-contrib \
    postgis \
    gdal-bin \
    libpq-dev \
    nginx \
    git \
    curl \
    software-properties-common
```
3 Install Node.js (v20.x LTS)
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
# Verify installations
node --version  # Should show v20.x.x
npm --version   # Should show 10.x.x
````
4 Install Docker and Docker Compose
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add your user to docker group
sudo usermod -aG docker $USER

# Verify installations
docker --version
docker-compose --version

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker
````
2. Database Setup

2.1 Configure PostgreSQL
```bash
# Start PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Set password for postgres user
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"

# Create database and user
sudo -u postgres psql << EOF
CREATE USER fiber_user WITH PASSWORD 'secure_password';
CREATE DATABASE fiber_planning;
ALTER DATABASE fiber_planning OWNER TO fiber_user;
\c fiber_planning
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
EOF

# Verify PostGIS installation
sudo -u postgres psql -d fiber_planning -c "SELECT PostGIS_version();"
````
2.2 Configure PostgreSQL Access
```bash
# Edit pg_hba.conf
sudo nano /etc/postgresql/14/main/pg_hba.conf

# Add these lines (adjust according to your security needs)
# IPv4 local connections:
host    fiber_planning    fiber_user    127.0.0.1/32    md5
host    fiber_planning    fiber_user    0.0.0.0/0       md5

# Restart PostgreSQL
sudo systemctl restart postgresql
```
3. Application Setup
3.1 Clone Repository
```bash
# Create application directory
sudo mkdir -p /opt/fiber-duct-planner
sudo chown $USER:$USER /opt/fiber-duct-planner

# Clone repository
git clone https://github.com/yourusername/fiber-duct-planner.git /opt/fiber-duct-planner
cd /opt/fiber-duct-planner
```
3.2 Backend Setup
```bash
# Create and activate virtual environment
cd /opt/fiber-duct-planner/backend
python3.11 -m venv venv
source venv/bin/activate

# Alternative requirements.txt with specific versions:
cat > requirements.txt << EOF
Flask==3.0.0
Flask-SQLAlchemy==3.1.1
Flask-Migrate==4.0.5
Flask-CORS==4.0.0
psycopg2-binary==2.9.9
GeoAlchemy2==0.14.2
Shapely==2.0.2
pyproj==3.6.1
gunicorn==21.2.0
python-dotenv==1.0.0
marshmallow==3.20.1
Flask-JWT-Extended==4.6.0
pytest==7.4.3
black==23.12.1
flake8==6.1.0
EOF

# Install Python packages
pip install --upgrade pip
pip install -r requirements.txt

# Create environment file
cat > .env << EOF
FLASK_APP=app
FLASK_ENV=development
DATABASE_URL=postgresql://fiber_user:secure_password@localhost/fiber_planning
SECRET_KEY=$(openssl rand -hex 32)
CORS_ORIGINS=http://localhost:3000,http://localhost
EOF

# Initialize database
flask db init
flask db migrate -m "Initial migration"
flask db upgrade
3.3 Frontend Setup
bashCopy# Install frontend dependencies
cd /opt/fiber-duct-planner/frontend
npm install

# Package.json with specific versions:
cat > package.json << EOF
{
  "name": "fiber-duct-planner-frontend",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "@material-ui/core": "^4.12.4",
    "@material-ui/icons": "^4.11.3",
    "@material-ui/lab": "^4.0.0-alpha.61",
    "axios": "^1.6.2",
    "ol": "^8.2.0",
    "@turf/turf": "^6.5.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.21.0",
    "react-scripts": "5.0.1",
    "date-fns": "^2.30.0",
    "formik": "^2.4.5",
    "yup": "^1.3.3"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  },
  "devDependencies": {
    "@testing-library/jest-dom": "^6.1.5",
    "@testing-library/react": "^14.1.2",
    "@testing-library/user-event": "^14.5.1",
    "eslint": "^8.55.0",
    "prettier": "^3.1.1"
  }
}
EOF

# Create environment file
cat > .env << EOF
REACT_APP_API_URL=http://localhost:5000
REACT_APP_MAP_STYLE=https://tile.openstreetmap.org/{z}/{x}/{y}.png
EOF
4. Service Configuration
4.1 Create Systemd Service for Backend
bashCopysudo tee /etc/systemd/system/fiber-planner-backend.service << EOF
[Unit]
Description=Fiber Duct Planner Backend
After=network.target postgresql.service

[Service]
User=$USER
Group=$USER
WorkingDirectory=/opt/fiber-duct-planner/backend
Environment="PATH=/opt/fiber-duct-planner/backend/venv/bin"
EnvironmentFile=/opt/fiber-duct-planner/backend/.env
ExecStart=/opt/fiber-duct-planner/backend/venv/bin/gunicorn --workers 3 --bind 127.0.0.1:5000 "app:create_app()"
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start fiber-planner-backend
sudo systemctl enable fiber-planner-backend
4.2 Configure Nginx
bashCopysudo tee /etc/nginx/sites-available/fiber-planner << EOF
server {
    listen 80;
    server_name localhost;

    # Frontend
    location / {
        root /opt/fiber-duct-planner/frontend/build;
        index index.html;
        try_files \$uri \$uri/ /index.html;
    }

    # Backend API
    location /api {
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/fiber-planner /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default  # Remove default site
sudo nginx -t  # Test configuration
sudo systemctl restart nginx
5. Build and Deploy
5.1 Build Frontend
bashCopycd /opt/fiber-duct-planner/frontend
npm run build
5.2 Initialize Database with Sample Data
bashCopycd /opt/fiber-duct-planner/backend
source venv/bin/activate
python init_db.py  # Create this script with initial data
5.3 Final Steps
bashCopy# Set proper permissions
sudo chown -R $USER:$USER /opt/fiber-duct-planner
sudo chmod -R 755 /opt/fiber-duct-planner

# Restart services
sudo systemctl restart fiber-planner-backend
sudo systemctl restart nginx
6. Verification and Testing
6.1 Check Services Status
bashCopysudo systemctl status postgresql
sudo systemctl status fiber-planner-backend
sudo systemctl status nginx
6.2 Test Database Connection
bashCopypsql -h localhost -U fiber_user -d fiber_planning
# Enter password when prompted
6.3 Test API
bashCopycurl http://localhost:5000/api/health
curl http://localhost:5000/api/duct-types
6.4 Test Frontend
Open http://localhost in your web browser
7. Development Environment Setup
7.1 Backend Development
bashCopycd /opt/fiber-duct-planner/backend
source venv/bin/activate
export FLASK_ENV=development
export FLASK_DEBUG=1
flask run
7.2 Frontend Development
bashCopycd /opt/fiber-duct-planner/frontend
npm start
8. Maintenance
8.1 Database Backup
bashCopy# Create backup script
cat > /opt/fiber-duct-planner/backup.sh << EOF
#!/bin/bash
BACKUP_DIR="/opt/fiber-duct-planner/backups"
TIMESTAMP=\$(date +%Y%m%d_%H%M%S)
mkdir -p \$BACKUP_DIR
pg_dump -U fiber_user -h localhost fiber_planning > \$BACKUP_DIR/backup_\$TIMESTAMP.sql
EOF

chmod +x /opt/fiber-duct-planner/backup.sh
8.2 Log Rotation
bashCopysudo tee /etc/logrotate.d/fiber-planner << EOF
/opt/fiber-duct-planner/logs/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 $USER $USER
}
EOF
8.3 Update Script
bashCopycat > /opt/fiber-duct-planner/update.sh << EOF
#!/bin/bash
cd /opt/fiber-duct-planner
git pull
cd frontend
npm install
npm run build
cd ../backend
source venv/bin/activate
pip install -r requirements.txt
flask db upgrade
sudo systemctl restart fiber-planner-backend
sudo systemctl restart nginx
EOF

chmod +x /opt/fiber-duct-planner/update.sh
9. Troubleshooting
9.1 Check Logs
bashCopy# Backend logs
sudo journalctl -u fiber-planner-backend

# Nginx logs
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log

# PostgreSQL logs
sudo tail -f /var/log/postgresql/postgresql-14-main.log
9.2 Common Issues

Database Connection Issues

bashCopy# Check PostgreSQL status
sudo systemctl status postgresql

# Check database connection
psql -h localhost -U fiber_user -d fiber_planning -c "\dt"

# Verify PostGIS extension
psql -h localhost -U fiber_user -d fiber_planning -c "SELECT PostGIS_version();"

Permission Issues

bashCopy# Fix permissions
sudo chown -R $USER:$USER /opt/fiber-duct-planner
sudo chmod -R 755 /opt/fiber-duct-planner

Port Conflicts

bashCopy# Check port usage
sudo netstat -tulpn | grep -E ':80|:5000'
10. Security Recommendations

Configure SSL/TLS certificates
Set up proper firewall rules
Regular security updates
Implement proper authentication
Regular database backups
Monitor system resources

11. Performance Optimization

Configure PostgreSQL for better performance
Set up caching
Optimize nginx configuration
Configure proper resource limits

Remember to replace placeholder values like usernames, passwords, and paths according to your specific setup. Also, make sure to follow security best practices and adjust configurations based on your production environment requirements.
Copy
This detailed guide provides:
- Specific version numbers for all dependencies
- Complete configuration files
- System service setup
- Development environment setup
- Maintenance procedures
- Troubleshooting steps
- Security recommendations
- Performance optimization tips

You can save this as `INSTALL.md` in your project repository for easy reference.
