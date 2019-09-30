# MySQL scripts for dropping existing tables and recreating the database table structure
DROP schema IF EXISTS sys;
CREATE schema IF NOT EXISTS travelapp;
USE travelapp;

CREATE USER IF NOT EXISTS 'user';
ALTER USER 'user'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' WITH GRANT OPTION;

### DROP EVERYTHING ###
# Tables/views must be dropped in reverse order due to referential constraints (foreign keys).
DROP VIEW IF EXISTS ModeCostRating;
DROP VIEW IF EXISTS VenueCostRatingMaxOccurs;
DROP VIEW IF EXISTS VenueCostRatingOccurs;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS VenuePhoto;
DROP TABLE IF EXISTS Venue;
DROP TABLE IF EXISTS VenueCategory;
DROP TABLE IF EXISTS User;


### TABLES ###
# Tables must be created in a particular order due to referential constraints i.e. foreign keys.
CREATE TABLE User
  (
     user_id                INT NOT NULL AUTO_INCREMENT,
     username               VARCHAR(64) NOT NULL,
     email                  VARCHAR(128) NOT NULL,
     given_name             VARCHAR(128) NOT NULL,
     family_name            VARCHAR(128) NOT NULL,
     password               VARCHAR(256) NOT NULL COMMENT 'Only store the hash here, not actual password!',
     auth_token             VARCHAR(32),
     profile_photo_filename VARCHAR(128),
     PRIMARY KEY (user_id),
     UNIQUE (username),
     UNIQUE (email),
     UNIQUE (auth_token)
  )
ENGINE = InnoDB;

CREATE TABLE VenueCategory
  (
     category_id          INT NOT NULL AUTO_INCREMENT,
     category_name        VARCHAR(64) NOT NULL,
     category_description VARCHAR(128) NOT NULL,
     PRIMARY KEY (category_id)
  )
ENGINE = InnoDB;

CREATE TABLE Venue
  (
     venue_id          INT NOT NULL AUTO_INCREMENT,
     admin_id          INT NOT NULL,
     category_id       INT NOT NULL,
     venue_name        VARCHAR(64) NOT NULL,
     city              VARCHAR(128) NOT NULL,
     short_description VARCHAR(128) NOT NULL,
     long_description  VARCHAR(2048) NOT NULL,
     date_added        DATE NOT NULL,
     address           VARCHAR(256) NOT NULL,
     latitude          DOUBLE NOT NULL,
     longitude         DOUBLE NOT NULL,
     PRIMARY KEY (venue_id),
     FOREIGN KEY (admin_id) REFERENCES User (user_id),
     FOREIGN KEY (category_id) REFERENCES VenueCategory (category_id)
  )
ENGINE = InnoDB;

CREATE TABLE VenuePhoto
  (
     venue_id          INT NOT NULL,
     photo_filename    VARCHAR(128) NOT NULL,
     photo_description VARCHAR(128),
     is_primary        BOOLEAN NOT NULL DEFAULT false,
     PRIMARY KEY (venue_id, photo_filename),
     FOREIGN KEY (venue_id) REFERENCES Venue (venue_id)
  )
ENGINE = InnoDB;

CREATE TABLE Review
  (
     review_id         INT NOT NULL AUTO_INCREMENT,
     reviewed_venue_id INT NOT NULL,
     review_author_id  INT NOT NULL,
     review_body       VARCHAR(1024) NOT NULL,
     star_rating       TINYINT NOT NULL,
     cost_rating       TINYINT NOT NULL,
     time_posted       DATETIME NOT NULL,
     PRIMARY KEY (review_id),
     FOREIGN KEY (reviewed_venue_id) REFERENCES Venue (venue_id),
     FOREIGN KEY (review_author_id) REFERENCES User (user_id)
  )
ENGINE = InnoDB;


### VIEWS ###
CREATE VIEW VenueCostRatingOccurs AS
  (
	SELECT venue_id, cost_rating, count(1) AS occurs
	FROM Venue JOIN Review ON reviewed_venue_id = venue_id
	GROUP BY venue_id, cost_rating
  );

