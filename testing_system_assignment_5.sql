-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
select * from `account`;
select * from department;
DROP VIEW IF EXISTS danh_sach_nhan_vien;
CREATE VIEW danh_sach_nhan_vien AS
	select a.*,d.department_name
    from `account`a
    join department d on a.department_id=d.department_id
    where d.department_name = 'sale';
SELECT * FROM danh_sach_nhan_vien;

-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
-- đến group by theo người
select * from `account`;
select * from group_account;
DROP VIEW IF EXISTS nhan_vien;
CREATE OR REPLACE VIEW nhan_vien AS 
	SELECT a.full_name,COUNT(ga.group_id) AS nhom_nhieu_thanh_vien
    FROM group_account ga
    JOIN `account` a ON ga.account_id=a.account_id
    GROUP BY a.account_id
    HAVING COUNT(ga.group_id)=
		(SELECT MAX(so_nhan_vien) AS so_nhan_vien_nhieu_nhat
        FROM(SELECT ga.group_id,account_id,COUNT(ga.group_id) AS so_nhan_vien
        FROM group_account ga
        GROUP BY ga.account_id) AS nhom);
SELECT * FROM nhan_vien
-- Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ
-- được coi là quá dài) và xóa nó đi
DROP VIEW IF EXISTS content_300_word;
CREATE OR REPLACE VIEW content_300_word AS
	SELECT content,(LENGTH(content) - LENGTH(REPLACE(content,'',''))+1) AS word_count
    FROM question
    WHERE LENGTH(content) - LENGTH(REPLACE(content,'',''))+1 > 300;
    SELECT * FROM content_300_word;
    DELETE FROM content_300_word;

-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
DROP VIEW IF EXISTS nhieu_nhan_vien_nhat;
CREATE OR REPLACE VIEW nhieu_nhan_vien_nhat AS
	WITH 
    nhan_vien_phong_ban AS(
		SELECT d.department_name,COUNT(a.account_id) AS acc_count
        FROM department d
        JOIN `account` a ON d.department_id= a.department_id
        GROUP BY d.department_id)
	SELECT *
	FROM  nhan_vien_phong_ban
    WHERE acc_count = (
		SELECT MAX(acc_count)
        FROM nhan_vien_phong_ban
	);
SELECT * FROM nhieu_nhan_vien_nhat;
-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo
select *from question;

DROP VIEW IF EXISTS question_from_nguyen;
CREATE VIEW question_from_nguyen AS
	SELECT GROUP_CONCAT(q.content), a.full_name -- group concat là để nối nhiều giá trị của các record trong cột
    FROM question q
    JOIN `account` a ON q.creator_id = a.account_id
    GROUP BY q.creator_id
    HAVING a.full_name LIKE 'Nguyễn%';
SELECT * FROM question_from_nguyen;
    
    
