

CREATE DATABASE IF NOT EXISTS farm_management;
USE farm_management;


-- Users table for authentication and role management
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'manager', 'worker') DEFAULT 'worker',
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Farms table for farm information
CREATE TABLE IF NOT EXISTS farms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(200) NOT NULL,
    size_acres DECIMAL(10,2),
    owner_name VARCHAR(100),
    established_date DATE,
    description TEXT,
    status ENUM('active', 'inactive', 'sold') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;


-- Crops table
CREATE TABLE IF NOT EXISTS crops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    crop_name VARCHAR(100) NOT NULL,
    variety VARCHAR(100),
    planting_date DATE,
    harvest_date DATE,
    area_acres DECIMAL(8,2),
    expected_yield DECIMAL(10,2),
    actual_yield DECIMAL(10,2),
    status ENUM('planted', 'growing', 'ready_harvest', 'harvested', 'failed') DEFAULT 'planted',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Livestock table
CREATE TABLE IF NOT EXISTS livestock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    animal_type VARCHAR(50) NOT NULL,
    breed VARCHAR(100),
    tag_number VARCHAR(50) UNIQUE,
    birth_date DATE,
    gender ENUM('male', 'female'),
    weight DECIMAL(8,2),
    health_status ENUM('healthy', 'sick', 'injured', 'deceased') DEFAULT 'healthy',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Equipment table
CREATE TABLE IF NOT EXISTS equipment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    equipment_name VARCHAR(100) NOT NULL,
    equipment_type VARCHAR(50),
    brand VARCHAR(100),
    model VARCHAR(100),
    purchase_date DATE,
    purchase_price DECIMAL(12,2),
    condition_status ENUM('excellent', 'good', 'fair', 'poor', 'broken') DEFAULT 'good',
    maintenance_due DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Financial records
CREATE TABLE IF NOT EXISTS financial_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    transaction_type ENUM('revenue', 'expense') NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT,
    amount DECIMAL(12,2) NOT NULL,
    transaction_date DATE NOT NULL,
    payment_method ENUM('cash', 'check', 'card', 'bank_transfer') DEFAULT 'cash',
    reference_number VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Inventory
CREATE TABLE IF NOT EXISTS inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    quantity DECIMAL(10,2) NOT NULL,
    unit VARCHAR(20),
    unit_price DECIMAL(10,2),
    supplier VARCHAR(100),
    purchase_date DATE,
    expiry_date DATE,
    location VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Reports (references users and farms)
CREATE TABLE IF NOT EXISTS reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    farm_id INT NOT NULL,
    report_type VARCHAR(50) NOT NULL,
    report_date DATE NOT NULL,
    data JSON,
    notes TEXT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Transactions (generic)
CREATE TABLE IF NOT EXISTS transactions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  amount DECIMAL(15,2) NOT NULL,
  type ENUM('revenue','expense') NOT NULL,
  category VARCHAR(100),
  description TEXT,
  trans_date DATE NOT NULL,
  created_by INT,
  currency VARCHAR(5) DEFAULT 'UGX',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -----------------------
-- Labour and Tasks (labour before tasks because tasks references labour)
-- -----------------------

