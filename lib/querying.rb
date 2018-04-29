def select_books_titles_and_years_in_first_series_order_by_year
  "SELECT books.title, books.year FROM books WHERE series_id = 1 ORDER BY books.year"
end

def select_name_and_motto_of_char_with_longest_motto
  "SELECT characters.name, characters.motto FROM characters ORDER BY length(motto) DESC LIMIT 1"
end


def select_value_and_count_of_most_prolific_species
  "SELECT characters.species, count(species) as count_species FROM characters  GROUP BY species ORDER BY count_species DESC LIMIT 1"
end

#Since we want, as our final table, authors name and subgenres name we start there
#SELECT authors.name, subgenres.name
#Since these columns are from differant tables it is implied we will need to JOIN at some point
#By pre-loading the tables in Terminal a visual analysis is now possible.
#Ask: What connects Authors --> Series --> Subgenre; maybe two JOINS will be needed.
# SELECT ... FROM authors JOIN series ON [CONDITION]; this condition is what links authors and series i.e. author_id and series_id
# SELECT ... FROM authors JOIN series ON authors.id = series.author_id. Now, how do we get to subgenre? JOIN subgenres [condition]
# What condition? Think, what common id relates the two tables: i.e. subgenre.id and series.subgenre_id
# SELECT ... FROM authors JOIN series ON .... JOIN subgenres ON subgenre.id = series.subgnere_id
# Lastly, GROUP BY authors.name to get test passing.
def select_name_and_series_subgenres_of_authors
  "SELECT authors.name, subgenres.name FROM authors JOIN series ON series.author_id = authors.id  JOIN subgenres ON subgenres.id = series.subgenre_id GROUP BY authors.name"
end

#We want series title so we know were starting with SELECT series.title
#SELECT series.title FROM series; Now, we need a bridge to access character names
#we should JOIN with characters ON [condition]; characters.series_id = series.id is the link
#Since were being explicity asked to find the most humans we can use a WHERE (since were not specifying any aggregate functions)
# WHERE characters.species = 'human'
# We then want to GROUP BY the title of the series so: GROUP BY series.title
# We only the series with the most humans so we'll need some sort of ORDER BY
# We want to ORDER BY COUNT(*) b/c this will count the number of rows i.e. the number of rows containing|satisfying the species = 'human' parameter specifed earlier.
# Since we want most we use DESC and since we only want the highest well set a LIMIT 1 to only retreive 1 row; the series with the highest occurences of human species.
def select_series_title_with_most_human_characters
  "SELECT series.title FROM series JOIN characters ON characters.series_id = series.id WHERE characters.species = 'human' GROUP BY series.title ORDER BY COUNT(*) DESC LIMIT 1"
end

#We know we want character names so thats our first hint
# SELECT characters.names
#We also know we want to, at some point, count the amount of times a characrer appears in a book
#This can be initiated as COUNT(books.title) as title_count - title_count is just an alias name for COUNT(books.title)
# Ask: which table can link books-->characters ? and how can we create a table that will list every character and every movie appearene he/she is in?
#character_books is clearly the table we need to JOIN our characters table with.
# Now, since we want to merge the character names, books and the character_books table we may need to do more than one JOIN method
# SELECT characters.name, COUNT(books.title) as title_count FROM characters LEFT JOIN character_books ON character_books.character_id = characters.id
# we want to retain the "left" side of the characters table because those columns containt the character names themselves, if we had done a conventional JOIN then all columns of both table swould be combined (see link to blog)
# we check to see that the character id's match up; thus, character_books.character_id = characters.idea
# now, were only missing book titles themselves.
# we know its going to involve the books table
# http://www.khankennels.com/blog/index.php/archives/2007/04/20/getting-joins/ we will need INNER JOIN to compare multiple tables that have foreign_keys that link one another, only returns 'mathches' that exist in both tables
# INNER JOIN books on [conditional]
# we want to compare character_books.book_id to books.id
# The table we have now has as many rows as our original character_books table but in addition now has the books.title column as well enabling us to now utilize our COUNT(books.title) as books_count from earlier.
# Now we need to simply GROUP BY characters.name and ORDER BY title_count DESC since we want highest-->lowest
def select_character_names_and_number_of_books_they_are_in
  "SELECT characters.name, COUNT(books.title) as title_count
  FROM characters
  LEFT JOIN character_books
  ON character_books.character_id = characters.id
  INNER JOIN books
  ON character_books.book_id = books.id
  GROUP BY characters.name
  ORDER BY title_count DESC"
end
