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
````
```bash
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
````
5. Configuration Environment Variables
- Backend (.env)
```bash
FLASK_APP=app
FLASK_ENV=production
DATABASE_URL=postgresql://fiber_user:secure_password@localhost/fiber_planning
SECRET_KEY=your-secret-key
````
- Frontend (.env)
```bash
REACT_APP_API_URL=http://localhost:5000
````
### Duct Types Configuration
Default duct types are installed automatically.

To add custom duct types:
- Access the API endpoint: POST /api/duct-types
- Provide JSON data:
```bash
{
    "name": "Custom HDPE 40mm",
    "diameter": 40.0,
    "material": "HDPE",
    "max_cables": 4,
    "color": "Blue",
    "cost_per_meter": 6.5,
    "description": "Custom duct configuration"
}
````
### Usage

1. Planning a New Duct:
- Click "New Duct" on the map interface
- Draw the duct path
- Configure duct properties
- Save the configuration
2. Managing Ducts:
- View existing ducts on the map
- Click on ducts to view details
- Edit properties as needed
- Track capacity and usage
3. Installing Cables:
- Select a duct
- Add cable installation details
- Track capacity usage
- Document installation dates

### API Documentation
The API documentation is available at http://localhost:5000/api/docs
Key Endpoints:
- GET /api/ducts - List all ducts
- POST /api/ducts - Create new duct
- GET /api/duct-types - List duct types
- POST /api/duct-types - Create duct type
- GET /api/cables - List installed cables
- POST /api/ducts/:id/cables - Install cable in duct

### Development
1. Setup Development Environment:
```bash
# Backend
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
flask run

# Frontend
cd frontend
npm install
npm start
````
2. Running Tests:
```bash
# Backend tests
pytest

# Frontend tests
npm test
```
Contributing

Fork the repository
Create a feature branch
Commit your changes
Push to the branch
Create a Pull Request

Security Considerations

Change default passwords
Configure proper firewall rules
Use HTTPS in production
Implement proper authentication
Regular security updates

Troubleshooting
Common Issues

Database Connection Issues:

Check PostgreSQL service status
Verify database credentials
Ensure PostGIS extension is installed


Map Display Issues:

Check internet connection
Verify API keys if using premium map services
Clear browser cache


Docker Issues:

Check Docker service status
Verify port availability
Check Docker logs



License
This project is licensed under the MIT License - see the LICENSE file for details.
Support
For support, please:

Check the documentation
Search existing issues
Create a new issue if needed

Acknowledgments

OpenStreetMap for map data
PostGIS team for GIS support
Open source community
  
