require 'sqlite3'
require 'singleton'

#DB = SQLite3::Database.new( "questions3.db" )
#DB.instance.results_as_hash = true

class DB < SQLite3::Database
  include Singleton

  def initialize
    super("questions3.db")
    self.results_as_hash = true
    self.type_translation = true
  end

end

class User
  attr_reader :id
  attr_accessor :fname, :lname, :is_instructor

  def initialize(row)
    @id    = row['id']
    @fname = row['fname']
    @lname = row['lname']
    @is_instructor = row['is_instructor']

    # like(id)
   #  puts "karma #{average_karma}"
  end

  def ask_question(title, body)
      #   query = <<-SQL
     # INSERT INTO question ('title','body','author_id')
     #      VALUES (title, body, id)
     #    SQL
    DB.instance.execute("INSERT INTO question ('title','body','author_id') VALUES (?, ?, ?);",
   title,body,id)
  end

  def like(question_id)
    DB.instance.execute("INSERT INTO question_likes ('user_id','question_id')
                      VALUES (?,?);", id, question_id)
  end

  def average_karma
    query = <<-SQL
      SELECT AVG(CNT)
       FROM(SELECT COUNT(*)
                AS cnt
              FROM question_likes
              JOIN question
                ON(question_likes.question_id = question.id)
              JOIN user
                ON(question.author_id = user.id)
             WHERE user.id = ?
          GROUP BY question_likes.question_id)
    SQL

    DB.instance.execute(query, @id)
  end

  def save_insert()
    insert = <<-SQL
      INSERT INTO question('fname','lname', 'is_instructor')
          VALUES (?, ?, ?)
    SQL
    DB.instance.execute(insert, @fname, @lname, @is_instructor)
    @id = DB.instance.last_insert_row_id
  end

  def save_update
    update = <<-SQL
      UPDATE question
      SET fname = ?,
          lname = ?,
          is_instructor = ?
      WHERE id = ?
    SQL
    DB.instance.execute(insert,@fname, @lname, @is_instructor, @id)
  end

  def save
    if @id.nil?
      save_insert
    else
      save_update
    end
  end


end

class Question
  attr_reader :id
  attr_accessor :author_id, :num_likes, :followers, :title, , :body

  def initialize(row)
    @id = row['id']
    @title = row['title']
    @body = row['body']
    @author_id = row['author_id']
  end

  def num_likes
    query = <<-SQL
      SELECT COUNT(*)
          AS likes
        FROM question_likes
       WHERE question_likes.question_id = ?
    SQL

    DB.instance.execute(query, @id).first['likes'];
  end

  def self.most_liked(n)
    query = <<-SQL
    SELECT *
      FROM question_likes
     WHERE question_likes.id
        IN (SELECT question_id
              FROM question_likes
          GROUP BY question_id
          ORDER BY COUNT(*) DESC LIMIT ?)
    SQL

    DB.instance.execute(query, n).map { |question| Question.new(question) }
  end

  def followers ## returns array of id's of followers
    query = <<-SQL
    SELECT user.id, user.fname, user.lname, user.is_instructor
      FROM question
      JOIN question_followers
        ON (question.id = question_followers.question_id)
      JOIN user
        ON (user.id = question_followers.follower_id)
     WHERE question.id = ?;
    SQL

    DB.instance.execute(query, id).map { |follower| User.new(follower)}

  end

  def most_replies(n)
    query = <<-SQL
        SELECT *
          FROM question_replies
         WHERE question_id = ?
      GROUP BY prior_reply_id
      ORDER BY COUNT(*) DESC LIMIT ?
    SQL

    DB.instance.execute(query, @id, n).map { |reply| QuestionReplies.new(reply) }
  end

  def render
    puts "id: #{id}, author_id: #{author_id}, title: #{title} \n body: #{body} \n num_likes: #{num_likes}, followers: #{followers}\n"
  end


  def save_insert()
    insert = <<-SQL
      INSERT INTO question('title','body', 'author_id')
          VALUES (?, ?, ?)
    SQL
    DB.instance.execute(insert, @title, @body, @author_id)
    @id = DB.instance.last_insert_row_id
  end

  def save_update
    update = <<-SQL
      UPDATE question
      SET title = ?,
          body = ?,
          author_id = ?
      WHERE id = ?
    SQL
    DB.instance.execute(insert,@title, @body, @author_id, @id)
  end

  def save
    if @id.nil?
      save_insert
    else
      save_update
    end
  end

end

class QuestionFollowers

  def self.most_followed(n)
    query = <<-SQL
      SELECT question.id, question.title, question.body, question.author_id
        FROM question
        JOIN question_followers
          ON (question.id = question_followers.question_id)
          GROUP BY question.id
          ORDER BY COUNT(*) DESC LIMIT ?
    SQL

    DB.instance.execute(query, n).map { |question| Question.new(question) }
  end

end

class QuestionReplies
  attr_accessor :question_id, :prior_reply_id, :user_id, :reply
  attr_reader :id

  def initialize(row)
    @id = row['id']
    @question_id = row['question_id']
    @prior_reply_id = row['prior_reply_id']
    @user_id = row['user_id']
    @reply = row['reply']
  end


  def self.most_replied
    query = <<-SQL
      SELECT *
        FROM question_replies
       WHERE question_replies.id
           IN (SELECT prior_reply_id
                 FROM question_replies
                 GROUP BY prior_reply_id
                 ORDER BY count(*) DESC LIMIT 1)
    SQL

    QuestionReplies.new(DB.instance.execute(query).first)
  end

end


class QuestionLikes
  attr_reader :id
  attr_accessor :user_id, :question_id
  def initialize(row)
    @id = row['id']
    @user_id = row['user_id']
    @question_id = row['question_id']
  end

  def save_insert
    insert = <<-SQL
      INSERT INTO question_likes('user_id','question_id')
          VALUES (?, ?)
    SQL
    DB.instance.execute(insert,@user_id,@user_id)
    @id = DB.instance.last_insert_row_id
  end

  def save_update
    update = <<-SQL
      UPDATE question_likes
      SET user_id = ?,
          question_likes = ?,
      WHERE id = ?
    SQL
    DB.instance.execute(insert,@user_id,@user_id,@id)
  end

  def save
    if @id.nil?
      save_insert
    else
      save_update
    end
  end

end

p QuestionReplies.most_replied
