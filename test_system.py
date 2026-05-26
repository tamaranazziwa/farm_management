#!/usr/bin/env python3
"""
Farm Management System - Test Script
This script tests the basic functionality of the system
"""

import sys
import os
import requests
import json
from datetime import datetime

# Add the current directory to Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

def test_database_connection():
    """Test database connection"""
    try:
        from app import get_db_connection
        connection = get_db_connection()
        if connection:
            print("✓ Database connection successful")
            connection.close()
            return True
        else:
            print("✗ Database connection failed")
            return False
    except Exception as e:
        print(f"✗ Database connection error: {e}")
        return False

def test_flask_app():
    """Test if Flask app can start"""
    try:
        from app import app
        with app.test_client() as client:
            # Test login page
            response = client.get('/login')
            if response.status_code == 200:
                print("✓ Flask app starts successfully")
                return True
            else:
                print(f"✗ Flask app test failed: {response.status_code}")
                return False
    except Exception as e:
        print(f"✗ Flask app error: {e}")
        return False

def test_api_endpoints():
    """Test API endpoints"""
    try:
        from app import app
        with app.test_client() as client:
            # Test dashboard stats endpoint
            response = client.get('/api/dashboard/stats')
            if response.status_code == 200:
                print("✓ API endpoints working")
                return True
            else:
                print(f"✗ API test failed: {response.status_code}")
                return False
    except Exception as e:
        print(f"✗ API test error: {e}")
        return False

def test_database_tables():
    """Test if all required tables exist"""
    try:
        from app import get_db_connection
        connection = get_db_connection()
        if not connection:
            print("✗ Cannot connect to database")
            return False
        
        cursor = connection.cursor()
        
        # List of required tables
        required_tables = [
            'users', 'farms', 'crops', 'livestock', 
            'equipment', 'financial_records', 'inventory', 'reports'
        ]
        
        cursor.execute("SHOW TABLES")
        existing_tables = [table[0] for table in cursor.fetchall()]
        
        missing_tables = []
        for table in required_tables:
            if table not in existing_tables:
                missing_tables.append(table)
        
        if missing_tables:
            print(f"✗ Missing tables: {missing_tables}")
            return False
        else:
            print("✓ All required tables exist")
            return True
            
    except Exception as e:
        print(f"✗ Database table test error: {e}")
        return False
    finally:
        if connection:
            connection.close()

def test_sample_data():
    """Test if sample data exists"""
    try:
        from app import get_db_connection
        connection = get_db_connection()
        if not connection:
            print("✗ Cannot connect to database")
            return False
        
        cursor = connection.cursor(dictionary=True)
        
        # Check for sample data
        cursor.execute("SELECT COUNT(*) as count FROM users")
        user_count = cursor.fetchone()['count']
        
        cursor.execute("SELECT COUNT(*) as count FROM farms")
        farm_count = cursor.fetchone()['count']
        
        if user_count > 0 and farm_count > 0:
            print("✓ Sample data exists")
            return True
        else:
            print("✗ No sample data found")
            return False
            
    except Exception as e:
        print(f"✗ Sample data test error: {e}")
        return False
    finally:
        if connection:
            connection.close()

def main():
    """Run all tests"""
    print("Farm Management System - System Test")
    print("=" * 50)
    
    tests = [
        ("Database Connection", test_database_connection),
        ("Database Tables", test_database_tables),
        ("Sample Data", test_sample_data),
        ("Flask Application", test_flask_app),
        ("API Endpoints", test_api_endpoints),
    ]
    
    passed = 0
    total = len(tests)
    
    for test_name, test_func in tests:
        print(f"\nTesting {test_name}...")
        if test_func():
            passed += 1
        else:
            print(f"  {test_name} failed!")
    
    print("\n" + "=" * 50)
    print(f"Test Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("✓ All tests passed! System is ready to use.")
        print("\nTo start the system:")
        print("1. Make sure XAMPP is running")
        print("2. Run: python app.py")
        print("3. Open: http://localhost:5000")
        print("4. Login with: admin/password")
    else:
        print("✗ Some tests failed. Please check the setup instructions.")
        print("\nCommon issues:")
        print("- XAMPP MySQL not running")
        print("- Database not imported")
        print("- Python dependencies not installed")
    
    return passed == total

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)