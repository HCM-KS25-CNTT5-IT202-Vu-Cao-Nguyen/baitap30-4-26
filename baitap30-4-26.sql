DROP DATABASE IF EXISTS CineMagic;
CREATE DATABASE CineMagic;
USE CineMagic;

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
    age_restriction INT DEFAULT 0 CHECK (age_restriction IN (0, 13, 16, 18))
);

CREATE TABLE rooms (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    max_seats INT NOT NULL CHECK (max_seats > 0),
    status ENUM('active', 'maintenance') DEFAULT 'active'
);

CREATE TABLE showtimes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    movie_id INT NOT NULL,
    room_id INT NOT NULL,
    show_time DATETIME NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL CHECK (ticket_price >= 0),
    CONSTRAINT fk_showtime_movie FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_showtime_room FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT unique_room_time UNIQUE (room_id, show_time)
);

CREATE TABLE bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    showtime_id INT NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_booking_showtime FOREIGN KEY (showtime_id) REFERENCES showtimes(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX idx_showtime_time ON showtimes(show_time);
CREATE INDEX idx_booking_phone ON bookings(phone);

INSERT INTO movies (title, duration_minutes, age_restriction) VALUES
('Avengers: Secret Wars', 150, 13),
('Dune: Part Two', 165, 13),
('Deadpool 3', 130, 18),
('Kung Fu Panda 4', 95, 0);

INSERT INTO rooms (name, max_seats, status) VALUES
('Room 1', 100, 'active'),
('Room 2', 80, 'active'),
('Room 3', 60, 'maintenance');

INSERT INTO showtimes (movie_id, room_id, show_time, ticket_price) VALUES
(1, 1, '2026-05-01 10:00:00', 90000),
(2, 1, '2026-05-01 13:30:00', 100000),
(3, 2, '2026-05-01 16:00:00', 120000),
(4, 2, '2026-05-01 18:30:00', 80000),
(1, 1, '2026-05-02 20:00:00', 95000);

INSERT INTO bookings (showtime_id, customer_name, phone) VALUES
(1, 'Nguyen Van A', '0900000001'),
(1, 'Tran Thi B', '0900000002'),
(2, 'Le Van C', '0900000003'),
(2, 'Pham Thi D', '0900000004'),
(3, 'Hoang Van E', '0900000005'),
(3, 'Nguyen Thi F', '0900000006'),
(4, 'Tran Van G', '0900000007'),
(4, 'Le Thi H', '0900000008'),
(5, 'Pham Van I', '0900000009'),
(5, 'Hoang Thi K', '0900000010');

UPDATE rooms
SET status = 'maintenance'
WHERE id = 1;

UPDATE showtimes
SET room_id = 2
WHERE room_id = 1;

DELETE FROM bookings
WHERE phone = '0987654321';

DELETE FROM movies
WHERE id = 3;