class Api::V1::NotesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    token = request.headers["Authorization"]&.split(" ")&.last
    result = NoteService.addNote(note_params, token)
    if result[:success]
      render json: { message: result[:message] }, status: :ok
    else
      render json: { errors: result[:error] }, status: :unprocessable_entity
    end
  end

  
  def getNoteById
    token =request.headers["Authorization"]&.split(" ")&.last
    note_id = params[:id]
    result = NoteService.getNoteById(note_id, token)
    if result[:success]
      render json: result[:note], status: :ok
    else
      render json: { errors: result[:error]}, status: :unauthorized
    end
  end

 
 
  private

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
