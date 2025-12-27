class MaintenanceTeamsController < ApplicationController
    before_action :set_team, only: %i[show update add_member remove_member]

    def index
        render json: MaintenanceTeam.all
    end

    def show
        render json: @team, include: :technicians
    end

    def create
        team = MaintenanceTeam.new(team_params)

        if team.save
        render json: team, status: :created
        else
        render json: team.errors, status: :unprocessable_entity
        end
    end

    def update
        if @team.update(team_params)
        render json: @team
        else
        render json: @team.errors, status: :unprocessable_entity
        end
    end

    # POST /maintenance_teams/:id/add_member
    def add_member
        user = User.find(params[:user_id])

        @team.technicians << user unless @team.technicians.include?(user)

        render json: { message: "Technician added" }
    end

    # DELETE /maintenance_teams/:id/remove_member
    def remove_member
        user = User.find(params[:user_id])

        @team.technicians.destroy(user)

        render json: { message: "Technician removed" }
    end

    private

    def set_team
        @team = MaintenanceTeam.find(params[:id])
    end

    def team_params
        params.permit(:name, :department_id)
    end
end
