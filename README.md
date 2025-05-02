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

1. Clone the repository:
```bash
git clone https://github.com/yourusername/fiber-duct-planner.git
cd fiber-duct-planner
````
2. Run the installation script:
```bash
sudo chmod +x install.sh
sudo ./install.sh
```
Access the application at:
```bash
http://localhost
```

## Manual Installation
Prerequisites

- Python 3.9+
- Node.js 14+
- PostgreSQL 13+ with PostGIS
 -Docker and Docker Compose

Step-by-Step Installation

1. Set up the database:
```bash
sudo -u postgres psql
CREATE USER fiber_user WITH PASSWORD 'secure_password';
CREATE DATABASE fiber_planning;
ALTER DATABASE fiber_planning OWNER TO fiber_user;
\c fiber_planning
CREATE EXTENSION postgis;
```
2. Configure the backend:
```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```
3. Configure the frontend:
```bash
cd frontend
npm install
```
4. Start the application:
```bash
docker-compose up --build
Configuration
Environment Variables
Backend (.env)
CopyFLASK_APP=app
FLASK_ENV=production
DATABASE_URL=postgresql://fiber_user:secure_password@localhost/fiber_planning
SECRET_KEY=your-secret-key
Frontend (.env)
CopyREACT_APP_API_URL=http://localhost:5000
Duct Types Configuration
Default duct types are installed automatically. To add custom duct types:

Access the API endpoint: POST /api/duct-types
Provide JSON data:

jsonCopy{
    "name": "Custom HDPE 50mm",
    "diameter": 50.0,
    "material": "HDPE",
    "max_cables": 6,
    "color": "Black",
    "cost_per_meter": 6.5,
    "description": "Custom duct configuration"
}




  
