require 'leases/railtie'
require 'leases/version'
require 'leases/model'
require 'leases/controller'

module Leases

  extend self

  attr_accessor :leasers
  self.leasers = []

  ##
  # Add leaser to array of leasers.
  #
  # === Example
  #
  # leasing(Account)
  #
  def leasing(object)
    self.leasers << object.name
    self.leasers.uniq!

    Apartment.tenant_names = Proc.new { Leases.leaser_names }

    object
  end

  ##
  # Leaser names currently used in the app
  #
  # === Example
  #
  # Leases.leaser_names
  #
  # === Returns
  #
  # [Array] List of leaser names
  #
  def leaser_names(preload=true)
    Rails.application.eager_load! if preload

    leasers.map do |l|
      model = l.constantize
      model.all.collect(&:leaser_name)
    end.flatten
  end

  ##
  # Returns the current leaser.
  # This method uses Thread.current and is completely thread-safe.
  #
  # === Example
  #
  # Leases.current
  #
  # === Returns
  #
  # [Object] The current leaser
  #
  def current
    Thread.current[:leaser]
  end

  ##
  # Sets the current leaser.
  #
  # === Example
  #
  # Leases.current = account
  #
  def current=(leaser)
    Thread.current[:leaser] = leaser
  end

end