CREATE VIEW VenueCostRatingMaxOccurs AS
  (
	SELECT venue_id, MAX(occurs) occurs
	FROM VenueCostRatingOccurs
	GROUP BY venue_id
  );

CREATE VIEW ModeCostRating AS
  (
    SELECT A.venue_id, A.cost_rating AS mode_cost_rating, A.occurs AS occurrences
    FROM VenueCostRatingOccurs A
    INNER JOIN VenueCostRatingMaxOccurs B
    ON A.venue_id = B.venue_id AND A.occurs = B.occurs
  );

# MySQL script for inserting sample data into the database
SET FOREIGN_KEY_CHECKS=0;


INSERT INTO VenueCategory
    (category_id, category_name, category_description)
VALUES
    (1, 'Accommodation', 'The best places to stay in town.'),
    (2, 'Cafés & Restaurants', 'The finest dining in town.'),
    (3, 'Attractions', 'The best things to see in town.'),
    (4, 'Events', 'What\'s going on in town.'),
    (5, 'Nature Spots', 'The most beautiful bits of nature in town.');

INSERT INTO Venue
    (venue_id, admin_id, category_id, venue_name, city, short_description, long_description, date_added, address,
    latitude, longitude)
VALUES
    (1, 1, 2, 'The Wok', 'Christchurch', 'Home of the world-famous $2 rice', '', '2018-12-25',
    'Ground Floor, The Undercroft, University of Canterbury, University Dr, Ilam, Christchurch 8041',
    -43.523617, 172.582885),
    (2, 2, 5, 'Ilam Gardens', 'Christchurch', 'Kinda pretty', '', '2019-01-01',
    '87 Ilam Rd, Ilam, Christchurch 8041, New Zealand',
    -43.524219, 172.576032),
    (3, 3, 1, 'Erskine Building', 'Christchurch', 'Many a late night has been spent here', '', '2019-01-01',
    'Erskine Science Rd, Ilam, Christchurch 8041, New Zealand',
    -43.522535, 172.581086);

INSERT INTO Review
    (reviewed_venue_id, review_author_id, review_body, star_rating, cost_rating, time_posted)
VALUES
    (1, 8, 'No more $2 rice, it\'s all a lie.', 3, 4, '2019-02-20 22:05:24'),
    (1, 9, 'Good rice for a good price.', 4, 2, '2019-02-12 18:42:01'),
    (3, 8, 'Had to provide our own beanbags to sleep on.', 1, 0, '2018-09-28 07:42:11'),
    (3, 3, 'Good air conditioning.', 5, 0, '2018-06-01 10:31:45'),
    (3, 4, 'My favourite place on earth.', 4, 3, '2019-01-19 12:34:59');

INSERT INTO User
	(username, email, given_name, family_name, password)
VALUES
	("bobby1", "bob.roberts@gmail.com", "Bob", "Roberts", "password"),
    ("black.panther", "black.panther@super.heroes", "T", "Challa", "Wakanda"),
    ("superman", "superman@super.heroes", "Clark", "Kent", "kryptonite"),
    ("batman", "dark.knight@super.heroes", "Bruce", "Wayne", "frankmiller"),
    ("spiderman", "spiderman@super.heroes", "Peter", "Parker", "arachnid"),
    ("ironman", "ironman@super.heroes", "Tony", "Stark", "robertdowney"),
    ("captain.america", "captain.america@super.heroes", "Steve", "Rogers", "donaldtrump"),
    ("dr.manhatten", "dr.manhatten@super.heroes", "Jonathan", "Osterman", "hydrogen"),
    ("vampire.slayer", "vampire.slayer@super.heroes", "Buffy", "Summers", "sarahgellar"),
    ("Ozymandias", "Ozymandias@super.villains", "Adrian", "Veidt", "shelley"),
    ("Rorschach", "Rorschach@super.villains", "Walter", "Kovacs", "Joseph"),
    ("power.woman", "power.woman@super.heroes", "Jessica", "Jones", "lukecage");

SET FOREIGN_KEY_CHECKS=1;

SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

FLUSH PRIVILEGES;