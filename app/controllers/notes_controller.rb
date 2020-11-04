class NotesController < ApplicationController
  
  get '/notes' do
    if logged_in?
      @notes = Note.all
      erb :'notes/notes'
    else
      redirect to '/login'
    end
  end

  get '/notes/new' do
    if logged_in?
      erb :'notes/create_note'
    else
      redirect to '/login'
    end
  end

  post '/notes' do
    if logged_in?
      if params[:content] == ""
        redirect to "/notes/new"
      else
        @note = current_user.notes.build(content: params[:content])
        if @note.save
          redirect to "/notes/#{@note.id}"
        else
          redirect to "/notes/new"
        end
      end
    else
      redirect to '/login'
    end
  end

  get '/notes/:id' do
    if logged_in?
    @note = Note.find_by(id: params[:id])
    erb :'/notes/show_note'
    else
      redirect to '/login'
    end
  end

  get '/notes/:id/edit' do
    if logged_in?
      @note = Note.find_by_id(params[:id])
      if @note && @note.user == current_user
        erb :'notes/edit_note'
      else
        redirect to '/notes'
      end
    else
      redirect to '/login'
    end
  end

  patch '/notes/:id' do
    if logged_in?
      if params[:content] == ""
        redirect to "/notes/#{params[:id]}/edit"
      else
        @note = Note.find_by_id(params[:id])
        if @note && @note.user == current_user
          if @note.update(content: params[:content])
            redirect to "/notes/#{@note.id}"
          else
            redirect to "/notes/#{@note.id}/edit"
          end
        else
          redirect to '/notes'
        end
      end
    else
      redirect to '/login'
    end
  end

  delete '/notes/:id/delete' do
    if logged_in?
      @note = Tweet.find_by_id(params[:id])
      if @note && @note.user == current_user
        @note.delete
      end
      redirect to '/notes'
    else
      redirect to '/login'
    end
  end
end