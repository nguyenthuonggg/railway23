DROP DATABASE IF EXISTS testing_system;
CREATE DATABASE		testing_system;
USE testing_system;

DROP TABLE IF EXISTS department;
CREATE TABLE department(
	department_id		TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,-- khoá chính thì phải thêm not null 
    department_name		VARCHAR(50)CHAR SET utf8mb4 NOT NULL 
);	
INSERT INTO department(department_name)
VALUES 	(N'Marketing'),
		(N'Sale'),
        (N'Bảo vệ'),
        (N'nhân sự'),
        (N'Kỹ thuật'),
        (N'Tài chính'),
        (N'Phó giám đốc'),
        (N'Giám đốc'),
        (N'Thư ký'),
        (N'Bán hàng');
DROP TABLE IF EXISTS `position`;
CREATE TABLE `position`(
	position_id 		TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    position_name 		ENUM('dev','test','scrum_master','pm') NOT NULL 
);
INSERT INTO `position`(position_name)
VALUES	('dev'),
		('test'),
        ('scrum_master'),
        ('pm');
        
DROP TABLE IF EXISTS `account`;
CREATE TABLE  `account`(
	account_id			TINYINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    email				VARCHAR(100) UNIQUE NOT NULL,
    user_name			VARCHAR(50) UNIQUE NOT NULL,
    full_name			VARCHAR(50) NOT NULL,
    department_id		TINYINT NOT NULL,
    position_id			TINYINT NOT NULL,
    create_date			DATE,
	FOREIGN KEY(department_id)REFERENCES department(department_id),
    FOREIGN KEY (position_id)REFERENCES `position`(position_id)
);
INSERT INTO `account`(email,user_name,full_name,department_id,position_id,create_date)
VALUES	('a@gmail.com','a','NGUYỄN VĂN A',7,4,'2021-01-01'),
		('b@gmail.com','b','NGUYỄN VĂN B',7,2,'2021-01-02'),
        ('c@gmail.com','c','NGUYỄN VĂN C',3,4,'2021-01-03'),
		('d@gmail.com','d','DƯƠNG VĂN O',2,1,'2021-01-04'),
		('e@gmail.com','e','NGUYỄN VĂN E',8,2,'2021-01-05'),
		('f@gmail.com','f','NGUYỄN VĂN F',1,4,'2021-01-06'),	
        ('g@gmail.com','g','NGUYỄN VĂN G',10,2,'2021-01-07'),
        ('h@gmail.com','h','NGUYỄN VĂN H',7,1,'2009-01-08'),
        ('i@gmail.com','i','NGUYỄN VĂN I',8,4,'2021-01-09'),
		('k@gmail.com','k','NGUYỄN VĂN K',7,2,'2021-01-10');
-- GroupID: định danh của nhóm (auto increment)
--  GroupName: tên nhóm
--  CreatorID: id của người tạo group
--  CreateDate: ngày tạo group
DROP TABLE IF EXISTS`group`;
CREATE TABLE `group`(
	group_id			TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    group_name			VARCHAR(50) CHAR SET utf8mb4 NOT NULL UNIQUE,-- unique là duy nhất 
    creator_id			TINYINT NOT NULL,
    create_date			DATE,
    FOREIGN KEY(creator_id)REFERENCES`account`(account_id)
);
INSERT INTO `group`(group_name,creator_id,create_date)
VALUES	('sale1',1,'2021-01-01'),
		('sale2',2,'2019-11-19'),
        ('sale3',3,'2021-01-03'),
        ('creator',4,'2021-01-04'),
        ('creator1',7,'2021-01-05');
        

DROP TABLE IF EXISTS group_account;
CREATE TABLE group_account(
	group_id 			TINYINT NOT NULL ,
    account_id			TINYINT NOT NULL,
    join_date			DATETIME,
    PRIMARY KEY(group_id,account_id),-- quan hệ nhiều nhiều,lấy id từ nhiều bảng  
    FOREIGN KEY (account_id)REFERENCES`account`(account_id),
    FOREIGN KEY(group_id)REFERENCES `group`(group_id)
);
INSERT INTO group_account(group_id,account_id,join_date)
VALUES	(1,4,'2021-01-01'),
		(3,7,'2021-01-02'),
        (4,8,'2021-01-03'),
        (1,2,'2021-01-04'),
        (4,3,'2021-01-05'),
        (3,4,'2021-01-06'),
        (2,9,'2021-01-07'),
        (1,7,'2021-01-08'),
        (2,6,'2021-01-09'),
        (1,9,'2021-01-10');
