shared_examples 'a controller that requires an authentication' do
  let(:action) { :index }
  let(:params) { { format: :json } }
  let(:method) { :get }

  before { sign_out(:user) }

  it 'responds unauthorized with an HTTP 401 status code' do
    send(method, action, params)
    expect(response.code).to eq('401')
  end
end

shared_examples 'a successfull GET request' do
  let(:action) { :index }
  let(:params) { { format: :json } }

  before { get action, params }

  subject { response }

  it { should be_success }
  its(:code) { should eq('200') }
end

shared_examples 'a successfull DELETE request' do
  let(:action) { :destroy }
  let(:params) { { format: :json} }

  before { delete action, params }

  subject { response }

  it { should be_success }
  its(:code) { should eq('204') }
end

shared_examples 'a successfull PUT request' do
  let(:action) { :update }
  let(:params) { { format: :json} }

  before { put action, params }

  subject { response }

  it { should be_success }
  its(:code) { should eq('204') }
end
