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
  author_id INTEGER NOT NULL,  -- Name this user_id?

  FOREIGN KEY(author_id) REFERENCES user(id)
);

CREATE TABLE question_followers(
  id INTEGER PRIMARY KEY,
  follower_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(follower_id) REFERENCES user(id),
  FOREIGN KEY(question_id) REFERENCES question(id)
);

--
-- INSERT INTO question_followers ('follower_id', 'question_id')
-- VALUES ()

CREATE TABLE question_replies(
  id INTEGER PRIMARY KEY,
  subject_id INTEGER NOT NULL,
  parent_reply INTEGER,

  FOREIGN KEY(subject_id) REFERENCES question(id),
  FOREIGN KEY(parent_reply) REFERENCES question_replies(id)
);

CREATE TABLE question_actions(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  action INTEGER, --  --ENUM (1'redact', 2'close', 3'reopen'),

  FOREIGN KEY(question_id) REFERENCES question(id)
);

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES user(id)
  FOREIGN KEY(question_id) REFERENCES question(id)
);


INSERT INTO user ('fname','lname','is_instructor')
     VALUES ('Kush','Patel',0),
      ('Ned','Ruggeri',1);

INSERT INTO question ('title','body','author_id')
     VALUES ('Who is leaving sleeping mats out?', 'Land Lord coming today', 2),
      ('JOBS', 'Who needs one?', 1);



