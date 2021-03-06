class Api::V1::FeedsController < Api::V1::ApiController

  def show
    @user = User.where(display_name: params[:display_name]).first
    @growls = @user.growls.page(params[:page]).per(10)
    @recent_growls = @user.growls.by_date.limit(3)
  end

  def refeed
    growl = Growl.find(params[:id])
    sub = @current_user.find_subscription(params[:subscription_id])

    if growl && growl.build_regrowl_for(@current_user).try(:save)
      sub.update_last_status_id_if_necessary(growl.created_at.to_i) if sub
      render status: :created, json: "Regrowl successful"
    else
      render status: :bad_request, json: "This item cannot be regrowled."
    end
  end

  def destroy_refeed
    @current_user.growls.where(regrowled_from_id: params[:id]).first.destroy
    render status: :created, json: "Regrowl Destroyed"
  end

  def subscriber_refeed
    user = User.where(display_name: params[:display_name]).first
    growls = JSON.parse(params[:growls])
    growls.each do |growl|
      Growl.where(id: growl["id"]).first.build_regrowl_for(user).try(:save)
    end
    render status: :created, json: "Regrowling complete"
  end

end
