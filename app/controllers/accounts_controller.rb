class AccountsController < ApplicationController
  include ActionView::Rendering
  before_action :find_account, only: [ :edit, :update,:destroy]
  skip_before_action :authenticate_user!, :only => :import_data
  def index
    @accounts = params[:is_normal].present? ?  Account.unnormal : Account.normal
  end

  def destroy
    @account.destroy
    redirect_to accounts_path(is_normal: params[:is_normal]), notice:"成功删除!"
  end

  # def update
  #   if @account.update(account_params)
  #     redirect_to account_path, notice: "修改成功！"
  #   else
  #     render 'edit'
  #   end
  # end
  def download
    @accounts = Account.where(id: params[:account_ids].split(","))

    @accounts.update_all(is_export: true)
    output = ''
    @accounts.pluck(:phone, :password, :token, :link, :time).each do |account|
      output << account.join("----")
      output << "\n"
    end
    send_data(output, :filename => "accounts-#{Time.now.strftime('%Y-%m-%d-%H-%M')}.txt",:type => 'text; charset=utf-8')
    # respond_to do |format|
    #    format.xlsx {render xlsx: 'download',filename: "accounts#{Time.now.strftime("%Y-%m-%d %H:%M:%S") }.xlsx"}
    # end
  end

  def batch_destroy
    @accounts = Account.where(id: params[:account_ids].split(","))
    @accounts.destroy_all
    redirect_to accounts_path, notice:"批量删除成功!"
  end

  def import_data
    phone = params[:phone]
    password = params[:password]
    token = params[:token]
    time = params[:time]
    operator = params[:operator]
    is_normal = params[:is_normal]
    link = params[:link]
    @account = Account.new(phone: phone, password: password, token: token, time: time, operator: operator, is_normal: is_normal, link: link)
    rep = if @account.save
            { code: 200, message: "导入成功！"}
          else
            { code: 404, message: @account.errors.full_messages.to_sentence}
          end
    render :json => rep
  end

  private
  def find_account
    @account = Account.find(params[:id])
    rescue => e
     redirect_to account_path,alert:"没有找到数据!"
  end

  # def account_params
  #   params.require(:account).permit(:title)
  # end
  def render_to_body(options)
    _render_to_body_with_renderer(options) || super
  end

  # def download_csv(accounts)
  #   CSV.generate(:col_sep => ",") do |csv|
  #     csv << ['手机号码', '密码', '数据']
  #     accounts.each do |account|
  #       csv << [account.phone, account.password, account.token]
  #     end
  #   end
  # end
end
