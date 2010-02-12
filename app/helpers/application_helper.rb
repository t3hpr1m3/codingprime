# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def title
		base_title = "CodingPrime"
		if @title.nil? or @title.length.eql? 0
			base_title
		else
			"#{base_title} :: #{@title}"
		end
	end
end
