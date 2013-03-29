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

    # like(id)
   #  puts "karma #{average_karma}"
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

  def average_karma
    $db.execute("SELECT avg(cnt) from(SELECT COUNT(*) AS cnt FROM question_likes WHERE user_id = ? GROUP BY question_id);",
       @id).first[0]
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
    query = <<-SQL
      SELECT COUNT(*) AS likes
        FROM question_likes
      WHERE question_likes.question_id = ?
    SQL

    $db.execute(query, @id).first['likes'];
  end

  def self.most_liked(n)
    $db.execute("SELECT question_id, count(*) FROM question_likes GROUP BY question_id ORDER BY count(*) DESC LIMIT ?", n).map do |question|
      question['question_id']
    end
  end

  def followers ## returns array of id's of followers
    query = <<-SQL
      SELECT follower_id
          AS follower
        FROM question_followers
       WHERE question_id = ?
    SQL

    $db.execute(query, @id).map do |follower| follower['follower']
    end
  end

  def self.most_followed(n)
    query = <<-SQL
      SELECT question_id, COUNT(*)
        FROM question_followers
    GROUP BY question_id
    ORDER BY count(*) DESC LIMIT ?
    SQL

    $db.execute(query, n).map do |question| question['question_id']
  end

  def most_replies(n)
    query = <<-SQL
        SELECT prior_reply_id, COUNT(*)
          FROM question_replies
         WHERE question_id = ?
      GROUP BY prior_reply_id
      ORDER BY COUNT(*) DESC LIMIT ?;
    SQL

    $db.execute(query, @id, n).map do |question| question['prior_reply_id'] end
  end

end

$db.execute( "select * from question" ) do |row|
  p "Question ##{row['id']}: #{Question.new(row).num_likes}"
end


class QuestionFollowers
end ### WHAT DO WE DO WITH THIS GUY.

class QuestionReplies
  #attr_reader
  def replies
  end

  def self.most_replied
    $db.execute("select prior_reply_id from question_replies GROUP BY prior_reply_id ORDER BY count(*) DESC LIMIT 1;").first['prior_reply_id']
  end

end
#
# p QuestionReplies.most_replied


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
#
$db.execute( "select * from user" ) do |row|
  usr = User.new(row)
  p usr
end
#
# $db.execute( "select * from question_likes" ) do |row|
#   like_obj = QuestionLikes.new(row)
#   p like_obj
# end




