class DebtsController < ApplicationController
  before_action :set_group
  before_action :set_debt, only: [:update]

  def new
    @debt = Debt.new
    @users = @group.users
  end

  def create
    @debt = @group.debts.new(debt_params)
    @debt.payer = current_user
    @debt.is_paid = false  # Setzt den Standardwert für is_paid auf false

    if @debt.save
      redirect_to group_path(@group), notice: 'Debt successfully added.'
    else
      render :new
    end
  end

  def update
    if params[:mark_as_paid] && !@debt.is_paid
      @debt.update(is_paid: true)
      # Return 204 No Content for AJAX to indicate success
      head :no_content
    else
      # Return 422 Unprocessable Entity if there's an error
      head :unprocessable_entity
    end
  end

  private

  def set_group
    @group = current_user.groups.find(params[:group_id])
  end

  def set_debt
    @debt = @group.debts.find(params[:id])
  end

  def debt_params
    params.require(:debt).permit(:amount, :description, :payee_id)
  end
end
