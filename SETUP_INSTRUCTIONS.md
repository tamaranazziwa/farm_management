# Farm Management System - Setup Instructions

## Prerequisites

Before setting up the Farm Management System, ensure you have the following installed:

1. **XAMPP** - Download from https://www.apachefriends.org/
2. **Python 3.8+** - Download from https://www.python.org/
3. **Git** (optional) - For version control

## Installation Steps

### Step 1: Install XAMPP

1. Download XAMPP from https://www.apachefriends.org/
2. Install XAMPP following the installation wizard
3. Start XAMPP Control Panel
4. Start **Apache** and **MySQL** services

### Step 2: Setup Database

1. Open your web browser and go to `http://localhost/phpmyadmin`
2. Click on "Import" tab
3. Click "Choose File" and select `database/farm_management.sql`
4. Click "Go" to import the database
5. Verify that the `farm_management` database is created with all tables

### Step 3: Install Python Dependencies

1. Open Command Prompt (Windows) or Terminal (Mac/Linux)
2. Navigate to the project directory:
   ```bash
   cd farm_management_system
   ```
3. Install Python packages:
   ```bash
   pip install -r requirements.txt
   ```

### Step 4: Configure Database Connection

The system is pre-configured to work with XAMPP's default MySQL settings:
- Host: localhost
- Port: 3306
- Username: root
- Password: (empty)
- Database: farm_management

If you need to change these settings, edit the `DB_CONFIG` in `app.py`.

### Step 5: Run the Application

1. In the project directory, run:
   ```bash
   python app.py
   ```
2. You should see output like:
   ```
   * Running on all addresses (0.0.0.0)
   * Running on http://127.0.0.1:5000
   * Running on http://[your-ip]:5000
   ```

### Step 6: Access the System

1. Open your web browser
2. Go to `http://localhost:5000`
3. Use the demo credentials to login:
   - **Admin**: username: `admin`, password: `password`
   - **Manager**: username: `manager`, password: `password`
   - **Worker**: username: `worker`, password: `password`

## System Features

### Dashboard
- Overview statistics
- Interactive charts and graphs
- Recent activities
- Quick action buttons

### Farm Management
- Add, view, and manage farms
- Farm details and statistics
- Location and size tracking

### Crop Management
- Track crop planting and harvesting
- Monitor crop status and yields
- Filter by farm, status, and crop type

### Livestock Management
- Animal tracking and health monitoring
- Breed and weight management
- Health status tracking

### Financial Management
- Revenue and expense tracking
- Category-based filtering
- Payment method tracking
- Financial reports and analytics

### Reports & Analytics
- Performance monitoring
- Interactive charts and graphs
- Export functionality
- Key metrics and KPIs

## Troubleshooting

### Common Issues

1. **Database Connection Error**
   - Ensure XAMPP MySQL is running
   - Check database credentials in `app.py`
   - Verify database is imported correctly

2. **Python Package Installation Error**
   - Update pip: `python -m pip install --upgrade pip`
   - Try installing packages individually
   - Check Python version compatibility

3. **Port Already in Use**
   - Change port in `app.py`: `app.run(port=5001)`
   - Kill existing processes using the port

4. **Chart.js Not Loading**
   - Check internet connection (CDN resources)
   - Verify browser console for errors
   - Ensure JavaScript is enabled

### Database Reset

To reset the database:
1. Go to phpMyAdmin
2. Drop the `farm_management` database
3. Re-import `database/farm_management.sql`

### Log Files

Check the following for error logs:
- XAMPP error logs: `C:\xampp\apache\logs\error.log`
- Python console output
- Browser developer console

## Development

### Adding New Features

1. **Backend**: Add new routes in `app.py`
2. **Frontend**: Create new templates in `templates/`
3. **Database**: Add new tables or modify existing schema
4. **Styling**: Update `static/css/style.css`

### Database Schema

The system includes the following main tables:
- `users` - User authentication and roles
- `farms` - Farm information
- `crops` - Crop management
- `livestock` - Animal tracking
- `equipment` - Farm equipment
- `financial_records` - Revenue and expenses
- `inventory` - Supplies and resources
- `reports` - Performance data

### API Endpoints

- `/api/dashboard/stats` - Dashboard statistics
- `/api/charts/*` - Chart data endpoints
- `/api/farms` - Farm management
- `/api/crops` - Crop management
- `/api/livestock` - Livestock management
- `/api/financial` - Financial records
- `/api/reports/*` - Report data

## Security Notes

- Change default passwords in production
- Use environment variables for sensitive data
- Implement proper authentication
- Add input validation and sanitization
- Use HTTPS in production

## Support

For technical support or questions:
1. Check the troubleshooting section
2. Review error logs
3. Verify all prerequisites are installed
4. Ensure XAMPP services are running

## System Requirements

- **Operating System**: Windows 10+, macOS 10.14+, or Linux
- **RAM**: Minimum 4GB (8GB recommended)
- **Storage**: 2GB free space
- **Browser**: Chrome, Firefox, Safari, or Edge (latest versions)
- **Internet**: Required for CDN resources (charts, icons, etc.)

## Performance Tips

1. **Database Optimization**
   - Regular database maintenance
   - Index optimization
   - Query performance monitoring

2. **Application Performance**
   - Monitor memory usage
   - Optimize database queries
   - Use pagination for large datasets

3. **Browser Performance**
   - Clear browser cache regularly
   - Disable unnecessary browser extensions
   - Use modern browsers for best performance