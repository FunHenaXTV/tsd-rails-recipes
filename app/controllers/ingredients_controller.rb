class IngredientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ingredient, only: %i[ show edit update destroy ]
  before_action :authorize_creator!, only: %i[ edit update destroy ]

  # GET /ingredients or /ingredients.json
  def index
    @ingredients = Ingredient.all
  end

  # GET /ingredients/1 or /ingredients/1.json
  def show
  end

  # GET /ingredients/new
  def new
    @ingredient = Ingredient.new
  end

  # GET /ingredients/1/edit
  def edit
  end

  # POST /ingredients or /ingredients.json
  def create
    @ingredient = Ingredient.new(ingredient_params)
    @recipe = @ingredient.recipe

    unless @recipe&.creator == current_user
      redirect_to recipe_url(@recipe), alert: "You are not authorized to add ingredients to this recipe."
      return
    end

    respond_to do |format|
      if @ingredient.save
        format.html { redirect_to recipe_url(@ingredient.recipe), notice: "Ingredient was successfully created." }
        format.json { render :show, status: :created, location: @ingredient }
      else
        format.html { redirect_to recipe_url(@ingredient.recipe), alert: @ingredient.errors.full_messages.to_sentence }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ingredients/1 or /ingredients/1.json
  def update
    respond_to do |format|
      if @ingredient.update(ingredient_params)
        format.html { redirect_to recipe_url(@ingredient.recipe), notice: "Ingredient was successfully updated." }
        format.json { render :show, status: :ok, location: @ingredient }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ingredients/1 or /ingredients/1.json
  def destroy
    @recipe = @ingredient.recipe
    @ingredient.destroy

    respond_to do |format|
      format.html { redirect_to recipe_url(@recipe), notice: "Ingredient was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ingredient
      @ingredient = Ingredient.find(params[:id])
    end

    def authorize_creator!
      unless @ingredient.recipe.creator == current_user
        redirect_to recipe_url(@ingredient.recipe), alert: "You are not authorized to perform this action."
      end
    end

    # Only allow a list of trusted parameters through.
    def ingredient_params
      params.require(:ingredient).permit(:name, :quantity, :recipe_id, :photo)
    end
end
