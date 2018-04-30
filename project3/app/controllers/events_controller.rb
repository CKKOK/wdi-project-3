# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :authenticate_user! # , :except => [ :show, :index ]
  
  def index
    if params[:user_id]
      @user = User.find(current_user.id)
      @events = @user.events.all
    else
      # sign in
    end
  end

  def show
    @user = User.find(current_user.id)
    @event = @user.events.find(params[:id])

    # if params[:user_id].to_i != @event.user.id
    # error
    # end
  end

  def new
    @event = Event.new
    @user = User.find(params[:user_id])
  end

  def edit
    @user = User.find(current_user.id)
    @event = @user.events.find(params[:id])
  end

  def create
    @event = Event.new(event_params)
    @user = User.find(current_user.id)

    @event.save
    @user.events << @event

    @rsvp = Rsvp.new(event_id: @user.events.last.id, user_id: current_user.id, name: current_user.username, email: current_user.email)
    @rsvp.save

    @eventuserdata = EventUserDatum.new(rsvp_id: @rsvp.id, user_role: :owner)
    @eventuserdata.save

    redirect_to user_events_path(@user)
  end

  def update
    @event = Event.find(params[:id])

    @event.update(event_params)
    redirect_to user_events_path(current_user.id)
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to user_events_path(current_user.id)
  end

  def attendance
    @event = Event.find(params[:event_id])
    @event_user_data = []
    @event.rsvps.each do |r|
      @event_user_data << r.event_user_datum
    end
  end

  def attendance_scanner
    @event = Event.find(params[:event_id])
    
  end

  private

  def event_params
    params.require(:event).permit(:datetime, :title, user_ids: [])
  end
end
