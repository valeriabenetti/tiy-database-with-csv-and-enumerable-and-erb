require 'csv'
require 'erb'

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
  EMPLOYEE_FILE = "employees.csv"
  def initialize
    @accounts = []
    CSV.foreach( EMPLOYEE_FILE, headers: true) do |row|
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

    if @accounts.any? {|account| account.name == name_deleted}
      @accounts.delete_if { |account| account.name == name_deleted }
      puts 'Account has been exterminated!'
      write_csv
    else
      puts 'No such account exist'
    end
  end

  def report_account

    puts "The Iron Yard Database Reports: "

    employees_by_position = @accounts.group_by {|account| account.position.downcase }
    employees_by_position.each do |position, account|
      total_salary = account.map {|account| account.salary }.sum
      puts "The total salary for the #{position} is #{total_salary}"
      puts "The total count for the #{position} is #{account.count}"
    end
  end

  def people_position(position)
    @accounts.select {|account| account.position.include?(position) }
  end

  def salary_total_for_position(position)
    people_position(position).map {|account| account.salary}.sum
  end

  def position_count(position)
    people_position(position).count

  end

  def teacher_salary
    people_position("Instructor").map { |account| account.salary }.sum
  end

  def director_salary
    people_position("Campus Director").map {|account| account.salary }.sum
  end

  def total_students
    people_position("Student").count
  end

  def total_teachers
    people_position("Instructor").count
  end

  def total_director
    people_position("Campus Director").count
  end

  def write_csv
    CSV.open(EMPLOYEE_FILE, "w") do |csv|
      csv << ["name", "phone", "address", "position", "salary", "slack", "github"]
      @accounts.each do |account|
        csv << [account.name, account.phone, account.address, account.position, account.salary, account.slack, account.github]
      end
    end
  end

  def html_employee_report
    template = ERB.new(File.read("report.html.erb"))
    html = template.result(binding)
    File.write("report.html", html)
  end
end
data = Tiydatabase.new

loop do
  puts 'Would you like to Add (A), Search (S) or Delete (D) a person or view the Report (R) or Print (P) from the Iron Yard Database?'
  selected = gets.chomp.upcase

  data.add_person if selected == 'A'

  data.search_person if selected == 'S'

  data.delete_person if selected == 'D'

  data.report_account if selected == 'R'

  data.html_employee_report if selected == 'P'
end
