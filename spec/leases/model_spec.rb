require 'spec_helper'

describe Leases::Model do

  with_model :Account do
    table do |t|
      t.string :name
      t.timestamps
    end
  end

  it { Account.respond_to?(:leases).should be_true }

  it 'should set up lease' do
    Account.should_receive(:setup_lease)
    Account.leases
  end

end
