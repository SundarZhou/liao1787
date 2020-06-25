class PlatformsController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:import, :get_data, :update_data]
  before_action :find_data, only: [ :edit, :update,:destroy]
  def index
    @platform = Platform.all
  end

  def destroy
    @data.destroy
    redirect_to platforms_path, notice:"成功删除!"
  end

  def batch_destroy
    @platform = Platform.where(id: params[:platform_ids].split(","))
    @platform.destroy_all
    redirect_to platforms_path, notice:"批量删除成功!"
  end

  def batch_update
    @platform = Platform.where(id: params[:platform_ids].split(",")).where(is_use: 1)
    @platform.update_all(is_use: 0)
    redirect_to platforms_path, notice:"待修改数据批量修改成功!"
  end

   def import
    data = params[:data]

    @platform = Platform.new(data: data)
    rep = if @platform.save
            { code: 200, message: "导入成功！"}
          else
            { code: 404, message: @platform.errors.full_messages.to_sentence}
          end
    render :json => rep
  end

  def get_data
    @platform = Platform.where(is_use: 0).first

    begin
      rep = if @platform.present?
            @platform.update(is_use: 1)
            {
              code: 200,
              data: {id: @platform.id, token: @platform.data},
              message: "返回成功！"
            }
          else
            {
              code: 200,
              data: {status: false},
              message: "没有可用数据"
            }
          end
    rescue Exception => e
      {
        code: 404,
        data: {status: false},
        message: e
      }
    end
    render :json => rep
  end

  def update_data
    @data = Platform.find_by_id(params[:id])
    rep = if @data.present?
            if @data.update(is_use: 2)
              {
                code: 200,
                message: "更新成功"
              }
            else
              {
                code: 404,
                message: @data.errors.full_messages.to_sentence
              }
            end
          else
            {
              code: 404,
              message: "数据不存在"
            }
          end
    render :json => rep
  end

  def update
    @data = Platform.find(params[:id])
    if @data.update(is_use: 0)
      redirect_to platforms_path, notice: "更新成功!"
    else
      redirect_to platforms_path, alert: @data.errors.full_messages.to_sentence
    end
  end

  private
  def find_data
    @data = Platform.find(params[:id])
    rescue => e
     redirect_to platforms_path,alert:"没有找到数据!"
  end

end