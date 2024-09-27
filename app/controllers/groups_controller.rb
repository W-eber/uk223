class GroupsController < ApplicationController
  before_action :require_login
  before_action :set_group, only: [:show, :destroy, :kick_user, :update_user_role]
  before_action :check_admin_permissions, only: [:update_user_role]
  before_action :check_moderator_permissions, only: [:kick_user]

  def index
    @groups = current_user.groups
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.group_code = generate_group_code

    if @group.save
      # Der Ersteller der Gruppe wird automatisch zum Admin
      @group.group_users.create(user: current_user, role: :admin)
      redirect_to groups_path, notice: "Group successfully created."
    else
      render :new
    end
  end

  def show
    @debts = @group.debts

    # Berechnung der Schulden nur für nicht bezahlte Schulden
    @group_members_with_debts = @group.users.map do |user|
      total_payer_debt = user.debts_as_payer.where(group: @group, is_paid: false).sum(:amount)
      total_payee_debt = user.debts_as_payee.where(group: @group, is_paid: false).sum(:amount)
      total_debt = total_payer_debt - total_payee_debt

      {
        user: user,
        total_debt: total_debt,
        role: user_role_in_group(user)  # Rolle des Benutzers in der Gruppe abrufen
      }
    end
  end

  # Benutzer aus der Gruppe entfernen (kicken)
  # Kicking a user from the group
def kick_user
  user = @group.users.find(params[:user_id])
  group_user = GroupUser.find_by(user: user, group: @group)

  if current_user.group_users.find_by(group: @group).moderator? && group_user.admin?
    redirect_to group_path(@group), alert: "Moderators cannot kick admins."
  elsif current_user.group_users.find_by(group: @group).moderator? && group_user.moderator?
    redirect_to group_path(@group), alert: "Moderators cannot kick other moderators."
  elsif @group.users.delete(user)
    redirect_to group_path(@group), notice: "#{user.username} has been kicked out of the group."
  else
    redirect_to group_path(@group), alert: "Failed to kick #{user.username}."
  end
end


  # Aktualisieren der Benutzerrolle in der Gruppe
  def update_user_role
    user = @group.users.find(params[:user_id])
    role = params[:role]

    group_user = GroupUser.find_by(user: user, group: @group)
    if group_user.update(role: role)
      redirect_to group_path(@group), notice: "#{user.username}'s role has been updated to #{role}."
    else
      redirect_to group_path(@group), alert: "Failed to update role."
    end
  end

  # Gruppe löschen (nur für Admin)
  def destroy
    if @group.users.count > 1 || @group.debts.any?
      flash[:alert] = "Group cannot be deleted while it has users or debts. Remove all members and debts before deleting."
    elsif @group.destroy
      flash[:notice] = "Group successfully deleted."
    else
      flash[:alert] = "Failed to delete the group. Please try again."
    end
    redirect_to groups_path
  end

  # Beitreten zu einer Gruppe über den Gruppencode
  def join
    @group = Group.find_by(group_code: params[:group_code])

    if @group && !current_user.groups.include?(@group)
      @group.group_users.create(user: current_user, role: :member)  # Standardrolle ist 'member'
      redirect_to groups_path, notice: "Successfully joined the group."
    else
      redirect_to groups_path, alert: "Group not found or already a member."
    end
  end

  private

  def group_params
    params.require(:group).permit(:group_name)
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def user_role_in_group(user)
    @group.group_users.find_by(user: user).role
  end

  def generate_group_code
    rand(10000..99999).to_s
  end

  # Nur der Admin kann Benutzer kicken, Rollen ändern und die Gruppe löschen
  def check_admin_permissions
    unless current_user.group_users.find_by(group: @group).admin?
      redirect_to group_path(@group), alert: "You do not have the permissions to change roles."
    end
  end

  # Admins und Moderatoren dürfen Benutzer kicken
  def check_moderator_permissions
    unless current_user.group_users.find_by(group: @group).admin? || current_user.group_users.find_by(group: @group).moderator?
      redirect_to group_path(@group), alert: "You do not have the permissions to kick users."
    end
  end
end