DROP TABLE IF EXISTS type_question;
CREATE TABLE type_question(
	type_id				TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    type_name			ENUM('essay','Multiple-Choice')NOT NULL
);
INSERT INTO type_question(type_name)
VALUES	('Multiple-Choice'),
		('Multiple-Choice'),
        ('essay'),
        ('Multiple-Choice'),
        ('essay'),
        ('essay'),
        ('Multiple-Choice'),
        ('essay'),
        ('Multiple-Choice'),
        ('essay');
DROP TABLE IF EXISTS category_question;
CREATE TABLE category_question(
	category_id			TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    category_name		VARCHAR(50) CHAR SET utf8mb4 NOT NULL UNIQUE
); 
INSERT INTO category_question(category_name)
VALUES	('toán số'), 
		('toán hình'),
        ('vật lý'),
        ('hoá học'),
        ('tiếng anh'),
		('ngữ văn'),
        ('địa lý'),
        ('lịch sử'),
        ('sinh học'),
        ('tin học');
DROP TABLE IF EXISTS question;
CREATE TABLE question(
	question_id			TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    content				VARCHAR(200)CHAR SET utf8mb4 NOT NULL,
    category_id			TINYINT NOT NULL,
    type_id				TINYINT NOT NULL,
    creator_id			TINYINT NOT NULL,
    create_date			DATETIME,
    FOREIGN KEY(category_id)REFERENCES category_question(category_id),
    FOREIGN KEY(type_id)REFERENCES type_question(type_id),
    FOREIGN KEY(creator_id)REFERENCES `account`(account_id)
);
INSERT INTO	question(content,category_id,type_id,creator_id,create_date)
VALUES	('hỏi về số học',1,3,1,'2021-05-01'),
		('hỏi về hình học',3,2,4,'2021-05-02'),
        ('câu hỏi về vậy lý',3,4,3,'2021-05-03'),
        ('hỏi về hoá học',1,2,3,'2021-05-04'),
        ('hỏi về tiếng anh',4,3,2,'2021-05-05');
DROP TABLE IF EXISTS answer;
CREATE TABLE answer(
	answer_id			TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    content				VARCHAR(100)CHAR SET utf8mb4 NOT NULL,
    question_id			TINYINT NOT NULL,
    is_correct			BOOLEAN, -- đúng hoặc sai la 0 và 1
    FOREIGN KEY(question_id)REFERENCES question(question_id)
);
INSERT INTO answer(content,question_id,is_correct)
VALUES	('trả lời câu hỏi về số học',1,'0'),
		('trả lời câu hỏi về hình học',5,'1'),
        ('trả lời câu hỏi về vật lý',2,'0'),
        ('trả lời câu hỏi về hoá học',3,'0'),
        ('trả lời câu hỏi về tiếng anh',2,'0');
DROP TABLE IF EXISTS exam;
CREATE TABLE exam(
	exam_id				TINYINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    `code`				VARCHAR(20) UNIQUE NOT NULL,
    title				VARCHAR(20) CHAR SET utf8mb4 NOT NULL,
    category_id			TINYINT NOT NULL,
    duration			ENUM('60','45','90','15','30')NOT NULL,
	creator_id			TINYINT NOT NULL,
    create_date			DATE,
    FOREIGN KEY(category_id)REFERENCES category_question(category_id),
    FOREIGN KEY(creator_id)REFERENCES`account`(account_id)
);
INSERT INTO exam(`code`,title,category_id,duration,creator_id,create_date)
VALUES	('AAA001','đề thi toán số',1,'15',3,'2021-07-01'),
		('AAA002','đề thi toán hình',2,'30',3,'2021-07-02'),
        ('AAA003','đề thi vậy lý',3,'60',2,'2019-11-11'),
        ('AAA004','đề thi hoá học',3,'90',2,'2021-07-04'),
        ('AAA005','đề thi tiếng anh',1,'45',4,'2021-07-05');
DROP TABLE IF EXISTS exam_question;     
CREATE TABLE exam_question(
	exam_id				TINYINT NOT NULL ,
    question_id			TINYINT NOT NULL,
    PRIMARY KEY(exam_id, question_id),
    FOREIGN KEY(exam_id)REFERENCES exam(exam_id) ON DELETE CASCADE ,
	FOREIGN KEY(question_id)REFERENCES question(question_id)
);
INSERT INTO exam_question(exam_id,question_id)
VALUES	(1,2),
		(3,4),
        (2,1),
        (2,2),
        (2,3);