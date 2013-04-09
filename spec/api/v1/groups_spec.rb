require 'spec_helper'

describe 'v1/groups' do
  let(:current_user) { FactoryGirl.create(:user) }
  let(:authentication_token) { current_user.authentication_token }
  let(:params) { FactoryGirl.attributes_for(:group) }

  subject { json_response_body }

  describe 'creating a group' do
    before do
      post 'v1/groups', params.merge(authentication_token: authentication_token)
    end

    it { should be_a_group_representation(current_user.owned_groups.first) }

    describe 'group owner should become a member of his group' do
      let(:group) { Group.find(json_response_body['id']) }
      subject { group }

      its(:users) { should include(group.owner) }
    end

    context 'when params are not valid' do
      let(:params) { { name: 'The best group ever!' } }

      it { should have_error("can't be blank").on('description') }
    end
  end

  describe 'list groups' do
    let!(:group) { FactoryGirl.create(:group) }

    before do
      get 'v1/groups', authentication_token: authentication_token
    end

    it { should be_a_kind_of Array }
    its(:first) { should be_a_group_representation(group) }
  end

  describe 'list users in a group' do
    let!(:group) { create :group, users: [current_user] }

    before do
      get "/v1/groups/#{group.id}/users",
        authentication_token: authentication_token
    end

    it { should be_a_kind_of Array }
    its(:first) { should be_a_user_representation(current_user) }
  end

  describe 'delete a group' do
    let!(:group) { create(:group, owner: current_user) }

    it 'removes group' do
      expect {
        delete "/v1/groups/#{group.id}",
          authentication_token: authentication_token
      }.to change { Group.count }
    end

    describe 'with invalid params' do
      let!(:group) { create(:group) }

      it 'does not remove group' do
        expect {
          delete "/v1/groups/#{group.id}",
            authentication_token: authentication_token
        }.not_to change { Group.count }
      end
    end
  end
end
