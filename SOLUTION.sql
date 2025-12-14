-- السؤال الاول
CREATE TABLE employee (
    ID INT PRIMARY KEY,
    person_name VARCHAR(50),
    street VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE company (
    company_name VARCHAR(50) PRIMARY KEY,
    city VARCHAR(50)
);

CREATE TABLE works (
    ID INT,
    company_name VARCHAR(50),
    salary DECIMAL(10,2),
    PRIMARY KEY (ID, company_name),
    FOREIGN KEY (ID) REFERENCES employee(ID),
    FOREIGN KEY (company_name) REFERENCES company(company_name)
);

CREATE TABLE manages (
    ID INT PRIMARY KEY,
    manager_id INT,
    FOREIGN KEY (ID) REFERENCES employee(ID),
    FOREIGN KEY (manager_id) REFERENCES employee(ID)
);

--السؤال الثاني:
--انشاء قاعدة البيانات والجداول 
CREATE DATABASE bank;

-- لاستخدم قاعدة البيانات
USE bank;

-- جدول الفروع
CREATE TABLE branch (
    branch_name VARCHAR(50) PRIMARY KEY,
    branch_city VARCHAR(50),
    assets DECIMAL(15,2)
);

-- جدول العملاء
CREATE TABLE customer (
    ID VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(50),
    customer_street VARCHAR(50),
    customer_city VARCHAR(50)
);

-- جدول القروض
CREATE TABLE loan (
    loan_number VARCHAR(10) PRIMARY KEY,
    branch_name VARCHAR(50),
    amount DECIMAL(15,2),
    FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

-- جدول المقترضين
CREATE TABLE borrower (
    ID VARCHAR(10),
    loan_number VARCHAR(10),
    PRIMARY KEY (ID, loan_number),
    FOREIGN KEY (ID) REFERENCES customer(ID),
    FOREIGN KEY (loan_number) REFERENCES loan(loan_number)
);

-- جدول الحسابات
CREATE TABLE account (
    account_number VARCHAR(10) PRIMARY KEY,
    branch_name VARCHAR(50),
    balance DECIMAL(15,2),
    FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

-- جدول المودعين
CREATE TABLE depositor (
    ID VARCHAR(10),
    account_number VARCHAR(10),
    PRIMARY KEY (ID, account_number),
    FOREIGN KEY (ID) REFERENCES customer(ID),
    FOREIGN KEY (account_number) REFERENCES account(account_number)
);

--حل السؤال الثاني بعد انشاء قاعدة البيانات والجداول
--A
SELECT DISTINCT d.ID
FROM depositor d
WHERE d.ID NOT IN (
    SELECT b.ID
    FROM borrower b
);

--B
SELECT c2.ID
FROM customer c1, customer c2
WHERE c1.ID = '12345'
  AND c1.customer_street = c2.customer_street
  AND c1.customer_city = c2.customer_city
  AND c2.ID <> '12345';

  --C
  SELECT DISTINCT b.branch_name
FROM branch b
JOIN account a ON b.branch_name = a.branch_name
JOIN depositor d ON a.account_number = d.account_number
JOIN customer c ON d.ID = c.ID
WHERE c.customer_city = 'Harrison';

--السوال الثالث
--انشاء قاعدة البيانات والجداول
-- أنشئ قاعدة بيانات للسؤال الثالث
CREATE DATABASE homework_q3;

-- استخدم قاعدة البيانات
USE homework_q3;

-- جدول الطلب اليومي (Q3-A)
CREATE TABLE demand (
    day INT PRIMARY KEY,
    qty INT NOT NULL
);

-- جدول المبيعات لكل منتج حسب اليوم (Q3-B)
CREATE TABLE sales (
    product VARCHAR(10) NOT NULL,
    day INT NOT NULL,
    qty INT NOT NULL,
    PRIMARY KEY (product, day)
);

--وادخل البيانات في الجدول :
-- بيانات demand لجزء A
INSERT INTO demand (day, qty) VALUES
(1, 10),
(2, 6),
(3, 21),
(4, 9),
(6, 12),
(7, 18),
(8, 3),
(9, 6),
(10, 23);

-- بيانات sales لجزء B
INSERT INTO sales (product, day, qty) VALUES
('A', 1, 10),
('A', 2, 6),
('A', 3, 21),
('A', 4, 9),
('A', 5, 19),
('B', 1, 12),
('B', 2, 18),
('B', 3, 3),
('B', 4, 6),
('B', 5, 23);

-- حل السوال الثالث بعد ان عملت قاعدة البيانات والجداول وادحلت البيانات:
--A
SELECT
    day,
    qty,
    SUM(qty) OVER (ORDER BY day) AS cumQty
FROM demand
ORDER BY day;

--B
WITH ranked AS (
    SELECT
        product,
        day,
        qty,
        ROW_NUMBER() OVER (
            PARTITION BY product
            ORDER BY qty ASC, day ASC
        ) AS rn
    FROM sales
)
SELECT
    product,
    day,
    qty,
    rn AS RN
FROM ranked
WHERE rn <= 2
ORDER BY product, rn;
