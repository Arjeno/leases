require 'spec_helper'

class AnonymousController < ActionController::Base
  include Rails.application.routes.url_helpers
  def index
    @account = Thread.current[:leaser]
    @current_leaser = current_leaser
    render :text => :none
  end
end

describe Leases::Controller, :type => :controller do

  with_model :Account do
    table do |t|
      t.string :name
      t.timestamps
    end
    model do
      leases
    end
  end

  controller(AnonymousController) do
    visit_as :current_account
  end

  let(:account) { Account.create(:name => 'John Doe') }

  before(:each) do
    controller.stub(:current_account).and_return(account)
    get :index
  end

  it { assigns(:account).should == account }
  it { assigns(:current_leaser).should == account }

end
