class RegistrationsController < Devise::RegistrationsController

  def new
    redirect_to '/404.html'
  end

  def edit
    super
  end

  def create
    redirect_to '/404.html'
  end

  def destroy
    redirect_to '/404.html'
  end

  def cancel
    redirect_to '/404.html'
  end

  def update
    super
  end

  protected
  def after_update_path_for(resource)
    root_path
  end
end