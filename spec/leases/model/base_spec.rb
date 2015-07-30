require 'spec_helper'

describe Leases::Model::Base do

  with_model :Account do
    table do |t|
      t.string :name
      t.string :slug
      t.timestamps
    end
  end

  before(:each) { Account.leases options }

  let(:options) { {} }
  let(:account) { Account.create(:name => 'John Doe', :slug => 'john-doe') }

  subject { account }

  describe :leaser_names do

    let!(:account_1) { Account.create(:name => 'John Doe', :slug => 'john-doe') }
    let!(:account_2) { Account.create(:name => 'Jane Doe', :slug => 'jane-doe') }

    context 'with default' do

      let(:options) { {} }

      it 'should return list of names' do
        Account.leaser_names.should == ["account-#{account_1.id}", "account-#{account_2.id}"]
      end

    end

    context 'with symbol' do

      let(:options) { { :name => :slug } }

      it 'should return list of names' do
        Account.leaser_names.should == ['john-doe', 'jane-doe']
      end

    end

    context 'with proc' do

      let(:options) { { :name => Proc.new { |a| [a.id, a.name].join('-') } } }

      it 'should return list of names' do
        Account.leaser_names.should == ["#{account_1.id}-#{account_1.name}", "#{account_2.id}-#{account_2.name}"]
      end

    end

  end

  describe :leaser_name do

    context 'default' do

      let(:options) { {} }

      its(:leaser_name) { should == "account-#{account.id}" }

    end

    context 'with symbol' do

      let(:options) { { :name => :slug } }

      its(:leaser_name) { should == account.slug }

    end

    context 'with proc' do

      let(:options) { { :name => Proc.new { |a| [a.id, a.name].join('-') } } }

      its(:leaser_name) { should == "#{account.id}-#{account.name}" }

    end

  end

  describe :enter do

    after(:each) { account.enter }

    it { Apartment::Tenant.should_receive(:switch).with(account.leaser_name) }
    it { Thread.current[:leaser].id.should == account.id }

  end

  describe :leave do

    after(:each) { account.leave }

    it { Apartment::Tenant.should_receive(:reset) }
    it { Thread.current[:leaser].should == nil }

  end

  describe :visit do

    it 'should enter and leave' do
      account.should_receive(:enter)
      account.should_receive(:leave)

      account.visit {}
    end

  end

  describe :lease! do

    after(:each) { account.lease! }

    it { Apartment::Tenant.should_receive(:create).with(account.leaser_name) }

  end

  describe :break! do

    after(:each) { account.break! }

    it { Apartment::Tenant.should_receive(:drop).with(account.leaser_name) }

  end

end
