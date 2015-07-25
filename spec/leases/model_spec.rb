require 'spec_helper'

describe Leases::Model do

  with_model :Account do
    table do |t|
      t.string :name
      t.timestamps
    end
  end

  describe :leases do

    it { Account.respond_to?(:leases).should be true }

    it 'should set leases_options' do
      Account.leases :name => :slug
      Account.leases_options.should == { :name => :slug }
    end

    it 'should add the class to a list of leasers' do
      Account.leases :name => :slug
      Leases.leasers.should include 'Account'
    end

  end

  describe :shared_by_leasers do

    with_model :User do
      table do |t|
        t.string :name
        t.timestamps
      end
    end

    before(:each) { User.shared_by_leasers }

    it { Apartment.excluded_models.should include 'User' }

  end

end
