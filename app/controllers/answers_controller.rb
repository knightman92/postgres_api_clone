class AnswersController < ApplicationController
	before_action :set_answer, only: [:show, :update, :destroy]
  include NotificationTracker

  # GET /answers
  def index
    if params[:user_id] != nil and params[:question_id] != nil and params[:points] != nil
      @answers = Answer.where("user_id = ? AND question_id = ? AND points = ?", params[:user_id], params[:question_id], params[:points])
    elsif params[:user_id] != nil and params[:question_id] != nil
      @answers = Answer.where("user_id = ? AND question_id = ?", params[:user_id], params[:question_id])
    elsif params[:points] != nil and params[:question_id] != nil
      @answers = Answer.where("points = ? AND question_id = ?", params[:points], params[:question_id])
    elsif params[:user_id] != nil and params[:points] != nil
      @answers = Answer.where("user_id = ? AND points = ?", params[:user_id], params[:points])
    elsif params[:points] != nil
      @answers = Answer.where("points = ?", params[:points])
    elsif params[:user_id] != nil
      @answers = Answer.where("user_id = ?", params[:user_id])
    elsif params[:question_id] != nil
      @answers = Answer.where("question_id = ?", params[:question_id])
    else
      @answers = Answer.all
    end
    json_response(@answers)
  end

  # POST /answers
  def create
    puts params 
    @answer = Answer.create!(answer_params)
    addPointsToPlayer(params[:user_id], params[:points]);
    # if @answer[:points] == 1
    #   incrementNotification(params[:question_id], params[:user_id])
    # else
    #   puts params
    #   resetCounter(params[:question_id], params[:user_id])
    # end
    json_response(@answer, :created)
  end

  # GET /answers/:id
  def show
    json_response(@answer)
  end

  # PUT /answers/:id
  def update
    @answer.update(answer_params)
    head :no_content
  end

  # DELETE /answers/:id
  def destroy
    @answer.destroy
    head :no_content
  end

  private

  def answer_params
    # whitelist params
    params.permit( :answer, :user_id, :question_id, :points )
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end