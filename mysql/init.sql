/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS `giotmauvang` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `giotmauvang`;

CREATE TABLE IF NOT EXISTS `appointment` (
  `blood_amount` int DEFAULT NULL,
  `status` tinyint DEFAULT NULL,
  `appointment_date_time` datetime(6) DEFAULT NULL,
  `blood_inventory_id` bigint DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `next_donation_eligible_date` datetime(6) DEFAULT NULL,
  `user_cccd` varchar(12) DEFAULT NULL,
  `event_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKhuxr6e3snekvrf4wcd73qynag` (`blood_inventory_id`),
  KEY `FKsjers288j2kelbkau50m3t8pk` (`event_id`),
  KEY `FKen4hxofvnjkck1xxahlc3j9ad` (`user_cccd`),
  CONSTRAINT `FKen4hxofvnjkck1xxahlc3j9ad` FOREIGN KEY (`user_cccd`) REFERENCES `user` (`cccd`),
  CONSTRAINT `FKm17wxh3utra1ktytll8lg7e27` FOREIGN KEY (`blood_inventory_id`) REFERENCES `blood_inventory` (`id`),
  CONSTRAINT `FKsjers288j2kelbkau50m3t8pk` FOREIGN KEY (`event_id`) REFERENCES `event` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `appointment`;
INSERT INTO `appointment` (`blood_amount`, `status`, `appointment_date_time`, `blood_inventory_id`, `id`, `next_donation_eligible_date`, `user_cccd`, `event_id`) VALUES
	(350, 3, '2025-06-25 09:00:00.000000', 1, 1, '2025-09-19 01:31:09.848102', '079100000001', 'HCM001'),
	(350, 3, '2025-06-28 10:00:00.000000', 2, 2, '2025-09-19 01:31:16.910415', '079100000002', 'HCM002'),
	(NULL, 3, '2025-06-19 03:16:42.551850', 3, 3, NULL, '089203015463', 'HCM001'),
	(NULL, 0, '2025-06-19 05:56:54.084406', NULL, 4, NULL, '089203015463', 'HCM001');

CREATE TABLE IF NOT EXISTS `blood_donation_history` (
  `blood_amount` int DEFAULT NULL,
  `appointment_id` bigint DEFAULT NULL,
  `donation_date_time` datetime(6) DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` varchar(12) NOT NULL,
  `donation_location` varchar(255) DEFAULT NULL,
  `donation_type` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `reaction_after_donation` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK5hk3ac6pu9gce321fjw2nt571` (`appointment_id`),
  KEY `FKkxe9fgh3xs4a2y5y2b86a1i7o` (`user_id`),
  CONSTRAINT `FKhwdap4pg6h2n42g97nwc3hf4` FOREIGN KEY (`appointment_id`) REFERENCES `appointment` (`id`),
  CONSTRAINT `FKkxe9fgh3xs4a2y5y2b86a1i7o` FOREIGN KEY (`user_id`) REFERENCES `user` (`cccd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `blood_donation_history`;
INSERT INTO `blood_donation_history` (`blood_amount`, `appointment_id`, `donation_date_time`, `id`, `user_id`, `donation_location`, `donation_type`, `notes`, `reaction_after_donation`) VALUES
	(350, 1, '2025-06-25 09:00:00.000000', 1, '079100000001', 'Bệnh viện Chợ Rẫy', 'Toàn phần', 'Ổn định', 'Không'),
	(350, 2, '2025-06-28 10:00:00.000000', 2, '079100000002', 'Trung tâm Truyền máu', 'Toàn phần', 'Ổn định', 'Không');

CREATE TABLE IF NOT EXISTS `blood_inventory` (
  `quantity` int NOT NULL,
  `appointment_id` bigint DEFAULT NULL,
  `expiration_date` datetime(6) DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `last_updated` datetime(6) DEFAULT NULL,
  `blood_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKnrb9yfoj94ig0yaold7tk78cq` (`appointment_id`),
  CONSTRAINT `FKphfgh3xjgyqa2hl66ip5c3wru` FOREIGN KEY (`appointment_id`) REFERENCES `appointment` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `blood_inventory`;
INSERT INTO `blood_inventory` (`quantity`, `appointment_id`, `expiration_date`, `id`, `last_updated`, `blood_type`) VALUES
	(350, 1, '2025-08-31 10:00:00.000000', 1, '2025-06-19 03:36:42.358888', 'A+'),
	(450, 2, '2025-08-31 09:00:00.000000', 2, '2025-06-19 03:36:38.203923', 'A-'),
	(250, 3, '2025-06-27 03:00:00.000000', 3, '2025-06-19 03:36:21.195200', 'AB-');

CREATE TABLE IF NOT EXISTS `blood_quota` (
  `additional_blood_bag` int DEFAULT NULL,
  `goal_blood_bag` int DEFAULT NULL,
  `max_blood_bag` int DEFAULT NULL,
  `min_blood_bag` int DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `blood_quota`;
INSERT INTO `blood_quota` (`additional_blood_bag`, `goal_blood_bag`, `max_blood_bag`, `min_blood_bag`, `id`) VALUES
	(10, 100, 120, 50, 1),
	(5, 70, 90, 30, 2);

CREATE TABLE IF NOT EXISTS `blood_registration` (
  `reg_blooda` int DEFAULT NULL,
  `reg_bloodab` int DEFAULT NULL,
  `reg_bloodb` int DEFAULT NULL,
  `reg_bloodo` int DEFAULT NULL,
  `reg_negative_blooda` int DEFAULT NULL,
  `reg_negative_bloodab` int DEFAULT NULL,
  `reg_negative_bloodb` int DEFAULT NULL,
  `reg_negative_bloodo` int DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `event_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKo03ro7xobn1dvtwng1f3wenp9` (`event_id`),
  CONSTRAINT `FKb4s4xjqktuw9oehhqpmouqse9` FOREIGN KEY (`event_id`) REFERENCES `event` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `blood_registration`;
INSERT INTO `blood_registration` (`reg_blooda`, `reg_bloodab`, `reg_bloodb`, `reg_bloodo`, `reg_negative_blooda`, `reg_negative_bloodab`, `reg_negative_bloodb`, `reg_negative_bloodo`, `id`, `event_id`) VALUES
	(20, 8, 15, 20, 1, 0, 1, 1, 1, 'HCM001'),
	(18, 5, 17, 18, 2, 0, 0, 0, 2, 'HCM002');

CREATE TABLE IF NOT EXISTS `chat_messages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `timestamp` datetime(6) NOT NULL,
  `message_type` varchar(10) DEFAULT NULL,
  `session_id` varchar(36) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `content` text,
  PRIMARY KEY (`id`),
  KEY `FK3cpkdtwdxndrjhrx3gt9q5ux9` (`session_id`),
  CONSTRAINT `FK3cpkdtwdxndrjhrx3gt9q5ux9` FOREIGN KEY (`session_id`) REFERENCES `chat_sessions` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `chat_messages`;

CREATE TABLE IF NOT EXISTS `chat_sessions` (
  `created_at` datetime(6) DEFAULT NULL,
  `last_activity` datetime(6) DEFAULT NULL,
  `session_id` varchar(36) NOT NULL,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `chat_sessions`;

CREATE TABLE IF NOT EXISTS `donate_time_slot` (
  `current_reg` int DEFAULT NULL,
  `donate_accept_time` int DEFAULT NULL,
  `donate_stop_time` int DEFAULT NULL,
  `max_limit_donate` int DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `event_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK9xx0s4llb6uejdodp3thkfmgs` (`event_id`),
  CONSTRAINT `FK9xx0s4llb6uejdodp3thkfmgs` FOREIGN KEY (`event_id`) REFERENCES `event` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `donate_time_slot`;
INSERT INTO `donate_time_slot` (`current_reg`, `donate_accept_time`, `donate_stop_time`, `max_limit_donate`, `id`, `event_id`) VALUES
	(25, 28000, 39600, 30, 1, 'HCM001'),
	(15, 27000, 37800, 25, 2, 'HCM002');

CREATE TABLE IF NOT EXISTS `donation_unit` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `donation_place` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `unit_photo_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `donation_unit`;
INSERT INTO `donation_unit` (`id`, `donation_place`, `email`, `location`, `phone`, `unit`, `unit_photo_url`) VALUES
	(1, 'Bệnh viện Chợ Rẫy', 'bvchoray.hcm@gmail.com', 'Quận 5, TP.HCM', '02838554137', 'Hội chữ thập đỏ TP.HCM', 'https://hirot-donation-images.s3.ap-southeast-1.amazonaws.com/CTD.png'),
	(2, 'Trung tâm Truyền máu Huyết học TP.HCM', 'truyenmau.hcm@gmail.com', 'Quận 1, TP.HCM', '02839207508', 'Hội chữ thập đỏ TP.HCM', 'https://hirot-donation-images.s3.ap-southeast-1.amazonaws.com/CTD.png');

CREATE TABLE IF NOT EXISTS `event` (
  `donate_date` date DEFAULT NULL,
  `donate_end_time` time(6) DEFAULT NULL,
  `donate_start_time` time(6) DEFAULT NULL,
  `event_type` int NOT NULL,
  `is_urgent` int NOT NULL,
  `max_registrations` int NOT NULL,
  `blood_quota_id` bigint DEFAULT NULL,
  `current_registrations` bigint DEFAULT NULL,
  `donation_unit_id` bigint NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `donate_address` varchar(255) DEFAULT NULL,
  `donate_id` varchar(255) DEFAULT NULL,
  `donate_place` varchar(255) DEFAULT NULL,
  `event_id` varchar(255) NOT NULL,
  `private_url` varchar(255) DEFAULT NULL,
  `ref` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `event_status` enum('ACTIVE','DONE','FULL') DEFAULT NULL,
  PRIMARY KEY (`event_id`),
  UNIQUE KEY `UKqkxop09wpkam39xjjw28imx6c` (`blood_quota_id`),
  KEY `FKjny1fmf1k2dse3jgrqb18fdn6` (`donation_unit_id`),
  CONSTRAINT `FKj6xdotl3peyrm0qcguxjho108` FOREIGN KEY (`blood_quota_id`) REFERENCES `blood_quota` (`id`),
  CONSTRAINT `FKjny1fmf1k2dse3jgrqb18fdn6` FOREIGN KEY (`donation_unit_id`) REFERENCES `donation_unit` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `event`;
INSERT INTO `event` (`donate_date`, `donate_end_time`, `donate_start_time`, `event_type`, `is_urgent`, `max_registrations`, `blood_quota_id`, `current_registrations`, `donation_unit_id`, `description`, `donate_address`, `donate_id`, `donate_place`, `event_id`, `private_url`, `ref`, `title`, `event_status`) VALUES
	('2025-06-25', '11:30:00.000000', '08:00:00.000000', 1, 1, 120, 1, 52, 1, NULL, '201B Nguyễn Chí Thanh, Quận 5, TP.HCM', NULL, 'Bệnh viện Chợ Rẫy', 'HCM001', NULL, NULL, 'Hiến máu cứu người - Chợ Rẫy', 'ACTIVE'),
	('2025-06-28', '11:00:00.000000', '07:30:00.000000', 2, 0, 100, 2, 40, 2, NULL, '118 Hồng Bàng, Quận 5, TP.HCM', NULL, 'Trung tâm Truyền máu', 'HCM002', NULL, NULL, 'Ngày hội giọt hồng TP.HCM', 'ACTIVE');

CREATE TABLE IF NOT EXISTS `faq` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `timestamp` datetime(6) DEFAULT NULL,
  `description` text NOT NULL,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `faq`;
INSERT INTO `faq` (`id`, `timestamp`, `description`, `title`) VALUES
	(1, '2025-06-19 07:01:30.000000', 'Người từ 18-60 tuổi, cân nặng từ 42kg (nữ) hoặc 45kg (nam) trở lên, có sức khỏe tốt, không mắc các bệnh lây nhiễm qua đường máu như HIV, viêm gan B, C, giang mai... và không trong thời kỳ kinh nguyệt (đối với nữ).', 'Ai có thể hiến máu?'),
	(2, '2025-06-19 06:01:30.000000', 'Trước khi hiến máu 1 ngày nên ngủ đủ giấc, không uống rượu bia. Trong ngày hiến máu nên ăn nhẹ, uống nhiều nước, không ăn đồ nhiều chất béo. Mang theo CMND hoặc giấy tờ tùy thân khi đi hiến máu.', 'Tôi cần chuẩn bị gì trước khi hiến máu?'),
	(3, '2025-06-19 05:01:30.000000', 'Hiến máu đúng cách hoàn toàn không có hại cho sức khỏe. Cơ thể sẽ nhanh chóng tái tạo lượng máu đã hiến. Mỗi lần chỉ hiến không quá 9ml/kg cân nặng đối với nam và 8ml/kg đối với nữ.', 'Hiến máu có hại sức khỏe không?'),
	(4, '2025-06-19 04:01:30.000000', 'Khoảng cách giữa 2 lần hiến máu toàn phần tối thiểu là 12 tuần đối với nam và 16 tuần đối với nữ. Đối với hiến tiểu cầu, khoảng cách có thể ngắn hơn (tối thiểu 2 tuần).', 'Tôi có thể hiến máu bao lâu một lần?'),
	(5, '2025-06-19 03:01:30.000000', '1. Đăng ký thông tin\n2. Khám sàng lọc\n3. Xét nghiệm nhanh\n4. Hiến máu\n5. Nghỉ ngơi và nhận giấy chứng nhận\nToàn bộ quy trình mất khoảng 30-45 phút.', 'Quy trình hiến máu gồm những bước nào?'),
	(6, '2025-06-19 02:01:30.000000', 'Bạn sẽ nhận được:\n- Giấy chứng nhận hiến máu\n- Quà tặng hoặc hỗ trợ chi phí đi lại (tùy đơn vị tổ chức)\n- Xét nghiệm các chỉ số cơ bản về máu\n- Bảo hiểm hiến máu (nếu có)', 'Tôi nhận được gì sau khi hiến máu?'),
	(7, '2025-06-19 01:01:30.000000', 'Cảm giác đau rất nhẹ và chỉ trong tích tắc khi kim tiêm đâm vào da. Trong quá trình hiến máu bạn sẽ không cảm thấy đau. Nếu cảm thấy không thoải mái có thể báo ngay với nhân viên y tế.', 'Hiến máu có đau không?'),
	(8, '2025-06-19 00:01:30.000000', 'Người mắc bệnh tim mạch (suy tim, bệnh mạch vành, rối loạn nhịp tim...) không nên hiến máu. Bạn nên tham khảo ý kiến bác sĩ điều trị trước khi có ý định hiến máu.', 'Tôi bị bệnh tim có hiến máu được không?'),
	(9, '2025-06-18 23:01:30.000000', 'Hoàn toàn không. Tất cả dụng cụ lấy máu đều vô trùng, dùng một lần. Mỗi người hiến máu sẽ được sử dụng bộ kim lấy máu riêng, được mở mới trước mặt bạn.', 'Hiến máu có bị lây bệnh không?'),
	(10, '2025-06-18 22:01:30.000000', '- Nghỉ ngơi 10-15 phút tại chỗ\n- Uống nhiều nước\n- Không hút thuốc, uống rượu trong 24h\n- Tránh vận động mạnh trong 6-8h\n- Ăn uống đầy đủ dinh dưỡng', 'Tôi nên làm gì sau khi hiến máu?'),
	(11, '2025-06-18 21:01:30.000000', 'Tùy loại thuốc bạn đang dùng. Một số thuốc như kháng sinh, thuốc điều trị đặc biệt cần ngừng ít nhất 1 tuần trước khi hiến máu. Bạn nên thông báo với nhân viên y tế về các loại thuốc đang sử dụng.', 'Tôi có thể hiến máu khi đang dùng thuốc?'),
	(12, '2025-06-18 20:01:30.000000', 'Phụ nữ đang mang thai hoặc trong vòng 1 năm sau sinh không nên hiến máu. Trong thời kỳ cho con bú cũng không nên hiến máu để đảm bảo sức khỏe cho cả mẹ và bé.', 'Phụ nữ mang thai có hiến máu được không?'),
	(13, '2025-06-18 19:01:30.000000', 'Người từ 18-60 tuổi, cân nặng từ 42kg (nữ) hoặc 45kg (nam) trở lên, có sức khỏe tốt, không mắc các bệnh lây nhiễm qua đường máu như HIV, viêm gan B, C, giang mai... và không trong thời kỳ kinh nguyệt (đối với nữ).', 'Ai có thể hiến máu?'),
	(14, '2025-06-18 18:01:30.000000', 'Trước khi hiến máu 1 ngày nên ngủ đủ giấc, không uống rượu bia. Trong ngày hiến máu nên ăn nhẹ, uống nhiều nước, không ăn đồ nhiều chất béo. Mang theo CMND hoặc giấy tờ tùy thân khi đi hiến máu.', 'Tôi cần chuẩn bị gì trước khi hiến máu?'),
	(15, '2025-06-18 17:01:30.000000', 'Hiến máu đúng cách hoàn toàn không có hại cho sức khỏe. Cơ thể sẽ nhanh chóng tái tạo lượng máu đã hiến. Mỗi lần chỉ hiến không quá 9ml/kg cân nặng đối với nam và 8ml/kg đối với nữ.', 'Hiến máu có hại sức khỏe không?'),
	(16, '2025-06-18 16:01:30.000000', 'Khoảng cách giữa 2 lần hiến máu toàn phần tối thiểu là 12 tuần đối với nam và 16 tuần đối với nữ. Đối với hiến tiểu cầu, khoảng cách có thể ngắn hơn (tối thiểu 2 tuần).', 'Tôi có thể hiến máu bao lâu một lần?'),
	(17, '2025-06-18 15:01:30.000000', '1. Đăng ký thông tin\n2. Khám sàng lọc\n3. Xét nghiệm nhanh\n4. Hiến máu\n5. Nghỉ ngơi và nhận giấy chứng nhận\nToàn bộ quy trình mất khoảng 30-45 phút.', 'Quy trình hiến máu gồm những bước nào?'),
	(18, '2025-06-18 14:01:30.000000', 'Bạn sẽ nhận được:\n- Giấy chứng nhận hiến máu\n- Quà tặng hoặc hỗ trợ chi phí đi lại (tùy đơn vị tổ chức)\n- Xét nghiệm các chỉ số cơ bản về máu\n- Bảo hiểm hiến máu (nếu có)', 'Tôi nhận được gì sau khi hiến máu?'),
	(19, '2025-06-18 13:01:30.000000', 'Cảm giác đau rất nhẹ và chỉ trong tích tắc khi kim tiêm đâm vào da. Trong quá trình hiến máu bạn sẽ không cảm thấy đau. Nếu cảm thấy không thoải mái có thể báo ngay với nhân viên y tế.', 'Hiến máu có đau không?'),
	(20, '2025-06-18 12:01:30.000000', 'Người mắc bệnh tim mạch (suy tim, bệnh mạch vành, rối loạn nhịp tim...) không nên hiến máu. Bạn nên tham khảo ý kiến bác sĩ điều trị trước khi có ý định hiến máu.', 'Tôi bị bệnh tim có hiến máu được không?'),
	(21, '2025-06-18 11:01:30.000000', 'Hoàn toàn không. Tất cả dụng cụ lấy máu đều vô trùng, dùng một lần. Mỗi người hiến máu sẽ được sử dụng bộ kim lấy máu riêng, được mở mới trước mặt bạn.', 'Hiến máu có bị lây bệnh không?'),
	(22, '2025-06-18 10:01:30.000000', '- Nghỉ ngơi 10-15 phút tại chỗ\n- Uống nhiều nước\n- Không hút thuốc, uống rượu trong 24h\n- Tránh vận động mạnh trong 6-8h\n- Ăn uống đầy đủ dinh dưỡng', 'Tôi nên làm gì sau khi hiến máu?'),
	(23, '2025-06-18 09:01:30.000000', 'Tùy loại thuốc bạn đang dùng. Một số thuốc như kháng sinh, thuốc điều trị đặc biệt cần ngừng ít nhất 1 tuần trước khi hiến máu. Bạn nên thông báo với nhân viên y tế về các loại thuốc đang sử dụng.', 'Tôi có thể hiến máu khi đang dùng thuốc?'),
	(24, '2025-06-18 08:01:30.000000', 'Phụ nữ đang mang thai hoặc trong vòng 1 năm sau sinh không nên hiến máu. Trong thời kỳ cho con bú cũng không nên hiến máu để đảm bảo sức khỏe cho cả mẹ và bé.', 'Phụ nữ mang thai có hiến máu được không?'),
	(25, '2025-06-18 07:01:30.000000', 'Người từ 18-60 tuổi, cân nặng từ 42kg (nữ) hoặc 45kg (nam) trở lên, có sức khỏe tốt, không mắc các bệnh lây nhiễm qua đường máu như HIV, viêm gan B, C, giang mai... và không trong thời kỳ kinh nguyệt (đối với nữ).', 'Ai có thể hiến máu?'),
	(26, '2025-06-18 06:01:30.000000', 'Trước khi hiến máu 1 ngày nên ngủ đủ giấc, không uống rượu bia. Trong ngày hiến máu nên ăn nhẹ, uống nhiều nước, không ăn đồ nhiều chất béo. Mang theo CMND hoặc giấy tờ tùy thân khi đi hiến máu.', 'Tôi cần chuẩn bị gì trước khi hiến máu?'),
	(27, '2025-06-18 05:01:30.000000', 'Hiến máu đúng cách hoàn toàn không có hại cho sức khỏe. Cơ thể sẽ nhanh chóng tái tạo lượng máu đã hiến. Mỗi lần chỉ hiến không quá 9ml/kg cân nặng đối với nam và 8ml/kg đối với nữ.', 'Hiến máu có hại sức khỏe không?'),
	(28, '2025-06-18 04:01:30.000000', 'Khoảng cách giữa 2 lần hiến máu toàn phần tối thiểu là 12 tuần đối với nam và 16 tuần đối với nữ. Đối với hiến tiểu cầu, khoảng cách có thể ngắn hơn (tối thiểu 2 tuần).', 'Tôi có thể hiến máu bao lâu một lần?'),
	(29, '2025-06-18 03:01:30.000000', '1. Đăng ký thông tin\n2. Khám sàng lọc\n3. Xét nghiệm nhanh\n4. Hiến máu\n5. Nghỉ ngơi và nhận giấy chứng nhận\nToàn bộ quy trình mất khoảng 30-45 phút.', 'Quy trình hiến máu gồm những bước nào?'),
	(30, '2025-06-18 02:01:30.000000', 'Bạn sẽ nhận được:\n- Giấy chứng nhận hiến máu\n- Quà tặng hoặc hỗ trợ chi phí đi lại (tùy đơn vị tổ chức)\n- Xét nghiệm các chỉ số cơ bản về máu\n- Bảo hiểm hiến máu (nếu có)', 'Tôi nhận được gì sau khi hiến máu?'),
	(31, '2025-06-18 01:01:30.000000', 'Cảm giác đau rất nhẹ và chỉ trong tích tắc khi kim tiêm đâm vào da. Trong quá trình hiến máu bạn sẽ không cảm thấy đau. Nếu cảm thấy không thoải mái có thể báo ngay với nhân viên y tế.', 'Hiến máu có đau không?'),
	(32, '2025-06-18 00:01:30.000000', 'Người mắc bệnh tim mạch (suy tim, bệnh mạch vành, rối loạn nhịp tim...) không nên hiến máu. Bạn nên tham khảo ý kiến bác sĩ điều trị trước khi có ý định hiến máu.', 'Tôi bị bệnh tim có hiến máu được không?'),
	(33, '2025-06-17 23:01:30.000000', 'Hoàn toàn không. Tất cả dụng cụ lấy máu đều vô trùng, dùng một lần. Mỗi người hiến máu sẽ được sử dụng bộ kim lấy máu riêng, được mở mới trước mặt bạn.', 'Hiến máu có bị lây bệnh không?'),
	(34, '2025-06-17 22:01:30.000000', '- Nghỉ ngơi 10-15 phút tại chỗ\n- Uống nhiều nước\n- Không hút thuốc, uống rượu trong 24h\n- Tránh vận động mạnh trong 6-8h\n- Ăn uống đầy đủ dinh dưỡng', 'Tôi nên làm gì sau khi hiến máu?'),
	(35, '2025-06-17 21:01:30.000000', 'Tùy loại thuốc bạn đang dùng. Một số thuốc như kháng sinh, thuốc điều trị đặc biệt cần ngừng ít nhất 1 tuần trước khi hiến máu. Bạn nên thông báo với nhân viên y tế về các loại thuốc đang sử dụng.', 'Tôi có thể hiến máu khi đang dùng thuốc?'),
	(36, '2025-06-17 20:01:30.000000', 'Phụ nữ đang mang thai hoặc trong vòng 1 năm sau sinh không nên hiến máu. Trong thời kỳ cho con bú cũng không nên hiến máu để đảm bảo sức khỏe cho cả mẹ và bé.', 'Phụ nữ mang thai có hiến máu được không?');

CREATE TABLE IF NOT EXISTS `healthcheck` (
  `appointment_id` bigint DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `health_metrics` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `result` enum('FAIL','PASS') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKn8p6do309a45ju4bswlnjsaf5` (`appointment_id`),
  CONSTRAINT `FK6ndp8ucbkru3vuoyow3ar53m4` FOREIGN KEY (`appointment_id`) REFERENCES `appointment` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `healthcheck`;
INSERT INTO `healthcheck` (`appointment_id`, `id`, `health_metrics`, `notes`, `result`) VALUES
	(1, 1, NULL, NULL, 'PASS'),
	(2, 2, NULL, NULL, 'PASS'),
	(3, 3, '{"hasDonatedBefore":false,"hasChronicDiseases":false,"hasRecentDiseases":false,"hasSymptoms":false,"isPregnantOrNursing":false,"HIVTestAgreement":true,"hivtestAgreement":true,"pregnantOrNursing":false}', NULL, 'PASS'),
	(4, 4, '{"hasDonatedBefore":false,"hasChronicDiseases":false,"hasRecentDiseases":false,"hasSymptoms":false,"isPregnantOrNursing":false,"HIVTestAgreement":true,"pregnantOrNursing":false,"hivtestAgreement":true}', NULL, 'PASS');

CREATE TABLE IF NOT EXISTS `news` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `timestamp` datetime(6) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `news`;

CREATE TABLE IF NOT EXISTS `password_reset_token` (
  `expiry_date` datetime(6) DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_cccd` varchar(12) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK8k367qj01lpdfsmbaxqdy393i` (`user_cccd`),
  CONSTRAINT `FKmw9cssst7gyy31upjyjlaangd` FOREIGN KEY (`user_cccd`) REFERENCES `user` (`cccd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `password_reset_token`;

CREATE TABLE IF NOT EXISTS `role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `role`;
INSERT INTO `role` (`id`, `description`, `name`) VALUES
	(1, NULL, 'ADMIN'),
	(2, NULL, 'USER');

CREATE TABLE IF NOT EXISTS `user` (
  `role_id` bigint NOT NULL,
  `user_info_id` bigint DEFAULT NULL,
  `cccd` varchar(12) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`cccd`),
  UNIQUE KEY `UK62i7yocqg502en5cavxyim4hf` (`user_info_id`),
  KEY `FKn82ha3ccdebhokx3a8fgdqeyy` (`role_id`),
  CONSTRAINT `FKh98qmq3hqffkhv8pw266v2vb4` FOREIGN KEY (`user_info_id`) REFERENCES `user_info` (`id`),
  CONSTRAINT `FKn82ha3ccdebhokx3a8fgdqeyy` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `user`;
INSERT INTO `user` (`role_id`, `user_info_id`, `cccd`, `email`, `password`, `phone`) VALUES
	(2, 101, '079100000001', 'namnv@gmail.com', 'pass1', '0901000001'),
	(2, 102, '079100000002', 'hoatt@gmail.com', 'pass2', '0901000002'),
	(2, 103, '079100000003', 'tupm@gmail.com', 'pass3', '0901000003'),
	(2, 104, '079100000004', 'huonglt@gmail.com', 'pass4', '0901000004'),
	(2, 105, '079100000005', 'thinhhv@gmail.com', 'pass5', '0901000005'),
	(2, 106, '079100000006', 'maidt@gmail.com', 'pass6', '0901000006'),
	(2, 107, '079100000007', 'duyna@gmail.com', 'pass7', '0901000007'),
	(2, 108, '079100000008', 'hanvn@gmail.com', 'pass8', '0901000008'),
	(2, 109, '079100000009', 'longbn@gmail.com', 'pass9', '0901000009'),
	(2, 110, '079100000010', 'landt@gmail.com', 'pass10', '0901000010'),
	(1, 111, '089203015463', 'chitin952003@gmail.com', '$2a$10$ohy5o7SE94yyqPysekhsTO4kSBQc7USiqr0iFVhAlQ.eZSPyZiR5C', '0706389781'),
	(2, 112, '089203015466', 'dnchitin952003@gmail.com', '$2a$10$h/QVOV3D6sN.VNPCltPL6O8Tp2ngDOItTFTP.TLQl.tDOvMfYUu82', '0982018470');

CREATE TABLE IF NOT EXISTS `user_info` (
  `dob` date DEFAULT NULL,
  `id` bigint NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `user_info`;
INSERT INTO `user_info` (`dob`, `id`, `address`, `full_name`, `sex`) VALUES
	('2000-01-15', 101, 'Quận 1, TP.HCM', 'Nguyễn Văn Nam', 'Nam'),
	('1998-06-20', 102, 'Quận 3, TP.HCM', 'Trần Thị Hoa', 'Nữ'),
	('1995-03-10', 103, 'Quận 5, TP.HCM', 'Phạm Minh Tú', 'Nam'),
	('1997-07-25', 104, 'Gò Vấp, TP.HCM', 'Lê Thị Hương', 'Nữ'),
	('1993-12-05', 105, 'Tân Bình, TP.HCM', 'Hoàng Văn Thịnh', 'Nam'),
	('2001-02-18', 106, 'Bình Thạnh, TP.HCM', 'Đặng Thị Mai', 'Nữ'),
	('1999-09-09', 107, 'Quận 7, TP.HCM', 'Ngô Anh Duy', 'Nam'),
	('1996-11-30', 108, 'Thủ Đức, TP.HCM', 'Võ Ngọc Hân', 'Nữ'),
	('1994-04-04', 109, 'Phú Nhuận, TP.HCM', 'Bùi Nhật Long', 'Nam'),
	('2002-08-08', 110, 'Quận 10, TP.HCM', 'Đỗ Thị Lan', 'Nữ'),
	('2003-09-05', 111, 'HCM', 'Tin', 'Nam'),
	('1999-06-03', 112, 'yrygfe', 'Tin', 'Nam');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
