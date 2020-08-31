class ItemsController < ApplicationController
  before_action :set_item, except: [:index, :new, :create]

  def index
  end
  
  def new
    if user_signed_in?
    @item = Item.new
    @item.images.new
    @category_parent_array = ["---"]
      Category.where(ancestry: nil).each do |parent|
        @category_parent_array << parent.name
      end
    else
      flash[:alert] = '出品するには、ログインするか新規会員登録をしてください。'
      redirect_to root_path
    end
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
  end

  def get_category_children
    respond_to do |format| 
      format.html
      format.json do
        @children = Category.find(params[:parent_id]).children
      end
    end
  end
  
  def get_category_grandchildren
    respond_to do |format| 
      format.html
      format.json do
        @grandchildren = Category.find("#{params[:child_id]}").children
      end
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :explain,:category_id, :brand, :state_id, :shipping_burden_id, :prefecture_id, :shipping_day_id, :price).merge(seller_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

end
