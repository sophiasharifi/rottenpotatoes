class Movie < ActiveRecord::Base
   def self.all_ratings
     self.select(:rating).map(&:rating).uniq
   end
  
  def self.with_ratings(ratings_list)
    if ratings_list
      self.where(rating: ratings_list)
    else
      Movie.all
    end
  end
    
end
