require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#follow" do
    context "1人followしたとき" do
      let(:user) { create :user }
      let(:other) { create :user }

      it do
        expect { user.follow other }.to change(Relationship, :count).by(1)
                                    .and change(Notification, :count).by(1)
      end
    end

    context "5分以内に2人からfollowされたとき" do
      let(:user) { create :user }
      let(:other1) { create :user }
      let(:other2) { create :user }

      it do
        expect {
          other1.follow user
          other2.follow user
        }.to change { user.followers.count }.by(2)
         .and change { user.notifications.count }.by(2)

        expect(Notification.all).to match [
          have_attributes(parent: be_nil, children_count: 2),
          have_attributes(parent: be_present, children_count: 1),
        ]
      end
    end

    context "follow されてから、unfollow" do
      let(:user) { create :user }
      let(:other) { create :user }

      it do
        other.follow user

        expect {
          other.unfollow user
        }.to change { user.followers.count }.by(-1)
         .and change { user.notifications.count }.by(-1)
      end
    end

    context "2人に follow されてから、先の人に unfollow" do
      let(:user) { create :user }
      let(:other1) { create :user }
      let(:other2) { create :user }

      it do
        other1.follow user
        other2.follow user

        expect {
          other1.unfollow user
        }.not_to change { user.notifications.count }.from(2)

        expect(Notification.all).to match [
          have_attributes(parent: be_nil, children_count: 1),
          have_attributes(parent: be_present, children_count: 1),
        ]
      end
    end

    context "2人に follow されてから、後の人に unfollow" do
      let(:user) { create :user }
      let(:other1) { create :user }
      let(:other2) { create :user }

      it do
        other1.follow user
        other2.follow user

        expect {
          other2.unfollow user
        }.to change { user.notifications.count }.from(2).to(1)

        expect(Notification.all).to match [
          have_attributes(parent: be_nil, children_count: 1)
        ]
      end
    end

    context "2人に follow されてから、先->後の人に unfollow" do
      let(:user) { create :user }
      let(:other1) { create :user }
      let(:other2) { create :user }

      it do
        other1.follow user
        other2.follow user

        expect {
          other1.unfollow user
          other2.unfollow user
        }.to change { user.notifications.count }.from(2).to(1)

        expect(Notification.all).to match [
          have_attributes(parent: be_nil, children_count: 0)
        ]
      end
    end

    context "2人に follow されてから、後->先の人に unfollow" do
      let(:user) { create :user }
      let(:other1) { create :user }
      let(:other2) { create :user }

      it do
        other1.follow user
        other2.follow user

        expect {
          other2.unfollow user
          other1.unfollow user
        }.to change { user.notifications.count }.from(2).to(0)
      end
    end

    context "3人に follow される" do
      let(:user) { create :user }
      let(:other1) { create :user }
      let(:other2) { create :user }
      let(:other3) { create :user }

      it do
        expect {
          other1.follow user
          other2.follow user
          other3.follow user
        }.to change { user.notifications.count }.from(0).to(3)

        expect(Notification.all).to match [
          have_attributes(parent: be_nil, children_count: 3),
          have_attributes(parent: be_present, children_count: 1),
          have_attributes(parent: be_present, children_count: 1),
        ]
      end
    end
  end
end
