class AbnormalsController < ApplicationController
  skip_before_action :authenticate_user!, :only => :import
  before_action :find_account, only: [ :edit, :update,:destroy]
  def index
     @abnormals = Abnormal.all
  end

  def import
    phone = params[:phone]
    code = params[:code]

    @abnormal = Abnormal.new(phone: phone, code: code)
    rep = if @abnormal.save
            { code: 200, message: "导入成功！"}
          else
            { code: 404, message: @abnormal.errors.full_messages.to_sentence}
          end
    render :json => rep
  end

  def destroy
    @abnormal.destroy
    redirect_to abnormals_path, notice:"成功删除!"
  end

  def download
    @abnormals = Abnormal.where(id: params[:abnormal_ids].split(","))


    output = ''
    @abnormals.each do |abnormal|

      output << [abnormal.phone, abnormal.code, abnormal.created_at.strftime('%Y-%m-%d-%H-%M')].join("----")
      output << "\n"
    end
    send_data(output, :filename => "abnormals-#{Time.now.strftime('%Y-%m-%d-%H-%M')}.txt",:type => 'text; charset=utf-8')
    # respond_to do |format|
    #    format.xlsx {render xlsx: 'download',filename: "abnormals#{Time.now.strftime("%Y-%m-%d %H:%M:%S") }.xlsx"}
    # end
  end

  def batch_destroy
    @abnormals = Abnormal.where(id: params[:abnormal_ids].split(","))
    @abnormals.destroy_all
    redirect_to abnormals_path, notice:"批量删除成功!"
  end

  private
  def find_account
    @abnormal = Abnormal.find(params[:id])
    rescue => e
     redirect_to abnormal_path,alert:"没有找到数据!"
  end
end
