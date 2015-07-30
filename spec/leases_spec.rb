require 'spec_helper'

describe Leases do

  with_model :Account do
    table do |t|
      t.string :name
      t.timestamps
    end
    model do
      leases
    end
  end

  describe :leasing do

    before(:each) { Leases.leasing(Account) }

    it { Leases.leasers.should == ['Account'] }
    it { Apartment.excluded_models.should include 'Account' }

  end

  describe :leaser_names do

    before(:each) { Apartment.tenant_names = Proc.new { Leases.leaser_names } }

    let!(:account_1) { Account.create }
    let!(:account_2) { Account.create }

    it { Leases.leaser_names.should == [account_1.leaser_name, account_2.leaser_name] }
    it { Apartment.tenant_names.should == Leases.leaser_names }

  end

  describe :current do

    it 'should get current leaser from Thread' do
      account = Account.create

      Leases.current = account
      Leases.current.should == account
    end

  end

end
