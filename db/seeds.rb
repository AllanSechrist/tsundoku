require 'faker'
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

class SeedDataBase

  def self.reset_database
    puts "Resetting Database"
    Book.destroy_all
    Author.destroy_all
    Genre.destroy_all
    Publisher.destroy_all
    Invite.destroy_all
    Bookclub.destroy_all
    Member.destroy_all
    Shelf.destroy_all
    ShelfBook.destroy_all
    OwnedBook.destroy_all

    User.destroy_all
    puts "Reset Finished"

  end
  def self.create_users
    puts "Creating Users"
    user_emails = ["allan@allan.com", "cindy@cindy.com", "Rayz@Rayz.com", "Minami@minami.com", "Sarah@sarah.com", "Nico@nico.com"]
    user_emails.each { |email| User.create!(email: email, password: "123456")}
  end

  def self.create_authors
    puts "Creating Authors"
    authors = ["J.K. Rowling", "Stephen King", "JRR Tolkien", "Danielle Steel", "Dan Brown", "George Orwell", "Mark Twain", "F. Scott Fitzgerald", "Ernest Hemingway", "C. S. Lewis"]
    authors.each { |author| Author.create!(name: author)}
  end

  def self.create_publishers
    puts "Creating Publishers"
    publishers = ["HarperCollins", "Scholastic", "Macmillan", "Penguin Random House", "Harvard University Press"]
    publishers.each { |publisher| Publisher.create!(name: publisher) }
  end

  def self.create_genres
    puts "Creating Genre"
    genres = ["Romance", "Horror", "Thriller", "Fantasy", "Mystery", "Biography", "Science Fiction", "Historical Fiction", "Crime", "Adventure Fiction"]
    genres.each { |genre| Genre.create!(name: genre) }
  end

  def self.create_books

    create_authors
    create_publishers
    create_genres
    puts "Creating Books"
    genres = Genre.all
    authors = Author.all
    publishers = Publisher.all

    authors.each_with_index do |author, index|
      Book.create!(title: Faker::Book.title, author: author, genre: genres[index], publisher: publishers.sample )
    end
  end

  def self.create_owned_books
    users = User.all

    puts "Creating Owned Books"
    users.each do |user|
      OwnedBook.create!(book: Book.all.sample, user: user, rating: rand(1..5), review: Faker::Lorem.sentence(word_count: 10))
    end
  end

  def self.create_shelves
    profiles = Profile.all

    puts "Creating Shelves"
    profiles.each do |profile|
      Shelf.create!(profile: profile, title: Faker::Book.title, description: Faker::Lorem.sentence(word_count: 10))
    end
  end

  def self.create_shelf_books
    users = User.all

    users.each do |user|
      shelf = user.profile.shelves[0]
      book = user.owned_books[0]
      ShelfBook.create!(owned_book: book, shelf: shelf)
    end
  end

  def self.create_book_clubs
    puts "Creating Book Clubs"
    users = User.all
    bookclubs = ["Between the Lines", "Chapter & Chatter", "The Plot Thickens", "Bookmarks & Beverages", "Ink & Insight", "The Literary Lantern"]
    users.each_with_index do |user, index|
      Bookclub.create!(name: bookclubs[index], description: "Its pretty cool.", creator: user)
    end
  end

  def self.seed_database
    puts "Start seeding"
    reset_database
    create_users
    create_books
    create_owned_books
    create_shelves
    create_shelf_books
    create_book_clubs
    puts "Finish seeding"
  end
end

SeedDataBase.seed_database
