class InformationsController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:get_data, :update_data]
  before_action :find_data, only: [ :edit, :update,:destroy]
  def index
    @informations = Information.all
  end

  def new
    @information = Information.new
  end

  def create
    @information = Information.new
    errors = []
    if params[:tasks_file].present?
      file = params[:tasks_file]
      if file.original_filename.split('.').last == 'txt'
        datas = []
        File.open(file.path).each do |line|
          account, link = line.split("----")
          datas << {account: account, link: link.chomp} if account.present? && link.present?
        end
        if datas.present?
          begin
            ActiveRecord::Base.transaction do
              Information.import datas
            end
          rescue Exception => e
            redirect_to informations_path, notice: e
          end

          redirect_to informations_path, notice: "上传成功！"
        else
          redirect_to informations_path, notice: "没有数据"
        end

      else
        redirect_to informations_path, notice: "约定好的文件格式为 XXX.txt"
      end
    else
      redirect_to informations_path, notice: "上传有误，请检查数据重新上传！"
    end
  end

  def destroy
    @data.destroy
    redirect_to informations_path, notice:"成功删除!"
  end

  def batch_destroy
    @informations = Information.where(id: params[:information_ids].split(","))
    @informations.destroy_all
    redirect_to informations_path, notice:"批量删除成功!"
  end

  def batch_update
    @informations = Information.where(id: params[:information_ids].split(",")).where(is_use: 1)
    @informations.update_all(is_use: 0)
    redirect_to informations_path, notice:"待修改数据批量修改成功!"
  end

  def get_data
    @information = Information.where(is_use: false).first

    begin
      rep = if @information.present?
            @information.update(is_use: 1)
            {
              code: 200,
              data: {id: @information.id, account: @information.account, link: @information.link, status: true },
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
    @data = Information.find_by_id(params[:id])
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
    @data = Information.find(params[:id])
    if @data.update(is_use: 0)
      redirect_to informations_path, notice: "更新成功!"
    else
      redirect_to informations_path, alert: @data.errors.full_messages.to_sentence
    end
  end

  private
  def find_data
    @data = Information.find(params[:id])
    rescue => e
     redirect_to informations_path,alert:"没有找到数据!"
  end

end
