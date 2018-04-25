class EventsController < ApplicationController
    
    before_action :authenticate_user!#, :except => [ :show, :index ]

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

        #if params[:user_id].to_i != @event.user.id
            # error
        #end
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

private
    def event_params
      params.require(:event).permit(:datetime, :title, :user_ids => [])
    end
end
