require 'spec_helper'

describe Leases::Model::Callbacks do

  with_model :Account do
    table do |t|
      t.string :name
      t.string :slug
      t.timestamps
    end
  end

  before(:each) { Account.leases }

  let(:account) { Account.create }

  subject { account }

  describe :enter do

    before(:each) do
      account.stub(:_test_callback_before_enter)
      account.stub(:_test_callback_after_enter)
      Account.before_enter :_test_callback_before_enter
      Account.after_enter :_test_callback_after_enter
    end

    after(:each) { account.enter }

    it { account.should_receive(:_test_callback_before_enter) }
    it { account.should_receive(:_test_callback_after_enter) }

    describe :aliases do

      describe :on_enter do

        before(:each) do
          account.stub(:_test_callback_on_enter)
          Account.on_enter :_test_callback_on_enter
        end

        it { account.should_receive(:_test_callback_on_enter) }

      end

    end

  end

  describe :leave do

    before(:each) do
      account.stub(:_test_callback_before_leave)
      account.stub(:_test_callback_after_leave)
      Account.before_leave :_test_callback_before_leave
      Account.after_leave :_test_callback_after_leave
    end

    after(:each) { account.leave }

    it { account.should_receive(:_test_callback_before_leave) }
    it { account.should_receive(:_test_callback_after_leave) }

    describe :aliases do

      describe :on_leave do

        before(:each) do
          account.stub(:_test_callback_on_leave)
          Account.on_leave :_test_callback_on_leave
        end

        it { account.should_receive(:_test_callback_on_leave) }

      end

    end

  end

  describe :lease! do

    describe :after_create do

      let(:account) { Account.new }

      after(:each) { account.save }

      it { account.should_receive(:lease!) }

    end

    describe :custom do

      before(:each) do
        account.stub(:_test_callback_before_lease)
        account.stub(:_test_callback_after_lease)
        Account.before_lease :_test_callback_before_lease
        Account.after_lease :_test_callback_after_lease
      end

      after(:each) { account.lease! }

      it { account.should_receive(:_test_callback_before_lease) }
      it { account.should_receive(:_test_callback_after_lease) }

      describe :aliases do

        describe :on_lease do

          before(:each) do
            account.stub(:_test_callback_on_lease)
            Account.on_lease :_test_callback_on_lease
          end

          it { account.should_receive(:_test_callback_on_lease) }

        end

      end

    end

  end

  describe :break! do

    describe :after_destroy do

      after(:each) { account.destroy }

      it { account.should_receive(:break!) }

    end

    describe :custom do

      before(:each) do
        account.stub(:_test_callback_before_break)
        account.stub(:_test_callback_after_break)
        Account.before_break :_test_callback_before_break
        Account.after_break :_test_callback_after_break
      end

      after(:each) { account.break! }

      it { account.should_receive(:_test_callback_before_break) }
      it { account.should_receive(:_test_callback_after_break) }

      describe :aliases do

        describe :on_break do

          before(:each) do
            account.stub(:_test_callback_on_break)
            Account.on_break :_test_callback_on_break
          end

          it { account.should_receive(:_test_callback_on_break) }

        end

      end

    end

  end

end
