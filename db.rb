require 'mysql2'

def db
  db ||= Mysql2::Client.new(
    host:     ENV['DB_HOST'] || 'localhost',
    port:     ENV['DB_PORT'] || '3306',
    username: ENV['DB_USERNAME'] || 'root',
    password: ENV['DB_PASSWORD'] || '',
    database: ENV['DB_DATABASE'] || 'tutorial',
  )
end

sql = "SELECT * FROM posts"

result = db.query(sql).to_a

puts result
