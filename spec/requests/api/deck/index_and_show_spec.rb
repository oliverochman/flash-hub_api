RSpec.describe Api::DecksController, type: :request do
  let(:headers) { { HTTP_ACCEPT: 'application/json' } }
  
  describe "GET /api/decks" do
    describe 'returns deck without specific category' do
      let!(:decks) do
        2.times do      
          create(:deck)
        end
      end

      let!(:first_deck_cards) do
        10.times do
          create(:flashcard, deck_id: decks.first.id)
        end
      end

      let!(:last_deck_cards) do
        10.times do
          create(:flashcard, deck_id: decks.last.id)
        end
      end

      before do
        get "/api/decks", headers: headers
      end
  
      it "returns a single deck with 10 flashcards" do
        expect(json_response.count).to eq 1
        expect(json_response['decks'].first.count).to eq 10
      end
  
      it "returns 200 response" do
        expect(response.status).to eq 200
      end
  
      it "returns next page number" do
        expect(json_response['meta']['next_page']).to eq 2
      end
    end

    describe 'returns deck with specific category' do
      let!(:right_category_deck) { create(:deck, category: 'Javascript')}
      let!(:incorrect_category_deck) { create(:deck, category: 'Ruby')}

      let!(:javascript_deck_cards) do
        10.times do
          create(:flashcard, deck_id: right_category_deck.id)
        end
      end

      before do
        get "/api/decks",
        params: {
          category: 'Javascript'
        },
        headers: headers
      end

      it "returns a single deck with 10 flashcards" do
        expect(json_response.count).to eq 1
        expect(json_response['decks'].first['flashcards'].count).to eq 10
      end
  
      it "returns 200 response" do
        expect(response.status).to eq 200
      end
  
      it "returns next page number" do
        expect(json_response['meta']['next_page']).to eq nil
      end

      it "returns deck of correct category" do
        expect(json_response['decks'].first['category']).to eq 'Javascript'
      end
    end
  end
end