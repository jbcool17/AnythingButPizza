# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :text
#  servings    :integer
#  cost        :float
#  description :text
#  tags        :text
#  image       :text
#  active      :boolean
#  user_id     :integer
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Item < ActiveRecord::Base
	has_many :line_items
	has_many :shopping_carts, :through => :line_items
	belongs_to :user
	belongs_to :category

	def is_active 
		if self.servings == 0
			self.active = false
		end
		active
	end

	def servings_left
  		remaining = self.servings
  		self.line_items.each do |line_item|
  			remaining -= (line_item.quantity_purchased) if line_item.shopping_cart.active
  		end
  		remaining
	end
end
