require 'rails_helper'

RSpec.describe SignedIn, type: :model do
	describe "notify" do
		subject { create :signed_in }

		it do
			expect { subject }.to change(Notification, :count).by(1)
		end
	end
end
