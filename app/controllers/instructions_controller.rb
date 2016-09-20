class InstructionsController < ApplicationController
  def show
    authorize(@instruction = Instruction.find(params[:id]))
  end
end
