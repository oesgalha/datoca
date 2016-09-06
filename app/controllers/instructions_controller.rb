class InstructionsController < ApplicationController
  def show
    @instruction = Instruction.find(params[:id])
  end
end
