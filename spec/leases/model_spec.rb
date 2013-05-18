require 'spec_helper'

describe Leases::Model do

  with_model :Account do
    table do |t|
      t.string :name
      t.timestamps
    end
  end

  describe :leases do

    it { Account.respond_to?(:leases).should be_true }

    it 'should set leases_options' do
      Account.leases :name => :slug
      Account.leases_options.should == { :name => :slug }
    end

  end

end
