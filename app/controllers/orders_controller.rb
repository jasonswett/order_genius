class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    restaurant = Restaurant.find(params[:restaurant_id])
    @order = Order.new(restaurant: restaurant)

    restaurant.menu_items.each do |menu_item|
      @order.order_menu_items.new(menu_item: menu_item)
    end
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params.except(:order_menu_items))

    order_menu_items = order_params[:order_menu_items].map do |order_menu_item_hash|
      OrderMenuItem.new(order_menu_item_hash)
    end.reject { |order_menu_item| order_menu_item.quantity == 0 }

    @order.order_menu_items << order_menu_items

    respond_to do |format|
      if @order.save
        format.html { redirect_to restaurant_orders_path(@order.restaurant), notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(
        :restaurant_id,
        :customer_name,
        order_menu_items: [
          :menu_item_id,
          :quantity
        ]
      )
    end
end
