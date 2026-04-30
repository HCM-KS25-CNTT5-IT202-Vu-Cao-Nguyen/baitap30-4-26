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