require 'sqlite3'

$db = SQLite3::Database.new( "questions3.db" )
$db.results_as_hash = true

class User
  attr_reader :id, :fname, :lname, :is_instructor

  def initialize(row)
    @id    = row['id']
    @fname = row['fname']
    @lname = row['lname']
    @is_instructor = row['is_instructor']

    like(id)

  end

  def ask_question(title, body)
      #   query = <<-SQL
     # INSERT INTO question ('title','body','author_id')
     #      VALUES (title, body, id)
     #    SQL
    $db.execute("INSERT INTO question ('title','body','author_id') VALUES (?, ?, ?);",
   title,body,id)
  end

  def like(question_id)
    $db.execute("INSERT INTO question_likes ('user_id','question_id')
                      VALUES (?,?);", id, question_id)
  end

  def create_reply
  end

  def follow
  end

end




class Question
  attr_accessor :student, :num_likes, :followers, :title

  def initialize(row)
    @id = row['id']
    @title = row['title']
    @body = row['body']
    @author_id = row['author_id']
  end

  def num_likes

  end

  def self.most_liked(n)
  end

  def followers
  end

  def self.most_followed(n)
  end

end

$db.execute( "select * from question" ) do |row|
  question = Question.new(row)
  p question
end

class QuestionFollowers
  def self.most_followed

  end

end

class QuestionReplies
  def insert_reply
  end

  def self.most_replied
  end

end

class QuestionActions
end

class QuestionLikes
  attr_reader :id, :user_id, :question_id
  def initialize(row)
    @id = row['id']
    @user_id = row['user_id']
    @question_id = row['question_id']
  end
end

$db.execute( "select * from user" ) do |row|
  usr = User.new(row)
  p usr
end

$db.execute( "select * from question_likes" ) do |row|
  like_obj = QuestionLikes.new(row)
  p like_obj
end




