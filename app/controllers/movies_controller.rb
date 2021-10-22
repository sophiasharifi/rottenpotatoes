class MoviesController < ApplicationController
  #create new instance var
  #put in html list
  #if filtered is passed in a value, send to html to highlight
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  
  def index
    if(params[:ratings].nil? && params[:sort_by].nil?)
      #create a hash for rating bc its a list, map whatever is in rating, session
      #[rating] to populate the hash, then pass moviespath .h()
        if session[:ratings]
          session[:ratings] = Hash[session[:ratings].collect {|item| [item, ""]}]
        end
        rating = session[:ratings] || Hash[Movie.all_ratings.collect {|item| [item, ""]}]
        sort = session[:sort_by] || ""
        redirect_to movies_path({ratings: rating, sort_by: sort})
    end
    
     @ratings = params[:ratings].nil? ? Movie.all_ratings: params[:ratings].keys
     @sort_by = params[:sort_by]
    
    
    session[:ratings] = @ratings
    
    if @sort_by != nil
      session[:sort_by] = @sort_by
    else
      session[:sort_by] = ''
    end
     
    @movies = Movie.with_ratings(@ratings, @sort_by)
    @all_ratings = Movie.all_ratings
    @ratings_to_show = params[:ratings]? @ratings : [] #maybe fix idk
    
    
end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
