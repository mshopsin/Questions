CREATE TABLE user (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  is_instructor INTEGER NOT NULL
);

CREATE TABLE question (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT(1000),
  author VARCHAR(255) NOT NULL  -- Name this user_id?
);

CREATE TABLE question_followers(
  id INTEGER PRIMARY KEY,
  follower_id INTEGER,
  question_id INTEGER
);

CREATE TABLE question_replies(
  id INTEGER PRIMARY KEY,
  subject_id INTEGER NOT NULL

  FOREIGN KEY(subject_id) REFERENCES question(id)

