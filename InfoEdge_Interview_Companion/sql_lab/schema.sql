-- MiniNaukri: a tiny job-portal database used by every query in Part IX.
-- Runs as-is in SQLite (Python's sqlite3, Colab), PostgreSQL and MySQL 8.

DROP TABLE IF EXISTS impressions;
DROP TABLE IF EXISTS logins;
DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS jobs;
DROP TABLE IF EXISTS candidates;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS employees;

CREATE TABLE companies (
  company_id  INTEGER PRIMARY KEY,
  name        VARCHAR(30) NOT NULL,
  city        VARCHAR(20),
  industry    VARCHAR(20),
  size        VARCHAR(10)
);
INSERT INTO companies VALUES
 (1, 'DataNest',  'Bengaluru', 'IT',          'large'),
 (2, 'PayWave',   'Mumbai',    'Fintech',     'mid'),
 (3, 'MediCore',  'Pune',      'Healthcare',  'small'),
 (4, 'ShopKart',  'Bengaluru', 'E-commerce',  'large'),
 (5, 'EduSpark',  'Noida',     'Edtech',      'mid'),
 (6, 'GreenGrid', 'Delhi',     'Energy',      'small');

CREATE TABLE candidates (
  cand_id      INTEGER PRIMARY KEY,
  name         VARCHAR(20) NOT NULL,
  city         VARCHAR(20),          -- NULL = not filled in
  exp_yrs      INTEGER,
  ctc_lpa      DECIMAL(5,1),         -- current salary, lakh per annum; NULL for freshers
  signup_date  DATE,
  referred_by  INTEGER REFERENCES candidates(cand_id)
);
INSERT INTO candidates VALUES
 (101, 'Aarav',   'Bengaluru',  2,  8.0, '2026-01-05', NULL),
 (102, 'Diya',    'Mumbai',     5, 18.0, '2026-01-07', 101),
 (103, 'Kabir',   'Delhi',      0, NULL, '2026-01-10', NULL),
 (104, 'Meera',   'Bengaluru',  7, 30.0, '2026-01-12', 102),
 (105, 'Rohan',   'Pune',       3, 12.0, '2026-02-01', 101),
 (106, 'Sana',    NULL,         1,  5.5, '2026-02-03', NULL),
 (107, 'Vikram',  'Noida',     10, 42.0, '2026-02-15', 104),
 (108, 'Ananya',  'Mumbai',     4, 15.0, '2026-02-20', NULL),
 (109, 'Ishaan',  'Bengaluru',  2,  9.5, '2026-03-02', 105),
 (110, 'Priya',   'Delhi',      6, 24.0, '2026-03-05', NULL);

CREATE TABLE jobs (
  job_id       INTEGER PRIMARY KEY,
  company_id   INTEGER NOT NULL REFERENCES companies(company_id),
  title        VARCHAR(30),
  city         VARCHAR(20),
  min_exp      INTEGER,
  max_ctc_lpa  DECIMAL(5,1),
  posted_date  DATE
);
INSERT INTO jobs VALUES
 (201, 1, 'Data Scientist', 'Bengaluru', 2, 20, '2026-01-15'),
 (202, 1, 'ML Engineer',    'Bengaluru', 4, 35, '2026-01-20'),
 (203, 2, 'Data Analyst',   'Mumbai',    1, 12, '2026-01-25'),
 (204, 2, 'Data Scientist', 'Mumbai',    3, 25, '2026-02-05'),
 (205, 3, 'Data Analyst',   'Pune',      0,  8, '2026-02-10'),
 (206, 4, 'Data Scientist', 'Bengaluru', 5, 40, '2026-02-12'),
 (207, 4, 'Data Analyst',   'Bengaluru', 1, 10, '2026-02-18'),
 (208, 5, 'ML Engineer',    'Noida',     6, 45, '2026-03-01'),
 (209, 5, 'Data Scientist', 'Noida',     2, 18, '2026-03-04'),
 (210, 3, 'ML Engineer',    'Hyderabad', 3, 22, '2026-03-10');

CREATE TABLE applications (
  app_id        INTEGER PRIMARY KEY,
  cand_id       INTEGER NOT NULL REFERENCES candidates(cand_id),
  job_id        INTEGER NOT NULL REFERENCES jobs(job_id),
  applied_date  DATE,
  status        VARCHAR(12)   -- applied / shortlisted / interview / offer / rejected
);
INSERT INTO applications VALUES
 ( 1, 101, 201, '2026-01-16', 'interview'),
 ( 2, 101, 207, '2026-02-19', 'offer'),
 ( 3, 101, 209, '2026-03-05', 'applied'),
 ( 4, 102, 203, '2026-01-26', 'rejected'),
 ( 5, 102, 204, '2026-02-06', 'offer'),
 ( 6, 102, 201, '2026-01-18', 'shortlisted'),
 ( 7, 103, 205, '2026-02-11', 'shortlisted'),
 ( 8, 103, 203, '2026-01-27', 'rejected'),
 ( 9, 103, 207, '2026-02-19', 'applied'),
 (10, 104, 202, '2026-01-21', 'offer'),
 (11, 104, 206, '2026-02-13', 'interview'),
 (12, 105, 204, '2026-02-07', 'interview'),
 (13, 105, 205, '2026-02-11', 'rejected'),
 (14, 105, 201, '2026-02-02', 'applied'),
 (15, 107, 208, '2026-03-02', 'offer'),
 (16, 107, 206, '2026-02-16', 'rejected'),
 (17, 108, 203, '2026-02-21', 'interview'),
 (18, 108, 204, '2026-02-22', 'shortlisted'),
 (19, 109, 201, '2026-03-03', 'applied'),
 (20, 109, 209, '2026-03-05', 'shortlisted'),
 (21, 109, 207, '2026-03-03', 'rejected'),
 (22, 101, 201, '2026-01-16', 'interview'),   -- accidental duplicate of app 1
 (23, 104, 208, '2026-03-02', 'applied');

CREATE TABLE logins (
  cand_id     INTEGER REFERENCES candidates(cand_id),
  login_date  DATE
);
INSERT INTO logins VALUES
 (101,'2026-03-01'),(101,'2026-03-02'),(101,'2026-03-03'),(101,'2026-03-05'),(101,'2026-03-06'),
 (102,'2026-03-01'),(102,'2026-03-03'),
 (104,'2026-03-02'),(104,'2026-03-03'),(104,'2026-03-04'),(104,'2026-03-05'),
 (105,'2026-03-01'),
 (107,'2026-03-04'),(107,'2026-03-05'),(107,'2026-03-06'),
 (109,'2026-03-03'),(109,'2026-03-04'),(109,'2026-03-04');   -- 109 logged in twice on 03-04

CREATE TABLE impressions (            -- a job card shown to a candidate in an A/B test
  imp_id      INTEGER PRIMARY KEY,
  cand_id     INTEGER,
  job_id      INTEGER,
  shown_date  DATE,
  variant     CHAR(1),                -- 'A' = old ranking, 'B' = new ranking
  clicked     INTEGER                 -- 1 = clicked, 0 = not
);
INSERT INTO impressions VALUES
 ( 1,101,201,'2026-03-01','A',1),( 2,101,202,'2026-03-01','A',0),( 3,102,204,'2026-03-01','B',1),
 ( 4,102,203,'2026-03-01','B',0),( 5,103,205,'2026-03-02','A',0),( 6,103,207,'2026-03-02','A',0),
 ( 7,104,206,'2026-03-02','B',1),( 8,104,208,'2026-03-02','B',1),( 9,105,204,'2026-03-02','A',1),
 (10,105,210,'2026-03-03','A',0),(11,107,208,'2026-03-03','B',1),(12,107,206,'2026-03-03','B',0),
 (13,108,203,'2026-03-03','A',0),(14,108,204,'2026-03-03','A',0),(15,109,209,'2026-03-03','B',1),
 (16,109,207,'2026-03-03','B',0);

CREATE TABLE employees (               -- InfoEdge-style internal team table for the classics
  emp_id      INTEGER PRIMARY KEY,
  name        VARCHAR(20),
  dept        VARCHAR(20),
  salary      INTEGER,                 -- lakh per annum; NULL = not yet entered
  manager_id  INTEGER REFERENCES employees(emp_id),
  hire_date   DATE
);
INSERT INTO employees VALUES
 ( 1,'Neha',  'Leadership',  90, NULL,'2018-04-01'),
 ( 2,'Arjun', 'DataScience', 60, 1,   '2019-06-15'),
 ( 3,'Kavya', 'DataScience', 45, 2,   '2021-01-10'),
 ( 4,'Manav', 'DataScience', 45, 2,   '2022-03-01'),
 ( 5,'Tara',  'DataScience', 30, 2,   '2024-07-01'),
 ( 6,'Rahul', 'Engineering', 70, 1,   '2019-02-20'),
 ( 7,'Sneha', 'Engineering', 50, 6,   '2020-08-05'),
 ( 8,'Yash',  'Engineering', 75, 6,   '2023-05-12'),
 ( 9,'Pooja', 'Sales',       40, 1,   '2020-11-30'),
 (10,'Dev',   'Sales',       25, 9,   '2025-01-15'),
 (11,'Zoya',  'Sales',     NULL, 9,   '2026-01-05');
