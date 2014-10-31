require "rubygems"
require "mongoid"
require "mongoid-locker"

class Activity
	include Mongoid::Document
	include Mongoid::Locker
	include Mongoid::Timestamps

	field :object,	type: String
	field :prev,		type: String

end
