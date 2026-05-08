class Ingredient < ApplicationRecord
  belongs_to :recipe
  has_one_attached :photo

  validate :recipe_ingredient_limit

  private

  def recipe_ingredient_limit
    errors.add(:base, "Recipe already has the maximum of 3 ingredients") if recipe && recipe.ingredients.size >= 3
  end
end
