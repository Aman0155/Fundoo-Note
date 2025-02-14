require 'rails_helper'
require 'redis'

RSpec.describe NoteService, type: :service do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(id: user.id) }
  let(:note) { create(:note, user: user) }
  let(:redis) { Redis.new(host: "localhost", port: 6379) }

  before do
    allow(Redis).to receive(:new).and_return(redis)
    redis.flushdb 
  end

  describe ".addNote" do
    context "when the request is valid" do
      it "creates a new note" do
        note_params = { title: "Test Note", content: "This is a test note" }
        result = NoteService.addNote(note_params, token)
        expect(result[:success]).to be true
        expect(result[:message]).to eq("Note added successfully")
      end
    end

    context "when the request is unauthorized" do
      it "returns an unauthorized error" do
        result = NoteService.addNote({}, "invalid_token")
        expect(result[:success]).to be false
        expect(result[:error]).to eq("Unauthorized access")
      end
    end
  end

  describe ".getNote" do
    context "when user has notes" do
      it "returns user notes" do
        note # Ensuring note is created
        result = NoteService.getNote(token)
        expect(result[:success]).to be true
        expect(result[:notes]).not_to be_empty
      end
    end

    context "when user is unauthorized" do
      it "returns an unauthorized error" do
        result = NoteService.getNote("invalid_token")
        expect(result[:success]).to be false
        expect(result[:error]).to eq("Unauthorized access")
      end
    end
  end

  describe ".getNoteById" do
    context "when the note exists and belongs to the user" do
      it "returns the note" do
        result = NoteService.getNoteById(note.id, token)
        expect(result[:success]).to be true
        expect(result[:note]).to eq(note)
      end
    end

    context "when the token is invalid" do
      it "returns an unauthorized error" do
        result = NoteService.getNoteById(note.id, "invalid_token")
        expect(result[:success]).to be false
        expect(result[:error]).to eq("Unauthorized access")
      end
    end

    context "when the note does not belong to the user" do
      let(:another_user) { create(:user) }
      let(:another_token) { JsonWebToken.encode(id: another_user.id) }

      it "returns a token validation error" do
        result = NoteService.getNoteById(note.id, another_token)
        expect(result[:success]).to be false
        expect(result[:error]).to eq("Token not valid for this note")
      end
    end
  end

  describe ".trashToggle" do
    it "toggles the trash status of a note" do
      expect(note.isDeleted).to be false
      result = NoteService.trashToggle(note.id)
      expect(result[:success]).to be true
      note.reload
      expect(note.isDeleted).to be true
    end
  end

  describe ".archiveToggle" do
    it "toggles the archive status of a note" do
      expect(note.isArchived).to be false
      result = NoteService.archiveToggle(note.id)
      expect(result[:success]).to be true
      note.reload
      expect(note.isArchived).to be true
    end
  end

  describe ".changeColor" do
    it "changes the color of the note" do
      result = NoteService.changeColor(note.id, { color: "blue" })
      expect(result[:success]).to be true
      note.reload
      expect(note.color).to eq("blue")
    end
  end
end
