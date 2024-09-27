class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:notice] = "User successfully created. Please log in."
      redirect_to login_path
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :new
    end
  end

  def show
    @debts_as_payer = Debt.where(payer: @user)
    @debts_as_payee = Debt.where(payee: @user)

    @unpaid_debts_as_payer = @debts_as_payer.where(is_paid: false)
    @unpaid_debts_as_payee = @debts_as_payee.where(is_paid: false)

    @paid_debts_as_payer = @debts_as_payer.where(is_paid: true)
    @paid_debts_as_payee = @debts_as_payee.where(is_paid: true)

    @total_debt = @unpaid_debts_as_payer.sum(:amount) - @unpaid_debts_as_payee.sum(:amount)
    @total_paid_debts = @paid_debts_as_payer.count + @paid_debts_as_payee.count
    @open_debts = @unpaid_debts_as_payer.count + @unpaid_debts_as_payee.count
  end


  def edit
    # Load the edit profile view
  end

  def update
    if @user.update(user_update_params)
      flash[:notice] = "Profil erfolgreich aktualisiert."
      redirect_to groups_path  # Leitet zur Gruppenübersicht weiter
    else
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def user_update_params
    if params[:user][:password].blank?
      params.require(:user).permit(:username, :email)
    else
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
  end
end
