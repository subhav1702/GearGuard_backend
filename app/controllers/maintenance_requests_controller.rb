class MaintenanceRequestsController < ApplicationController
    before_action :set_request, only: %i[
      show update destroy
      assign_self start_work complete scrap
    ]
  
    # GET /maintenance_requests
    # supports calendar + filtering
    def index
      requests = MaintenanceRequest.includes(:equipment)
  
      requests = requests.where(request_type: params[:request_type]) if params[:request_type].present?
      requests = requests.where(maintenance_team_id: params[:team_id]) if params[:team_id].present?
  
      # Calendar view → only preventive
      if params[:calendar] == "true"
        requests = requests.where(request_type: "preventive")
      end
  
      render json: requests
    end
  
    def show
      render json: @request
    end
  
    # CREATE REQUEST (Corrective or Preventive)
    def create
      equipment = Equipment.find(params[:equipment_id])
  
      request = MaintenanceRequest.new(request_params)
      request.equipment = equipment
  
      # AUTO FILL LOGIC
      request.maintenance_team ||= equipment.maintenance_team
      request.technician ||= equipment.default_technician
      request.state ||= "new"
  
      if request.save
        render json: request, status: :created
      else
        render json: request.errors, status: :unprocessable_entity
      end
    end
  
    # UPDATE REQUEST
    def update
      if @request.update(request_params)
        render json: @request
      else
        render json: @request.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @request.destroy
      head :no_content
    end
  
    # --------------- WORKFLOW ACTIONS ----------------
  
    # STEP 4 — Technician / manager self-assigns
    def assign_self
      unless @request.maintenance_team.technicians.include?(current_user)
        return render json: { error: "You are not part of this team" }, status: :forbidden
      end
  
      @request.update(technician: current_user)
      render json: { message: "Assigned successfully", request: @request }
    end
  
    # STEP 5 — Move to In Progress
    def start_work
      @request.update(state: "in_progress")
      render json: @request
    end
  
    # STEP 6 — Complete & log duration
    def complete
      @request.update(
        state: "repaired",
        duration: params[:duration]
      )
  
      render json: @request
    end
  
    # SCRAP Logic
    def scrap
      @request.update(state: "scrap")
      @request.equipment.update(is_scrapped: true)
  
      render json: { message: "Equipment marked as scrapped" }
    end
  
    private
  
    def set_request
      @request = MaintenanceRequest.find(params[:id])
    end
  
    def request_params
      params.permit(
        :subject,
        :request_type,
        :scheduled_at,
        :duration,
        :equipment_id,
        :technician_id,
        :maintenance_team_id
      )
    end
end