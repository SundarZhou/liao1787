class DashboardController < ApplicationController

  def index

  end

  def edit
  end

  def update
    if @setting.update(params.require(:setting).permit(:title, :description, :domain_name))
      redirect_to root_path, notice: "修改成功！"
    else
      render 'edit'
    end
  end
end
