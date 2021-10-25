-- câu 1 Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT a.full_name, d.department_id, d.department_name
FROM `account`a
JOIN department d ON a.department_id=d.department_id;

SELECT * FROM `account`;
SELECT * FROM department;

-- Câu 2 Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010 
SELECT *
FROM `account`
WHERE create_date > '2010-12-20';

-- câu 3 Viết lệnh để lấy ra tất cả các developer
SELECT full_name
FROM `account`a
INNER JOIN `position`p ON a.position_id=p.position_id
WHERE p.position_name='dev' ;

SHOW TABLES;
SELECT * from `account`;
select * from  `position`;

-- câu 4 Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
SELECT d.department_name
FROM `account`a
INNER JOIN department d ON a.department_id=d.department_id
GROUP BY a.department_id
HAVING COUNT(a.account_id)>3;

-- Câu 5 Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
select * from exam_question;
select * from question;

SELECT q.*, COUNT(eq.exam_id) AS 'số bài thi'
FROM question q
JOIN exam_question eq ON q.question_id = eq.question_id
GROUP BY q.question_id
HAVING COUNT(eq.exam_id) = (
	SELECT MAX(exam_count)
    FROM(
		SELECT COUNT(exam_id) AS exam_count
        FROM exam_question 
        GROUP BY question_id
	)AS t1
);

-- Câu 6 Thông kê mỗi Category Question được sử dụng trong bao nhiêu Question  nghĩa là nhóm 
SELECT cq.category_name, COUNT(q.question_id) AS 'số lần đc sử dụng'
FROM question q
RIGHT JOIN category_question cq ON cq.category_id=q.category_id
GROUP BY cq.category_id;
-- Câu 7 Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT q.question_id,q.content,COUNT(eq.question_id)
FROM exam_question eq
RIGHT JOIN question q ON q.question_id=eq.question_id
GROUP BY q.question_id;
-- Câu 8 Lấy ra Question có nhiều câu trả lời nhất
SELECT q.content, COUNT(ans.answer_id) AS 'số câu trả lời'
FROM question q
	JOIN answer ans ON q.question_id = ans.question_id
    GROUP BY ans.question_id
    HAVING COUNT(ans.answer_id) = (
		SELECT MAX(answer_count) 
        FROM(
			SELECT question_id, COUNT(answer_id) AS answer_count
            FROM answer
            Group BY question_id
		) AS t2
	);
    
-- Câu 9 Thống kê số lượng account trong mỗi group
SELECT g.group_name,COUNT(ga.account_id) AS 'so luong'
FROM group_account ga
RIGHT JOIN `group`g ON ga.group_id=g.group_id
GROUP BY g.group_id;
-- Câu 10: Tìm chức vụ có ít người nhất
select * from `account`;
select * from `position`;
SELECT p.position_name,COUNT(a.account_id) 'so luong ng trong phong ban nay'
FROM`position` p LEFT JOIN `account`a ON p.position_id=a.position_id
GROUP BY p.position_id
HAVING COUNT(a.account_id)=
	(SELECT MIN(account_count)
		FROM(SELECT p.position_id, COUNT(a.account_id) AS account_count
			FROM `account`a RIGHT JOIN `position`p ON a.position_id = p.position_id-- dùng right vì có thể có giá trị = 0 
				GROUP BY position_id) AS temp);
	
-- Câu 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
SELECT d.department_id,d.department_name,p.position_name,COUNT(a.account_id)'so luong nv'
FROM department d
LEFT JOIN `account`a ON d.department_id=a.department_id
LEFT JOIN `position`p ON a.position_id=p.position_id
GROUP BY d.department_id,p.position_id;

-- Câu 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của
-- question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, ...

SELECT 	q.question_id,q.content'cau hoi',
		t.type_name'dang cau hoi',
        a.full_name'nguoi tao', 
        an.content'tra loi',
        cq.category_name'loai cau hoi'
FROM question q
LEFT JOIN type_question t ON q.type_id=t.type_id
LEFT JOIN `account` a ON q.creator_id=a.account_id
LEFT JOIN answer an ON q.question_id = an.question_id
LEFT JOIN category_question cq ON cq.category_id=q.category_id;

-- Câu 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT type_name, COUNT(tq.type_id) AS 'Số lượng câu hỏi'
FROM type_question tq
JOIN question q ON q.type_id=tq.type_id
GROUP BY tq.type_id;

-- Câu 14:Lấy ra group không có account nào sử dụng left join
SELECT g.group_id,g.group_name
FROM `group`g
LEFT JOIN group_account ga ON g.group_id=ga.group_id
WHERE ga.group_id IS NULL;

-- Câu 16: Lấy ra question không có answer nào
SELECT q.question_id
FROM answer a
RIGHT JOIN question q ON a.question_id=q.question_id
WHERE a.answer_id IS NULL;

-- Question 17:
-- a) Lấy các account thuộc nhóm thứ 1
SELECT a.full_name, ga.group_id
FROM `account` a
JOIN group_account ga ON a.account_id=ga.account_id
WHERE ga.group_id=1;
-- b) Lấy các account thuộc nhóm thứ 2
SELECT a.full_name, ga.group_id
FROM `account` a
JOIN group_account ga ON a.account_id=ga.account_id
WHERE ga.group_id=2;
-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau
SELECT a.full_name 
FROM `account` a
JOIN group_account ga ON a.account_id=ga.account_id
WHERE ga.group_id=1
UNION
SELECT a.full_name 
FROM `account` a
JOIN group_account ga ON a.account_id=ga.account_id
WHERE ga.group_id=2;
-- Question 18:
-- a) Lấy các group có lớn hơn 5 thành viên
SELECT g.group_id, COUNT(ga.account_id) AS 'số thành viên trong nhóm' 
FROM `group` g JOIN group_account ga ON g.group_id = ga.group_id
GROUP BY g.group_id
HAVING COUNT(ga.account_id) > 5;
-- b) Lấy các group có nhỏ hơn 7 thành viên
SELECT g.group_id, COUNT(ga.account_id) AS 'số thành viên trong nhóm' 
FROM `group` g LEFT JOIN group_account ga ON g.group_id = ga.group_id
GROUP BY g.group_id
HAVING COUNT(ga.account_id) < 7;
-- c) Ghép 2 kết quả từ câu a) và câu b)
SELECT g.group_id, COUNT(ga.account_id) AS 'số thành viên trong nhóm' 
FROM `group` g JOIN group_account ga ON g.group_id = ga.group_id
GROUP BY g.group_id
HAVING COUNT(ga.account_id) > 5
	UNION ALL
SELECT g.group_id, COUNT(ga.account_id) AS 'số thành viên trong nhóm' 
FROM `group` g LEFT JOIN group_account ga ON g.group_id = ga.group_id
GROUP BY g.group_id
HAVING COUNT(ga.account_id) < 7;