CREATE TABLE IF NOT EXISTS labour (
  id INT AUTO_INCREMENT PRIMARY KEY,
  farm_id INT NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  phone VARCHAR(30),
  role ENUM('worker','supervisor','manager','other') DEFAULT 'worker',
  hired_date DATE NULL,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  farm_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  assigned_to INT NULL,             -- labour.id
  status ENUM('todo','in_progress','completed','blocked','cancelled') DEFAULT 'todo',
  priority ENUM('low','medium','high','critical') DEFAULT 'medium',
  due_date DATE NULL,
  created_by INT NULL,              -- users.id
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE,
  FOREIGN KEY (assigned_to) REFERENCES labour(id) ON DELETE SET NULL,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;



-- Maintenance schedules for equipment
CREATE TABLE IF NOT EXISTS maintenance_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    equipment_id INT NOT NULL,
    maintenance_date DATE NOT NULL,
    maintenance_type ENUM('routine', 'repair', 'inspection', 'overhaul'),
    description TEXT,
    cost DECIMAL(10,2),
    performed_by VARCHAR(100),
    next_maintenance_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (equipment_id) REFERENCES equipment(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Crop yield tracking over time
CREATE TABLE IF NOT EXISTS crop_yield_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    crop_id INT NOT NULL,
    harvest_date DATE NOT NULL,
    yield_amount DECIMAL(10,2),
    quality_rating ENUM('poor', 'fair', 'good', 'excellent'),
    market_price DECIMAL(8,2),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- User preferences table
CREATE TABLE IF NOT EXISTS user_preferences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    preference_key VARCHAR(100) NOT NULL,
    preference_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_preference (user_id, preference_key),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Add indexes for new tables (add to existing indexes section)
CREATE INDEX IF NOT EXISTS idx_weather_farm_date ON weather_data(farm_id, record_date);
CREATE INDEX IF NOT EXISTS idx_maintenance_equipment ON maintenance_logs(equipment_id);
CREATE INDEX IF NOT EXISTS idx_yield_crop ON crop_yield_history(crop_id);
-- -----------------------
-- Indexes
-- -----------------------
CREATE INDEX IF NOT EXISTS idx_crops_farm_id ON crops(farm_id);
CREATE INDEX IF NOT EXISTS idx_livestock_farm_id ON livestock(farm_id);
CREATE INDEX IF NOT EXISTS idx_equipment_farm_id ON equipment(farm_id);
CREATE INDEX IF NOT EXISTS idx_financial_farm_id ON financial_records(farm_id);
CREATE INDEX IF NOT EXISTS idx_inventory_farm_id ON inventory(farm_id);
CREATE INDEX IF NOT EXISTS idx_reports_farm_id ON reports(farm_id);
CREATE INDEX IF NOT EXISTS idx_financial_date ON financial_records(transaction_date);
CREATE INDEX IF NOT EXISTS idx_financial_type ON financial_records(transaction_type);
CREATE INDEX IF NOT EXISTS idx_labour_farm_id ON labour(farm_id);
CREATE INDEX IF NOT EXISTS idx_tasks_farm_id ON tasks(farm_id);
CREATE INDEX IF NOT EXISTS idx_tasks_assigned_to ON tasks(assigned_to);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);

-- -----------------------
-- Sample data (parents first)
-- -----------------------

-- Users
INSERT INTO users (username, email, password_hash, role, full_name, phone) VALUES
('admin', 'admin@farm.com', 'scrypt:32768:8:1$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj8/LewdBPj8', 'admin', 'Farm Administrator', '+1234567890'),
('manager', 'manager@farm.com', 'scrypt:32768:8:1$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj8/LewdBPj8', 'manager', 'Farm Manager', '+1234567891'),
('worker', 'worker@farm.com', 'scrypt:32768:8:1$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj8/LewdBPj8', 'worker', 'Farm Worker', '+1234567892');

-- Farms
INSERT INTO farms (name, location, size_acres, owner_name, established_date, description) VALUES
('Green Valley Farm', '123 Farm Road, Rural County', 150.50, 'John Smith', '2020-01-15', 'Organic vegetable and grain farm'),
('Sunrise Ranch', '456 Ranch Lane, Countryside', 200.75, 'Jane Doe', '2018-03-20', 'Cattle and dairy operation'),
('Harvest Hills', '789 Hillside Drive, Valley', 75.25, 'Mike Johnson', '2021-06-10', 'Specialty crop farm');

-- Crops (safe: farms exist)
INSERT INTO crops (farm_id, crop_name, variety, planting_date, harvest_date, area_acres, expected_yield, actual_yield, status) VALUES
(1, 'Wheat', 'Winter Wheat', '2023-10-15', '2024-06-15', 50.0, 2500.0, 0, 'growing'),
(1, 'Corn', 'Sweet Corn', '2023-04-20', '2023-08-20', 30.0, 1500.0, 1450.0, 'harvested'),
(1, 'Tomatoes', 'Roma', '2023-03-15', '2023-07-15', 5.0, 200.0, 195.0, 'harvested'),
(2, 'Alfalfa', 'Premium', '2023-02-01', '2023-05-01', 40.0, 800.0, 750.0, 'harvested'),
(3, 'Strawberries', 'June-bearing', '2023-01-10', '2023-05-10', 10.0, 100.0, 95.0, 'harvested');

-- Livestock
INSERT INTO livestock (farm_id, animal_type, breed, tag_number, birth_date, gender, weight, health_status) VALUES
(2, 'Cattle', 'Holstein', 'C001', '2022-03-15', 'female', 450.0, 'healthy'),
(2, 'Cattle', 'Angus', 'C002', '2021-11-20', 'male', 600.0, 'healthy'),
(2, 'Cattle', 'Holstein', 'C003', '2023-01-10', 'female', 200.0, 'healthy'),
(2, 'Pig', 'Yorkshire', 'P001', '2023-02-15', 'male', 150.0, 'healthy'),
(2, 'Chicken', 'Rhode Island Red', 'CH001', '2023-03-01', 'female', 3.5, 'healthy');

-- Equipment
INSERT INTO equipment (farm_id, equipment_name, equipment_type, brand, model, purchase_date, purchase_price, condition_status, maintenance_due) VALUES
(1, 'John Deere Tractor', 'Tractor', 'John Deere', '6R Series', '2022-01-15', 85000.00, 'excellent', '2024-01-15'),
(1, 'Combine Harvester', 'Harvester', 'Case IH', 'Axial-Flow', '2021-08-20', 120000.00, 'good', '2024-02-20'),
(2, 'Milking Machine', 'Dairy Equipment', 'DeLaval', 'VMS V300', '2022-03-10', 45000.00, 'excellent', '2024-03-10'),
(3, 'Irrigation System', 'Irrigation', 'Rain Bird', 'Center Pivot', '2023-01-05', 25000.00, 'good', '2024-01-05');

-- Financial records
INSERT INTO financial_records (farm_id, transaction_type, category, description, amount, transaction_date, payment_method) VALUES
(1, 'revenue', 'Crop Sales', 'Wheat harvest sale', 15000.00, '2023-08-15', 'bank_transfer'),
(1, 'revenue', 'Crop Sales', 'Corn harvest sale', 12000.00, '2023-09-01', 'bank_transfer'),
(1, 'expense', 'Seeds', 'Wheat seeds purchase', 2500.00, '2023-09-15', 'check'),
(1, 'expense', 'Fertilizer', 'Organic fertilizer', 1800.00, '2023-10-01', 'card'),
(2, 'revenue', 'Dairy Sales', 'Milk sales for October', 8500.00, '2023-10-31', 'bank_transfer'),
(2, 'expense', 'Feed', 'Cattle feed purchase', 3200.00, '2023-10-15', 'check'),
(3, 'revenue', 'Berry Sales', 'Strawberry harvest sale', 4500.00, '2023-05-20', 'cash'),
(3, 'expense', 'Labor', 'Seasonal workers', 2800.00, '2023-05-15', 'cash');

-- Inventory
INSERT INTO inventory (farm_id, item_name, category, quantity, unit, unit_price, supplier, purchase_date, expiry_date, location) VALUES
(1, 'Wheat Seeds', 'Seeds', 100.0, 'kg', 25.00, 'Seed Co.', '2023-09-01', '2025-09-01', 'Storage Shed A'),
(1, 'Organic Fertilizer', 'Fertilizer', 50.0, 'bags', 36.00, 'Fertilizer Inc.', '2023-09-15', '2024-09-15', 'Storage Shed B'),
(2, 'Cattle Feed', 'Feed', 200.0, 'kg', 0.50, 'Feed Supply', '2023-10-01', '2024-04-01', 'Feed Storage'),
(2, 'Vaccines', 'Medical', 10.0, 'vials', 15.00, 'Vet Supply', '2023-10-10', '2024-10-10', 'Refrigerator'),
(3, 'Strawberry Plants', 'Plants', 500.0, 'plants', 2.50, 'Nursery Co.', '2023-01-05', NULL, 'Greenhouse');

-- -----------------------
-- Now insert labour (parent for tasks assigned_to)
-- -----------------------
INSERT INTO labour (farm_id, first_name, last_name, phone, role, hired_date, notes)
VALUES
  (1, 'Paul', 'Okello', '+256700000001', 'worker', '2023-03-01', 'Seasonal worker'),
  (2, 'Sarah', 'Namutebi', '+256700000002', 'supervisor', '2022-06-15', 'Head supervisor');


INSERT INTO tasks (farm_id, title, description, assigned_to, status, priority, due_date, created_by)
VALUES
  (1, 'Weed rows 2-4', 'Manual weeding. Bring hoe and gloves.', 1, 'todo', 'medium', '2025-11-01', 2),
  (2, 'Inspect milking equipment', 'Check grease points and belts.', 2, 'in_progress', 'high', '2025-10-25', 1);


INSERT INTO maintenance_logs (equipment_id, maintenance_date, maintenance_type, description, cost, performed_by, next_maintenance_date) VALUES
(1, '2024-01-10', 'routine', 'Oil change and filter replacement', 250.00, 'John Mechanic', '2024-04-10'),
(2, '2024-01-12', 'inspection', 'Annual safety inspection', 150.00, 'Farm Tech Services', '2025-01-12');

INSERT INTO crop_yield_history (crop_id, harvest_date, yield_amount, quality_rating, market_price, notes) VALUES
(2, '2023-08-20', 1450.0, 'good', 8.25, 'Good harvest despite dry spell'),
(3, '2023-07-15', 195.0, 'excellent', 12.50, 'Premium quality tomatoes');
