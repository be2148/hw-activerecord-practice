require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new($stdout)

# Normally a separate file in a Rails app.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Customer < ApplicationRecord
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    Customer.where(first: 'Candice')
  end

  def self.with_valid_email
    Customer.where("email LIKE ?", '%@%')
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
  end
  # etc. - see README.md for more details
  def self.with_dot_org_email
    Customer.where("email LIKE ?", '%@%.org')
  end

  def self.with_invalid_email
    Customer.where("email != '' AND email not like '%@%'")
  end

  def self.with_blank_email
    Customer.where("email IS NULL")
  end

  def self.born_before_1980
    Customer.where("birthdate < ?", '1980-01-01')
  end

  def self.with_valid_email_and_born_before_1980
    Customer.where("birthdate < ? AND email LIKE ?", '1980-01-01', '%@%')
  end

  def self.last_names_starting_with_b
    Customer.where("last LIKE ?", 'B%').order(:birthdate)
  end

  def self.twenty_youngest
    Customer.all.order(birthdate: :desc).limit(20)
  end

  def self.update_gussie_murray_birthdate
    gus = Customer.where("first = ? AND last = ?", 'Gussie', 'Murray')
    gus.update(birthdate: Date.new(2004, 2, 8))
  end

  def self.change_all_invalid_emails_to_blank
    Customer.with_invalid_email().update_all(email: "")
  end

  def self.delete_meggie_herman
    meggie = Customer.where("first = ? AND last = ?", 'Meggie', 'Herman')
    meggie.destroy_all
  end

  def self.delete_everyone_born_before_1978
    Customer.where("birthdate < ?", Date.new(1978, 1, 1)).destroy_all
  end

  #commenting to try and submit as school GH account
end
