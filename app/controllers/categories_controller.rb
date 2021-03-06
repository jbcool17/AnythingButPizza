class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    if @current_user.nil?
        redirect_to root_path
    else
      @categories = Category.all
      @in_area = []
      @list_items = []
      @items = Item.all
      unless params[:postcode].nil?
        @items.each do |item|
          if @in_area.index(item.category).nil?
            @in_area << item.category if item.user.postcode == params[:postcode]
          end
          @list_items << item if item.user.postcode == params[:postcode]
        end
      else
        @items.each do |item|
          if @in_area.index(item.category).nil?
            @in_area << item.category if item.user.postcode == @current_user.postcode
          end
        @list_items << item if item.user.postcode == @current_user.postcode
        end
      end
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    unless @current_user
      redirect_to root_path
    end
  end

  # GET /categories/new
  def new
    unless @current_user
      redirect_to root_path
    end
    @category = Category.new

  end

  # GET /categories/1/edit
  def edit
    unless @current_user
      redirect_to root_path
    end
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        flash[:category_id] = @category.id
        format.html { redirect_to new_item_path, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:types)
    end
end
