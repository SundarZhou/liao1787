class PasswordsController < Devise::PasswordsController
  def create
    redirect_to '/404.html'
  end

  def new
    redirect_to '/404.html'
  end

  def edit
    redirect_to '/404.html'
  end

  def update
    redirect_to '/404.html'
  end
end