# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < ApiController
      def index
        @questions = Question.includes(:answers)
      end

      def show
        @question = Question.find(params[:id])
      end

      def create
        @question = Question.new(question_params)
        raise ActionController::BadRequest.new 'Answers should be filled' if @question.answers.empty?
        @question.save!

        render status: :created
      end

      private

      def question_params
        new_params = params.permit(:title, :description, :endingDate, answers: [:title, :description])
        new_params[:ending_date] = new_params.delete :endingDate if params[:endingDate]
        new_params[:answers_attributes] = new_params.delete :answers if params[:answers]
        new_params
      end
    end
  end
end
