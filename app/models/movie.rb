class Movie < ActiveRecord::Base
   def self.all_ratings
     self.select(:rating).map(&:rating).uniq
   end
  
  def self.with_ratings(ratings_list, sort_by)
    if ratings_list
      self.where(rating: ratings_list).order(sort_by)
    else
      Movie.all.order(sort_by)
    end
  end
  
end
