INSERT INTO user ('fname','lname','is_instructor')
     VALUES ('Dar','Gani',0),
            ('Matt','Shop',0),
            ('Kyle', 'L', 1);


INSERT INTO question ('title','body','author_id')
     VALUES ('Questions3', 'Body3', 3),
            ('Questions4', 'Body4', 4),
            ('Questions5', 'Body5', 4),
            ('Questions6', 'Body6', 3);

INSERT INTO question_likes ('user_id','question_id')
     VALUES (1, 4),
            (1, 5),
            (1, 6),
            (2, 4),
            (2, 2),
            (3, 4),
            (3, 1);