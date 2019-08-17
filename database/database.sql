-- phpMyAdmin SQL Dump
-- version 4.6.6deb5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 18, 2019 at 12:15 AM
-- Server version: 5.7.27-0ubuntu0.18.04.1
-- PHP Version: 7.2.17-0ubuntu0.18.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `codepad`
--

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `cid` int(11) NOT NULL,
  `cname` varchar(255) DEFAULT NULL,
  `clang` varchar(255) NOT NULL DEFAULT 'all'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`cid`, `cname`, `clang`) VALUES
(1, 'C', 'c'),
(3, 'Java', 'java'),
(4, 'Python', 'python'),
(6, 'C++', 'cpp'),
(7, 'Data Structure', 'all'),
(8, 'Algorithms', 'all'),
(9, 'Mathematics', 'all');

-- --------------------------------------------------------

--
-- Table structure for table `dept`
--

CREATE TABLE `dept` (
  `dept_id` int(11) NOT NULL,
  `dept_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `dept`
--

INSERT INTO `dept` (`dept_id`, `dept_name`) VALUES
(1, 'AEIE'),
(2, 'CE'),
(3, 'CSE'),
(4, 'ECE'),
(5, 'EE'),
(6, 'IT'),
(7, 'ME'),
(8, 'BCA'),
(9, 'MCA'),
(10, 'BBA');

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `qid` int(11) UNSIGNED NOT NULL,
  `qtitle` varchar(255) DEFAULT NULL,
  `qstatement` text,
  `qtc_public` int(11) DEFAULT NULL,
  `qtc_private` int(11) DEFAULT NULL,
  `qmarks` int(11) DEFAULT NULL,
  `scid` int(11) DEFAULT NULL,
  `tid` int(11) UNSIGNED DEFAULT NULL,
  `uploaded` tinyint(1) NOT NULL DEFAULT '0',
  `code_lang` varchar(255) DEFAULT NULL,
  `code` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`qid`, `qtitle`, `qstatement`, `qtc_public`, `qtc_private`, `qmarks`, `scid`, `tid`, `uploaded`, `code_lang`, `code`) VALUES
(1, 'Prime', '<p>Write a program to test whether a natural number is prime or not. If the number is prime then print &quot;Prime&quot; else print &quot;Not prime&quot;.</p>', 2, 8, 100, 4, NULL, 1, 'c', '#include<stdio.h>\r\n#include<math.h>\r\n\r\nint main(){\r\n	int n, c = 2, i;\r\n\r\n	scanf(\"%d\", &n);\r\n\r\n	if(n < 2)		c = 1;\r\n	else			for(i = 2; i <= sqrt(n); i++)	if(n % i == 0)	{c++; break;}\r\n\r\n	if(c == 2)		printf(\"Prime\");\r\n	else			printf(\"Not prime\");\r\n\r\n	return 0;\r\n}'),
(3, 'Magic number', '<p>Write a program to check whether a number is a magic number or not. A magic number is one whose repeated sum of digits results in the number 1.</p><p><br />\r\n	For example:</p>\r\n<pre>\r\n<code>\r\nn = 1720\r\nFirst sum of digits = 1 + 7 + 2 + 0 = 10\r\nNow, n = 10\r\nSecond sum of digits = 1 + 0 = 1\r\nHence, 1720 is a magic number.\r\n</code>\r\n</pre>\r\n\r\n<p>If the number is magic number then print &quot;Magic&quot; else print &quot;Not magic&quot;.</p>', 2, 4, 100, 4, NULL, 1, 'c', '#include<stdio.h>\r\n\r\nint sod(int n){\r\n	int sum = 0;\r\n	while(n != 0){\r\n		int p = n % 10;\r\n		sum += p;\r\n		n /= 10;\r\n	}\r\n	return sum;\r\n}\r\n\r\nint main(){\r\n	int n;\r\n	scanf(\"%d\", &n);\r\n\r\n	while(n > 9)	n = sod(n);\r\n\r\n	if(n == 1)		printf(\"Magic\");\r\n	else			printf(\"Not magic\");\r\n	\r\n	return 0;\r\n}'),
(4, 'Introduction to coding', '<p>Write a program which takes a single line input and prints it .</p>', 1, 1, 50, 22, NULL, 1, 'c', NULL),
(5, 'Odd even', '<p>Write a program to check whether a number is even or odd.</p>', 2, 5, 30, 22, NULL, 1, 'c', NULL),
(6, 'Prime check', '<p>Write a program to test whether a natural number is prime or not prime. If the number is prime then print &quot;Prime&quot; else print &quot;Not prime&quot;.</p>', 2, 8, 10, NULL, 3, 1, 'c', '#include<stdio.h>\n#include<math.h>\n\nint main(){\n	int n, c = 2, i;\n\n	scanf(\"%d\", &n);\n\n	if(n < 2)		c = 1;\n	else			for(i = 2; i <= sqrt(n); i++)	if(n % i == 0)	{c++; break;}\n\n	if(c == 2)		printf(\"Prime\");\n	else			printf(\"Not prime\");\n\n	return 0;\n}');

-- --------------------------------------------------------

--
-- Table structure for table `score`
--

CREATE TABLE `score` (
  `username` varchar(255) NOT NULL,
  `cid` int(11) NOT NULL,
  `marks` int(11) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `score`
--

INSERT INTO `score` (`username`, `cid`, `marks`) VALUES
('root', 1, 200),
('root', 8, 50);

-- --------------------------------------------------------

--
-- Table structure for table `subcategory`
--

CREATE TABLE `subcategory` (
  `scid` int(11) NOT NULL,
  `scname` varchar(255) DEFAULT NULL,
  `cid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `subcategory`
--

INSERT INTO `subcategory` (`scid`, `scname`, `cid`) VALUES
(2, 'Pointer', 1),
(4, 'Loops', 1),
(5, 'Structure & Union', 1),
(6, 'Strings', 3),
(7, 'Exploring java.util', 3),
(8, 'Lists', 4),
(9, 'Dictionary', 4),
(10, 'Vector', 6),
(11, 'Array', 7),
(12, 'Stack', 7),
(13, 'Queue', 7),
(14, 'Tree', 7),
(15, 'Linked List', 7),
(16, 'Greedy Approach', 8),
(17, 'Dynamic Programming', 8),
(18, 'Sorting', 8),
(20, 'Divide and Conquer', 8),
(22, 'Basic Implementation', 8),
(26, 'Backtracking', 8);

-- --------------------------------------------------------

--
-- Table structure for table `submissions`
--

CREATE TABLE `submissions` (
  `username` varchar(255) NOT NULL,
  `qid` int(10) UNSIGNED NOT NULL,
  `time_solved` bigint(20) UNSIGNED NOT NULL,
  `lang` varchar(255) DEFAULT NULL,
  `passed_tc` int(11) DEFAULT NULL,
  `qcode` text,
  `solved` tinyint(1) DEFAULT '0',
  `exec_time` int(10) UNSIGNED DEFAULT NULL,
  `exec_mem` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `submissions`
--

INSERT INTO `submissions` (`username`, `qid`, `time_solved`, `lang`, `passed_tc`, `qcode`, `solved`, `exec_time`, `exec_mem`) VALUES
('root', 1, 1556559450270, 'c', 8, '#include<stdio.h>\n#include<math.h>\n\nint main(){\n	int n, c = 2, i;\n\n	scanf(\"%d\", &n);\n\n	if(n < 2)		c = 1;\n	else			for(i = 2; i <= sqrt(n); i++)	if(n % i == 0)	{c++; break;}\n\n	if(c == 2)		printf(\"Prime\");\n	else			printf(\"Not prime\");\n\n	return 0;\n}', 1, 1, 2093056),
('root', 3, 1555797561489, 'c', 4, '#include<stdio.h>\n\nint sod(int n){\n	int sum = 0;\n	while(n != 0){\n		int p = n % 10;\n		sum += p;\n		n /= 10;\n	}\n	return sum;\n}\n\nint main(){\n	int n;\n	scanf(\"%d\", &n);\n\n	while(n > 9)	n = sod(n);\n\n	if(n == 1)		printf(\"Magic\");\n	else			printf(\"Not magic\");\n	\n	return 0;\n}', 1, 1, 1662976),
('root', 3, 1556464661242, 'c', 4, '#include<stdio.h>\n\nint sod(int n){\n	int sum = 0;\n	while(n != 0){\n		int p = n % 10;\n		sum += p;\n		n /= 10;\n	}\n	return sum;\n}\n\nint main(){\n	int n;\n	scanf(\"%d\", &n);\n\n	while(n > 9)	n = sod(n);\n\n	if(n == 1)		printf(\"Magic\");\n	else			printf(\"Not magic\");\n	\n	return 0;\n}', 1, 1, 1658880),
('root', 3, 1566064506098, 'c', 4, '#include<stdio.h>\n\nint sod(int n){\n	int sum = 0;\n	while(n != 0){\n		int p = n % 10;\n		sum += p;\n		n /= 10;\n	}\n	return sum;\n}\n\nint main(){\n	int n;\n	scanf(\"%d\", &n);\n\n	while(n > 9)	n = sod(n);\n\n	if(n == 1)		printf(\"Magic\");\n	else			printf(\"Not magic\");\n	\n	return 0;\n}', 1, 1, 1654784),
('root', 4, 1556274169745, 'python', 1, 'print(input())', 1, 31, 8392704),
('root', 4, 1556274176227, 'python', 1, 'print(input())', 1, 31, 8294400),
('root', 4, 1556455456782, 'python', 1, 'print(input())', 1, 27, 8400896),
('root', 4, 1556455461954, 'python', 1, 'print(input())', 1, 21, 8433664),
('root', 4, 1556455466473, 'python', 1, 'print(input())', 1, 28, 8450048),
('root', 4, 1556455481805, 'python', 1, 'print(input())', 1, 27, 8454144),
('root', 4, 1556455486119, 'python', 1, 'print(input())', 1, 27, 8392704),
('root', 4, 1556455490311, 'python', 1, 'print(input())', 1, 22, 8392704),
('root', 4, 1556455494167, 'python', 1, 'print(input())', 1, 36, 8396800),
('root', 4, 1556455498124, 'python', 1, 'print(input())', 1, 35, 8392704),
('root', 4, 1556455501798, 'python', 1, 'print(input())', 1, 28, 8359936),
('root', 4, 1556455505297, 'python', 1, 'print(input())', 1, 32, 8400896),
('root', 6, 1556454471584, 'c', 8, '#include<stdio.h>\n\nint main(){\n    int n, c = 0;\n    scanf(\"%d\", &n);\n    for(int i = 1; i <= n; ++i){\n        if(n % i == 0) c++;\n    }\n    if(c == 2) printf(\"Prime\");\n    else       printf(\"Not prime\");    \n    return 0;\n}', 1, 1, 1658880),
('root', 6, 1556454483288, 'c', 8, '#include<stdio.h>\n\nint main(){\n    int n, c = 0;\n    scanf(\"%d\", &n);\n    for(int i = 1; i <= n; ++i){\n        if(n % i == 0) c++;\n    }\n    if(c == 2) printf(\"Prime\");\n    else       printf(\"Not prime\");    \n    return 0;\n}', 1, 2, 1654784);

-- --------------------------------------------------------

--
-- Table structure for table `test`
--

CREATE TABLE `test` (
  `tid` int(11) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `lang` varchar(255) NOT NULL DEFAULT 'all',
  `description` text NOT NULL,
  `duration` int(11) NOT NULL DEFAULT '30',
  `no_of_questions` int(11) NOT NULL DEFAULT '1',
  `date` date NOT NULL,
  `time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `test`
--

INSERT INTO `test` (`tid`, `name`, `lang`, `description`, `duration`, `no_of_questions`, `date`, `time`) VALUES
(3, 'Week Of Code', 'c', 'Some text here.', 6000, 1, '2019-08-16', '14:20:00'),
(4, 'Week Of Code', 'all', 'xyz', 360, 12, '2019-08-17', '23:07:00'),
(5, 'Test 1', 'all', 'abc', 360, 1, '2019-06-14', '11:11:00');

-- --------------------------------------------------------

--
-- Table structure for table `testcases`
--

CREATE TABLE `testcases` (
  `qid` int(11) UNSIGNED NOT NULL,
  `tc_no` int(11) UNSIGNED NOT NULL,
  `tc_type` varchar(30) NOT NULL,
  `tc_in` text NOT NULL,
  `tc_out` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `testcases`
--

INSERT INTO `testcases` (`qid`, `tc_no`, `tc_type`, `tc_in`, `tc_out`) VALUES
(1, 1, 'private', '1', 'Not prime'),
(1, 1, 'public', '1', 'Not prime'),
(1, 2, 'private', '2', 'Prime'),
(1, 2, 'public', '2', 'Prime'),
(1, 3, 'private', '3', 'Prime'),
(1, 4, 'private', '4', 'Not prime'),
(1, 5, 'private', '5', 'Prime'),
(1, 6, 'private', '6', 'Not prime'),
(1, 7, 'private', '7', 'Prime'),
(1, 8, 'private', '8', 'Not prime'),
(3, 1, 'private', '1720', 'Magic'),
(3, 1, 'public', '1720', 'Magic'),
(3, 2, 'private', '1234', 'Magic'),
(3, 2, 'public', '1234', 'Magic'),
(3, 3, 'private', '10', 'Magic'),
(3, 4, 'private', '19', 'Magic'),
(4, 1, 'private', 'Hello world!', 'Hello world!'),
(4, 1, 'public', 'Hello world!', 'Hello world!'),
(5, 1, 'private', '1', 'odd'),
(5, 1, 'public', '1', 'odd'),
(5, 2, 'private', '2', 'even'),
(5, 2, 'public', '2', 'even'),
(5, 3, 'private', '3', 'odd'),
(5, 4, 'private', '756436', 'even'),
(5, 5, 'private', '9999', 'odd'),
(6, 1, 'private', '1', 'Not prime'),
(6, 1, 'public', '1', 'Not prime'),
(6, 2, 'private', '2', 'Prime'),
(6, 2, 'public', '2', 'Prime'),
(6, 3, 'private', '3', 'Prime'),
(6, 4, 'private', '4', 'Not prime'),
(6, 5, 'private', '5', 'Prime'),
(6, 6, 'private', '6', 'Not prime'),
(6, 7, 'private', '7', 'Prime'),
(6, 8, 'private', '8', 'Not prime');

-- --------------------------------------------------------

--
-- Table structure for table `test_score`
--

CREATE TABLE `test_score` (
  `username` varchar(255) NOT NULL,
  `tid` int(10) UNSIGNED NOT NULL,
  `marks` float(65,3) UNSIGNED DEFAULT NULL,
  `cmp_index` float(65,3) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `test_score`
--

INSERT INTO `test_score` (`username`, `tid`, `marks`, `cmp_index`) VALUES
('root', 3, 20.000, 1501871.250);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `fullname` varchar(255) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `dob` date DEFAULT NULL,
  `session` varchar(9) DEFAULT NULL,
  `rollno` varchar(15) DEFAULT NULL,
  `dept_id` int(11) DEFAULT NULL,
  `email` varchar(320) DEFAULT NULL,
  `password` text,
  `confirmed` tinyint(1) NOT NULL DEFAULT '0',
  `approved` tinyint(1) NOT NULL DEFAULT '0',
  `role` varchar(15) NOT NULL DEFAULT 'user',
  `profession` varchar(255) NOT NULL DEFAULT 'student',
  `last_activity` datetime DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `time_token` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`fullname`, `username`, `dob`, `session`, `rollno`, `dept_id`, `email`, `password`, `confirmed`, `approved`, `role`, `profession`, `last_activity`, `reset_token`, `time_token`) VALUES
('Admin', 'root', '1996-01-01', '2015-19', '10800215098', 6, 'root@codepadoj.com', '$2a$12$lxHEqGEkKN25n3zGzZ5.yO55aosi8ozGho48ZJLOM9Sq1yXYppjKy', 1, 1, 'admin', 'student', '2019-08-18 00:15:39', 'MMWuUhkBUPaa0DBMaagU9Z6vcP8Dvqrg', '2019-05-04 21:34:21');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`cid`);

--
-- Indexes for table `dept`
--
ALTER TABLE `dept`
  ADD PRIMARY KEY (`dept_id`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`qid`),
  ADD UNIQUE KEY `qid` (`qid`),
  ADD KEY `scid` (`scid`),
  ADD KEY `questions_ibfk_2` (`tid`);

--
-- Indexes for table `score`
--
ALTER TABLE `score`
  ADD PRIMARY KEY (`username`,`cid`),
  ADD KEY `score_ibfk_2` (`cid`);

--
-- Indexes for table `subcategory`
--
ALTER TABLE `subcategory`
  ADD PRIMARY KEY (`scid`),
  ADD KEY `cid` (`cid`);

--
-- Indexes for table `submissions`
--
ALTER TABLE `submissions`
  ADD PRIMARY KEY (`username`,`qid`,`time_solved`),
  ADD KEY `submissions_ibfk_2` (`qid`);

--
-- Indexes for table `test`
--
ALTER TABLE `test`
  ADD PRIMARY KEY (`tid`);

--
-- Indexes for table `testcases`
--
ALTER TABLE `testcases`
  ADD PRIMARY KEY (`qid`,`tc_no`,`tc_type`);

--
-- Indexes for table `test_score`
--
ALTER TABLE `test_score`
  ADD PRIMARY KEY (`username`,`tid`),
  ADD KEY `test_score_ibfk_2` (`tid`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`username`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `email_2` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `cid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `dept`
--
ALTER TABLE `dept`
  MODIFY `dept_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
  MODIFY `qid` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `subcategory`
--
ALTER TABLE `subcategory`
  MODIFY `scid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT for table `test`
--
ALTER TABLE `test`
  MODIFY `tid` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`scid`) REFERENCES `subcategory` (`scid`),
  ADD CONSTRAINT `questions_ibfk_2` FOREIGN KEY (`tid`) REFERENCES `test` (`tid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `score`
--
ALTER TABLE `score`
  ADD CONSTRAINT `score_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `score_ibfk_2` FOREIGN KEY (`cid`) REFERENCES `category` (`cid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `subcategory`
--
ALTER TABLE `subcategory`
  ADD CONSTRAINT `subcategory_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `category` (`cid`);

--
-- Constraints for table `submissions`
--
ALTER TABLE `submissions`
  ADD CONSTRAINT `submissions_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `submissions_ibfk_2` FOREIGN KEY (`qid`) REFERENCES `questions` (`qid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `testcases`
--
ALTER TABLE `testcases`
  ADD CONSTRAINT `testcases_ibfk_1` FOREIGN KEY (`qid`) REFERENCES `questions` (`qid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `test_score`
--
ALTER TABLE `test_score`
  ADD CONSTRAINT `test_score_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `test_score_ibfk_2` FOREIGN KEY (`tid`) REFERENCES `test` (`tid`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
