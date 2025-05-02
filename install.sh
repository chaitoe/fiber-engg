#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[*]${NC} $1"
}

# Check if running with sudo/root
if [ "$EUID" -ne 0 ]; then 
    print_error "Please run this script as root or with sudo"
    exit 1
fi

# Update system packages
print_status "Updating system packages..."
apt-get update && apt-get upgrade -y

# Install required system packages
print_status "Installing system dependencies..."
apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    postgresql \
    postgresql-contrib \
    postgis \
    nodejs \
    npm \
    git \
    curl \
    docker.io \
    docker-compose

# Enable and start Docker
print_status "Enabling and starting Docker..."
systemctl enable docker
systemctl start docker

# Create project directory
PROJECT_DIR="/opt/fiber-duct-planner"
print_status "Creating project directory at ${PROJECT_DIR}..."
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

# Clone the repository (replace with your actual repo URL)
print_status "Cloning project repository..."
git clone https://github.com/yourusername/fiber-duct-planner.git .

# Setup PostgreSQL
print_status "Configuring PostgreSQL..."
sudo -u postgres psql -c "CREATE USER fiber_user WITH PASSWORD 'secure_password';"
sudo -u postgres psql -c "CREATE DATABASE fiber_planning;"
sudo -u postgres psql -c "ALTER DATABASE fiber_planning OWNER TO fiber_user;"
sudo -u postgres psql -d fiber_planning -c "CREATE EXTENSION postgis;"

# Create and configure environment files
print_status "Creating environment files..."

# Backend .env
cat > backend/.env << EOL
FLASK_APP=app
FLASK_ENV=production
DATABASE_URL=postgresql://fiber_user:secure_password@localhost/fiber_planning
SECRET_KEY=$(openssl rand -hex 32)
EOL

# Frontend .env
cat > frontend/.env << EOL
REACT_APP_API_URL=http://localhost:5000
EOL

# Build and start with Docker Compose
print_status "Building and starting Docker containers..."
docker-compose build
docker-compose up -d

# Initialize the database
print_status "Initializing database..."
docker-compose exec backend flask db init
docker-compose exec backend flask db migrate
docker-compose exec backend flask db upgrade

# Add initial data
print_status "Adding initial configuration data..."
docker-compose exec backend python3 << EOL
from app import create_app, db
from app.models.duct_config import DuctType, CableType, DuctConfiguration

app = create_app()
with app.app_context():
    # Add default duct types
    duct_types = [
        DuctType(
            name="Standard HDPE 40mm",
            diameter=40.0,
            material="HDPE",
            max_cables=4,
            color="Black",
            cost_per_meter=5.0,
            description="Standard duct for small to medium installations"
        ),
        DuctType(
            name="Large HDPE 63mm",
            diameter=63.0,
            material="HDPE",
            max_cables=8,
            color="Black",
            cost_per_meter=8.0,
            description="Large duct for medium to large installations"
        )
    ]
    
    for dt in duct_types:
        db.session.add(dt)
    
    # Add default cable types
    cable_types = [
        CableType(
            name="24 Core Single Mode",
            fiber_count=24,
            diameter=8.1,
            weight_per_km=75.0,
            min_bend_radius=120.0,
            cost_per_meter=2.5,
            description="Standard 24 core single mode fiber cable"
        ),
        CableType(
            name="48 Core Single Mode",
            fiber_count=48,
            diameter=10.2,
            weight_per_km=95.0,
            min_bend_radius=150.0,
            cost_per_meter=4.0,
            description="High capacity 48 core single mode fiber cable"
        )
    ]
    
    for ct in cable_types:
        db.session.add(ct)
    
    db.session.commit()
EOL

print_status "Installation completed successfully!"
print_status "You can access the application at: http://localhost"
print_status "API endpoint is available at: http://localhost:5000"

# Print warning about security
print_warning "Please make sure to change default passwords in production environment!"
print_warning "Default database credentials: fiber_user:secure_password"
