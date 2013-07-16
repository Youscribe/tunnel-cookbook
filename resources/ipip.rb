actions :create, :install
default_action :create

attribute :host, :kind_of => String, :name_attribute => true
attribute :local, :kind_of => String
attribute :remote, :kind_of => String, :required => true
attribute :interface, :kind_of => String, :required => true, :default => node["tunnel"]["default_interface"]
attribute :ttl, :kind_of => Int

def initialize(*args)
  super
  @action = :install
end

attr_accessor :launched, :installed
