class NoteService
  
  def self.addNote(note_params,token)
    @current_user = JsonWebToken.decode(token)
    unless @current_user
      return {success: false, error: "Unauthorized access" }, status: :unauthorized
    end
    note = @current_user.notes.new(note_params)
    if note.save
      return {success: true, message: "Note added successfully"}
    else
      return {success: false, error: "Couldn't add note"}
    end
  end
end