class Recipe < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :ingredients
  has_rich_text :content

  validate :max_three_ingredients

  private

  def max_three_ingredients
    errors.add(:base, "A recipe can have at most 3 ingredients") if ingredients.size > 3
  end
end
