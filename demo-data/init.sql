-- Create a sample table
CREATE TABLE IF NOT EXISTS sales_data (
    order_id SERIAL PRIMARY KEY,
    order_date DATE NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    sales_amount DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL
);

-- Insert dummy data
INSERT INTO sales_data (order_date, product_name, category, sales_amount, quantity) VALUES
('2024-01-15', 'Laptop Pro', 'Electronics', 1200.00, 1),
('2024-01-16', 'Wireless Mouse', 'Accessories', 25.50, 2),
('2024-01-18', 'Ergonomic Chair', 'Furniture', 250.00, 1),
('2024-02-05', 'Mechanical Keyboard', 'Accessories', 130.00, 1),
('2024-02-10', 'Monitor 27-inch', 'Electronics', 300.00, 2),
('2024-02-14', 'Desk Lamp', 'Furniture', 45.00, 1),
('2024-03-01', 'Laptop Pro', 'Electronics', 1200.00, 1),
('2024-03-10', 'Standing Desk', 'Furniture', 600.00, 1),
('2024-03-15', 'Webcam 1080p', 'Electronics', 60.00, 3);
