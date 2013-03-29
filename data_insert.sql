---- INSERT INTO user ('fname','lname','is_instructor')
----      VALUES ('Kush','Patel',0),
----       ('Ned','Ruggeri',1);
----
---- INSERT INTO question ('title','body','author_id')
----      VALUES ('Who is leaving sleeping mats out?', 'Land Lord coming today', 2),
----       ('JOBS', 'Who needs one?', 1);


-- INSERT INTO user ('fname','lname','is_instructor')
--      VALUES ('Dar','Gani',0),
--             ('Matt','Shop',0),
--             ('Kyle', 'L', 1);
--
--
-- INSERT INTO question ('title','body','author_id')
--      VALUES ('Questions3', 'Body3', 3),
--             ('Questions4', 'Body4', 4),
--             ('Questions5', 'Body5', 4),
--             ('Questions6', 'Body6', 3);
--
-- INSERT INTO question_likes('user_id','question_id')
--      VALUES (1, 4),
--             (1, 5),
--             (1, 6),
--             (2, 4),
--             (2, 2),
--             (3, 4),
--             (3, 1);

-- DROP TABLE question_replies;
--
-- CREATE TABLE question_replies(
--   id INTEGER PRIMARY KEY,
--   question_id INTEGER NOT NULL,
--   prior_reply_id INTEGER,
--   user_id INTEGER,
--   reply TEXT(1000),
--
--   FOREIGN KEY(user_id) REFERENCES user(id),
--   FOREIGN KEY(question_id) REFERENCES question(id)
-- );
--
-- DROP TABLE question_followers;
--
-- CREATE TABLE question_followers(
--   id INTEGER PRIMARY KEY,
--   follower_id INTEGER NOT NULL,
--   question_id INTEGER NOT NULL,
--
--   FOREIGN KEY(follower_id) REFERENCES user(id),
--   FOREIGN KEY(question_id) REFERENCES question(id)
-- );
--
-- INSERT INTO question_followers('follower_id','question_id')
--      VALUES (1, 1),
--             (1, 2),
--             (1, 3),
--             (2, 4),
--             (3, 5),
--             (4, 5);
--
--
-- INSERT INTO question_replies('question_id', 'prior_reply_id', 'user_id', 'reply')
--      VALUES (1, NULL, 1, "reply to question 1"),
--             (1, 1, 2,"reply to reply 1 question 1"),
--             (1, 2, 4,"reply to reply 2 question 1"),
--             (3, 2, 3,"reply to reply 2 question 1");

INSERT INTO question_replies('question_id', 'prior_reply_id', 'user_id', 'reply')
     VALUES (1, 2, 5, "reply to question 1 reply 1");


