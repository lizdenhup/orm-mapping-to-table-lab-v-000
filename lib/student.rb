require 'pry'
require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id 

  def initialize (name, grade, id = nil)
     @name = name
     @grade = grade
     @id = id
   end

  def self.create_table
     sql = <<-SQL
       CREATE TABLE IF NOT EXISTS students (
         id INTEGER PRIMARY KEY, 
         name TEXT,
         grade TEXT
         )
     SQL
       DB[:conn].execute(sql)
   end

  def self.drop_table
     sql = "DROP TABLE IF EXISTS students"
     DB[:conn].execute(sql) 
  end

  def save
     sql = <<-SQL
       INSERT INTO students (name, grade) 
       VALUES (?, ?)
     SQL
 
     DB[:conn].execute(sql, self.name, self.grade)
     @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

 # However, at the end of your 
 #save method, you do need to grab 
 #the ID of the last inserted row, i.e. 
 #the row you just inserted into the database, 
 #and assign it to the be the value of the 
 #@id attribute of the given instance.

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student 
  end 
end
