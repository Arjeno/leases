require 'leases/railtie'
require 'leases/version'
require 'leases/model'
require 'leases/controller'

module Leases

  extend self

  attr_accessor :leasers
  self.leasers = []

  # Add leaser to array of leasers.
  #
  # => leasing(Account)
  def leasing(object)
    self.leasers << object.name
    self.leasers.uniq!

    Apartment.excluded_models ||= []
    Apartment.excluded_models += [object.name]
    Apartment.excluded_models.uniq!

    Apartment.database_names = Proc.new { Leases.leaser_names }

    object
  end

  def leaser_names(preload=true)
    Rails.application.eager_load! if preload

    leasers.map do |l|
      model = l.constantize
      model.all.collect(&:leaser_name)
    end.flatten
  end

end
