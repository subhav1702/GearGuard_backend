class EquipmentsController < ApplicationController
    before_action :set_equipment, only: %i[show update destroy requests]
  
    # GET /equipment
    # Supports filtering by employee OR department
    def index
      equipment = Equipment.all
  
      equipment = equipment.where(owner_id: params[:employee_id]) if params[:employee_id].present?
      equipment = equipment.where(department_id: params[:department_id]) if params[:department_id].present?
  
      render json: equipment
    end
  
    def show
      render json: @equipment
    end
  
    def create
      equipment = Equipment.new(equipment_params)
  
      # ensure each equipment has DEFAULT TECHNICIAN
      equipment.default_technician ||= equipment.maintenance_team&.technicians&.first
  
      if equipment.save
        render json: equipment, status: :created
      else
        render json: equipment.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @equipment.update(equipment_params)
        render json: @equipment
      else
        render json: @equipment.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @equipment.destroy
      head :no_content
    end
  
    # SMART BUTTON
    # GET /equipment/:id/requests
    def requests
      render json: @equipment.maintenance_requests
    end
  
    private
  
    def set_equipment
      @equipment = Equipment.find(params[:id])
    end
  
    def equipment_params
      params.permit(
        :name,
        :serial_number,
        :location,
        :purchase_date,
        :warranty_expiry,
        :department_id,
        :maintenance_team_id,
        :default_technician_id,
        :owner_id
      )
    end
end
  