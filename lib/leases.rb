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
  def leaser_names
    leasers.map do |l|
      model = l.constantize
      model.leaser_names
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
