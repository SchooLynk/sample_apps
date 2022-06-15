require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "post /login" do
    let!(:user) { create :user }

    it do
      expect {
        post "/login", params: { session: { email: "a@example.com", password: "111111" } }
      }.to change { user.reload.last_sign_in_ip }.from(be_nil)
       .and change(SignedIn, :count).by(1)

      expect(response).to redirect_to "http://www.example.com/users/#{user.id}"
    end
  end
end
