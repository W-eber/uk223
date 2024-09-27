# app/controllers/audits_controller.rb

class AuditsController < ApplicationController
  def index
    # Holt alle Audits und sortiert nach Erstellungsdatum
    @audits = Audited::Audit.order(created_at: :desc)
  end
end
