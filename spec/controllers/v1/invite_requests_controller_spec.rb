require 'spec_helper'

describe V1::InviteRequestsController do
  let(:user) { create(:user) }
  let(:group) { double(:group, id: 1, owner: user) }
  let(:another_user) { create(:user) }

  before do
    sign_in(user)
  end

  it_behaves_like('a controller that requires an authentication') do
    let(:action) { :create }
    let(:method) { :post }
  end

  subject { response }

  describe '#create' do
    before do
      Group.stub(find_by_id: group)
      group.stub_chain(:users, :exists?).and_return(false)
    end


    context 'inviting person' do
      let(:params) do
        {
          group_id: group.id,
          email: generate(:email),
          type: 'INVITE',
          format: :json
        }
      end

      context 'with valid params' do
        before do
          InviteRequest.any_instance.stub(save: true)

          post :create, params
        end

        it_behaves_like 'a :created response'
      end

      context 'with invalid params' do
        before do
          group.stub_chain(:users, :exists?).and_return(true)

          post :create, params
        end

        it_behaves_like 'an :unprocessable_entity response'
      end
    end

    context 'requesting membership' do
      let(:params) do
        {
          group_id: group.id,
          type: 'REQUEST_MEMBERSHIP',
          format: :json
        }
      end

      context 'with valid params' do
        let(:group) { double(:group, id: 2, owner: another_user) }

        before do
          InviteRequest.any_instance.stub(save: true)

          post :create, params
        end

        it_behaves_like 'a :created response'
      end

      context 'with invalid params' do
        before do
          post :create, params
        end

        it_behaves_like 'an :unprocessable_entity response'
      end
    end
  end

  describe '#handle' do
    let(:invite_request) do
      double(id: 1, sender: user, group_id: group.id, email: another_user.email)
    end
    let(:membership_request) { create(:membership_request, sender: another_user, group: group) }
    let(:invite_request_params) do
      {
        id: invite_request.id,
        accept: true,
        user: another_user.id,
        format: :json
      }
    end

    let(:membership_request_params) do
      {
        id: membership_request.id,
        accept: true,
        user: another_user.id,
        format: :json
      }
    end

    context 'when user accepts invite' do
      let(:result) { Object.new }
      before do
        InviteRequest.stub(find: invite_request)
        invite_request.stub(:as_json)

        InviteRequestAcceptor.any_instance.stub(process: invite_request)

        sign_in(another_user)
      end

      context 'with valid params' do
        before do
          post :handle, invite_request_params
        end

        it_behaves_like 'a :created response'
      end

      context 'with invalid params' do
        before do
          invite_request.stub(errors: ['error'])

          post :handle, invite_request_params
        end

        it_behaves_like 'an :unprocessable_entity response'
      end
    end

    context 'when group owner accepts membership request' do
      before { sign_in(user) }

      context 'with valid params' do
        before do
          post :handle, membership_request_params
        end

        it_behaves_like 'a :created response'
      end

      context 'with invalid params' do
        before do
          post :handle, membership_request_params.merge(user: user.id)
        end

        it_behaves_like 'an :unprocessable_entity response'
      end
    end

    context 'when user rejects invite' do
      before { sign_in(another_user) }

      context 'with valid params' do
        before do
          post :handle, invite_request_params.merge(accept: false)
        end

        it_behaves_like 'a :no_content response'
      end

      context 'with invalid params' do
        before do
          post :handle, invite_request_params.merge(accept: false, user: user.id)
        end

        it_behaves_like 'an :unprocessable_entity response'
      end
    end

    context 'when group owner rejects membership request' do
      before { sign_in(user) }

      context 'with valid params' do
        before do
          post :handle, membership_request_params.merge(accept: false)
        end

        it_behaves_like 'a :no_content response'
      end

      context 'with invalid params' do
        before do
          post :handle, membership_request_params.merge(accept: false, user: -1)
        end

        it_behaves_like 'an :unprocessable_entity response'
      end
    end
  end
end
