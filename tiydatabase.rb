require 'csv'
class Person
  # Saving the correct data into class
  attr_reader 'name', 'phone', 'address', 'position', 'salary', 'slack', 'github'
  # Defining name, phone, address, position, salary,slack, github
  def initialize(name, phone, address, position, salary, slack, github)
    @name = name
    @phone = phone
    @address = address
    @position = position
    @salary = salary
    @slack = slack
    @github = github
  end
end

class Tiydatabase
  attr_reader 'accounts'

  def initialize
    @accounts = []
    CSV.foreach( employees_file, headers: true) do |row|
      name = row["name"]
      phone = row["phone"]
      address = row["address"]
      position = row["position"]
      salary = row["salary"]
      slack = row["slack"]
      github = row["github"]

      account = Person.new(name, address, phone, position, salary.to_i, slack, github)

      @accounts << account
    end
  end

  def add_person
    print 'What is their name?'
    name = gets.chomp
    if @accounts.find {|account| account.name == name }
      puts "Said human exists in the database!"
    else
      print 'What is their phone number?'
      phone = gets.chomp.to_i

      print 'What is their address?'
      address = gets.chomp

      print 'What is their position at the Iron Yard?'
      position = gets.chomp

      print 'What is their salary?'
      salary = gets.chomp.to_i

      print 'What is their Slack username?'
      slack = gets.chomp

      print 'What is their GitHub username?'
      github = gets.chomp

      account = Person.new(name, phone, address, position, salary, slack, github)

      @accounts << account

    end
    write_csv
  end

  def search_person
    puts 'Please input the name of the person or account information that you are searching for? '
    search_person = gets.chomp
    found_account = @accounts.find { |account| account.name.include?(search_person) || account.slack == search_person || account.github == search_person}
    if found_account
      puts "This is #{found_account.name}'s information.
       \nName: #{found_account.name}
       \nPhone: #{found_account.phone}
       \nAddress: #{found_account.address}
       \nPosition: #{found_account.position}
       \nSalary: #{found_account.salary}
       \nSlack Account: #{found_account.slack}
       \nGitHub Account: #{found_account.github}"
    else
      puts "#{search_person} is not in our system.\n"
    end
  end

  def delete_person
    puts 'Who are you looking to terminate? '
    name_deleted = gets.chomp

    delete_account = @accounts.delete_if { |account| account.name == name_deleted }
    if delete_account
      puts 'Account has been exterminated!'
      write_csv
    else
      puts 'No such account exist'
    end

  end

  def report_account
    sorted_accounts = @accounts.sort_by {|account| account.name }
    sorted_accounts.each do |account|
    end
    puts "The Iron Yard Database Reports: "
    puts "The total salary for the Instructors is #{teacher_salary}"
    puts "The total salary for the Campus Director is #{director_salary}"
    puts "The total number of students at the Iron Yard is #{total_students}"
    puts "The total number of Instructor at the Iron Yard is #{total_teachers}"
    puts "The total number of Campus Directors at the Iron Yard is #{total_director}"

  end

  def teacher_salary
    @accounts.select {|account| account.position.include?("Instructor") }.map { |account| account.salary }.sum
  end

  def director_salary
    @accounts.select {|account| account.position.include?("Campus Director") }.map {|account| account.salary }.sum
  end

  def total_students
    @accounts.select {|account| account.position.include?("Student") }.count
  end

  def total_teachers
    @accounts.select {|account| account.position.include?("Instructor") }.count
  end

  def total_director
    @accounts.select {|account| account.position.include?("Campus Director") }.count
  end

  def employees_file
    return "employees.csv"
  end

  def write_csv
    CSV.open(employees_file, "w") do |csv|
      csv << ["name", "phone", "address", "position", "salary", "slack", "github"]
      @accounts.each do |account|
        csv << [account.name, account.phone, account.address, account.position, account.salary, account.slack, account.github]
      end
    end
  end
end
data = Tiydatabase.new

loop do
  puts 'Would you like to Add (A), Search (S) or Delete (D) a person or view the Report (R) from the Iron Yard Database?'
  selected = gets.chomp.upcase

  data.add_person if selected == 'A'

  data.search_person if selected == 'S'

  data.delete_person if selected == 'D'

  data.report_account if selected == 'R'
end
# If csv info got deleted, comment is at the bottom
# Gavin,555-1212,1 Main Street,Instructor,1000000,gstark,gstark
# Jason,555-4242,500 Elm Street,Instructor,2000000,ambethia,ambethia
# Toni,555-4444,200 Pine Street,Campus Director,3000000,amazing_toni,amazing_toni
