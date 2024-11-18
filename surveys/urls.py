# surveys/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('create-survey/', views.create_survey, name='create-survey'),
    path('surveys/', views.list_surveys, name='list_surveys'),
    path('add-textual-question/', views.add_textual_question, name='add_textual_question'),
    path('add-multiple-choice-question/', views.add_multiple_choice_question, name='add_multiple_choice_question'),
    path('questions/<int:survey_id>/', views.get_questions_by_survey, name='get_questions_by_survey'),
    path('add-textual-response/', views.add_textual_response, name='add_textual_response'),
    path('add-multiple-choice-response/', views.add_multiple_choice_response, name='add_multiple_choice_response'),
    path('get-responses/<int:survey_id>/', views.get_responses, name='get_responses'),
]