# surveys/views.py
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.db import connection
from .serializers import SurveySerializer

@api_view(['POST'])
def create_survey(request):
    serializer = SurveySerializer(data=request.data)
    if serializer.is_valid():
        name = serializer.validated_data['name']
        description = serializer.validated_data['description']

        # Use raw SQL to insert into the database and retrieve the last inserted Survey_ID
        with connection.cursor() as cursor:
            cursor.execute(
                "INSERT INTO mydb.Surveys (name, description) VALUES (%s, %s)",
                [name, description]
            )
            cursor.execute("SELECT LAST_INSERT_ID()")  # Retrieve the Survey_ID of the last inserted survey
            survey_id = cursor.fetchone()[0]

        # Return the Survey_ID along with the success message
        return Response({"message": "Survey created successfully", "survey_id": survey_id}, status=status.HTTP_201_CREATED)

    # Return validation errors if the input is invalid
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def list_surveys(request):
    # SQL query to retrieve the survey data (id, name, and description)
    query = "SELECT Survey_ID, name, description FROM mydb.Surveys"
    
    # Execute the query and fetch the results
    with connection.cursor() as cursor:
        cursor.execute(query)
        rows = cursor.fetchall()

    # Transform the results into a list of dictionaries for JSON response
    surveys = [
        {"id": row[0], "name": row[1], "description": row[2]}
        for row in rows
    ]
    
    # Return the data as a JSON response
    return Response(surveys)

@api_view(['POST'])
def add_textual_question(request):
    # Retrieve required fields from the request data
    survey_position = request.data.get('SurveyPosition')  # Provided SurveyPosition
    question_text = request.data.get('QuestionText')
    char_limit = request.data.get('CharLimit')
    surveys_survey_id = request.data.get('Surveys_Survey_ID')

    # Validate that all required fields are provided
    if survey_position is None or question_text is None or char_limit is None or surveys_survey_id is None:
        return Response(
            {"error": "SurveyPosition, QuestionText, CharLimit, and Surveys_Survey_ID are required fields."},
            status=status.HTTP_400_BAD_REQUEST
        )

    try:
        with connection.cursor() as cursor:
            # Step 1: Insert into the Question table with SurveyPosition provided in the request
            question_query = """
                INSERT INTO mydb.Question (SurveyPosition, QuestionText, Surveys_Survey_ID)
                VALUES (%s, %s, %s)
            """
            cursor.execute(question_query, [survey_position, question_text, surveys_survey_id])
            
            # Step 2: Insert into the TextualQuestion table, linking to the newly created Question
            # Updated query to reflect the new composite primary key (Surveys_Survey_ID, Question_SurveyPosition)
            textual_question_query = """
                INSERT INTO mydb.TextualQuestion (CharLimit, Question_SurveyPosition, Surveys_Survey_ID)
                VALUES (%s, %s, %s)
            """
            cursor.execute(textual_question_query, [char_limit, survey_position, surveys_survey_id])

        # Return a success response if the insertion is successful
        return Response({"message": "Textual question and question created successfully."}, status=status.HTTP_201_CREATED)

    except Exception as e:
        # Handle any errors that occur during the database operations
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def add_multiple_choice_question(request):
    # Retrieve fields from the request data
    survey_position = request.data.get('SurveyPosition')
    question_text = request.data.get('QuestionText')
    surveys_survey_id = request.data.get('Surveys_Survey_ID')
    max_selection_number = request.data.get('MaxSelectionNumber')
    options = request.data.get('Options')  # Options should be a list of strings

    # Validate that all required fields are provided
    if not all([survey_position, question_text, surveys_survey_id, max_selection_number, options]):
        return Response(
            {"error": "SurveyPosition, QuestionText, Surveys_Survey_ID, MaxSelectionNumber, and Options are required fields."},
            status=status.HTTP_400_BAD_REQUEST
        )

    try:
        with connection.cursor() as cursor:
            # Step 1: Insert into the Question table
            question_query = """
                INSERT INTO mydb.Question (SurveyPosition, QuestionText, Surveys_Survey_ID)
                VALUES (%s, %s, %s)
            """
            cursor.execute(question_query, [survey_position, question_text, surveys_survey_id])

            # Step 2: Insert into the MultipleChoiceQuestion table
            multiple_choice_query = """
                INSERT INTO mydb.MultipleChoiceQuestion (MaxSelectionNumber, Question_SurveyPosition, Surveys_Survey_ID)
                VALUES (%s, %s, %s)
            """
            cursor.execute(multiple_choice_query, [max_selection_number, survey_position, surveys_survey_id])

            # Step 3: Insert each option into the MultipleChoiceOption table
            for idx, option_text in enumerate(options):
                option_query = """
                    INSERT INTO mydb.MultipleChoiceOption (OptionPosition, OptionText, Surveys_Survey_ID, Question_SurveyPosition)
                    VALUES (%s, %s, %s, %s)
                """
                cursor.execute(option_query, [idx + 1, option_text, surveys_survey_id, survey_position])  # OptionPosition is based on array index

        # Return success response
        return Response({"message": "Multiple choice question and options created successfully."}, status=status.HTTP_201_CREATED)

    except Exception as e:
        # Handle any errors that occur during the database operations
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
def get_questions_by_survey(request, survey_id):
    # Validate the survey_id parameter
    if not survey_id:
        return Response({"error": "Survey ID is required."}, status=status.HTTP_400_BAD_REQUEST)
    
    try:
        with connection.cursor() as cursor:
            # Retrieve survey details (name and description)
            survey_query = """
                SELECT name, description
                FROM mydb.Surveys
                WHERE Survey_ID = %s
            """
            cursor.execute(survey_query, [survey_id])
            survey = cursor.fetchone()
            
            if not survey:
                return Response({"error": "Survey not found."}, status=status.HTTP_404_NOT_FOUND)
            
            survey_data = {
                "title": survey[0],
                "description": survey[1],
                "questions": []
            }

            # SQL query to retrieve questions related to the given Survey_ID
            questions_query = """
                SELECT q.SurveyPosition, q.QuestionText, q.Surveys_Survey_ID
                FROM mydb.Question q
                WHERE q.Surveys_Survey_ID = %s
                ORDER BY q.SurveyPosition
            """
            cursor.execute(questions_query, [survey_id])
            rows = cursor.fetchall()

            for row in rows:
                question = {
                    "SurveyPosition": row[0],
                    "QuestionText": row[1],
                    "SurveyID": row[2],
                    "QuestionType": None,  # Default to None, will populate if it's a textual or multiple-choice question
                    "Options": []  # Default to an empty list, will populate if it's a multiple-choice question
                }

                # Check if it's a multiple-choice question
                mc_query = """
                    SELECT MaxSelectionNumber
                    FROM mydb.MultipleChoiceQuestion mcq
                    WHERE mcq.Question_SurveyPosition = %s AND mcq.Surveys_Survey_ID = %s
                """
                cursor.execute(mc_query, [row[0], survey_id])
                mc_result = cursor.fetchone()

                if mc_result:
                    # It's a multiple-choice question
                    question["QuestionType"] = "MultipleChoice"
                    question["MaxSelectionNumber"] = mc_result[0]

                    # Retrieve the options for the multiple-choice question
                    options_query = """
                        SELECT OptionPosition, OptionText
                        FROM mydb.MultipleChoiceOption mco
                        WHERE mco.Question_SurveyPosition = %s AND mco.Surveys_Survey_ID = %s
                        ORDER BY mco.OptionPosition
                    """
                    cursor.execute(options_query, [row[0], survey_id])
                    options = cursor.fetchall()
                    question["Options"] = [{"OptionPosition": opt[0], "OptionText": opt[1]} for opt in options]
                
                else:
                    # Check if it's a textual question
                    tq_query = """
                        SELECT CharLimit
                        FROM mydb.TextualQuestion tq
                        WHERE tq.Question_SurveyPosition = %s AND tq.Surveys_Survey_ID = %s
                    """
                    cursor.execute(tq_query, [row[0], survey_id])
                    tq_result = cursor.fetchone()

                    if tq_result:
                        # It's a textual question
                        question["QuestionType"] = "Textual"
                        question["CharLimit"] = tq_result[0]

                survey_data["questions"].append(question)

        # Return the survey details along with the questions
        return Response(survey_data, status=status.HTTP_200_OK)

    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)



@api_view(['POST'])
def add_textual_response(request):
    # Retrieve required fields from the request data
    response_text = request.data.get('ResponseText')
    question_survey_position = request.data.get('Question_SurveyPosition')
    surveys_survey_id = request.data.get('Surveys_Survey_ID')
    user_user_id = request.data.get('User_User_ID')

    # Validate that all required fields are provided
    if not all([response_text, question_survey_position, surveys_survey_id, user_user_id]):
        return Response(
            {"error": "ResponseText, Question_SurveyPosition, Surveys_Survey_ID, and User_User_ID are required fields."},
            status=status.HTTP_400_BAD_REQUEST
        )

    try:
        with connection.cursor() as cursor:
            # Step 1: Insert into the TextualResponse table
            textual_response_query = """
                INSERT INTO mydb.TextualResponse (ResponseText, Question_SurveyPosition, Surveys_Survey_ID, User_User_ID)
                VALUES (%s, %s, %s, %s)
            """
            cursor.execute(textual_response_query, [response_text, question_survey_position, surveys_survey_id, user_user_id])

        # Return success response if insertion is successful
        return Response({"message": "Textual response created successfully."}, status=status.HTTP_201_CREATED)

    except Exception as e:
        # Handle any errors that occur during the database operations
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    

@api_view(['POST'])
def add_multiple_choice_response(request):
    # Retrieve required fields from the request data
    selected_option = request.data.get('SelectedOption')
    user_user_id = request.data.get('User_User_ID')
    surveys_survey_id = request.data.get('Surveys_Survey_ID')
    question_survey_position = request.data.get('Question_SurveyPosition')

    # Validate that all required fields are provided
    if not all([selected_option, user_user_id, surveys_survey_id, question_survey_position]):
        return Response(
            {"error": "SelectedOption, User_User_ID, Surveys_Survey_ID, and Question_SurveyPosition are required fields."},
            status=status.HTTP_400_BAD_REQUEST
        )

    try:
        with connection.cursor() as cursor:
            # Step 1: Insert into the MultipleChoiceResponse table
            multiple_choice_response_query = """
                INSERT INTO mydb.MultipleChoiceResponse (SelectedOption, User_User_ID, Surveys_Survey_ID, Question_SurveyPosition)
                VALUES (%s, %s, %s, %s)
            """
            cursor.execute(multiple_choice_response_query, [selected_option, user_user_id, surveys_survey_id, question_survey_position])

        # Return success response if insertion is successful
        return Response({"message": "Multiple choice response recorded successfully."}, status=status.HTTP_201_CREATED)

    except Exception as e:
        # Handle any errors that occur during the database operations
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
def get_responses(request, survey_id):
    try:
        with connection.cursor() as cursor:
            # Retrieve the survey details
            survey_query = """
                SELECT name, description
                FROM mydb.Surveys
                WHERE Survey_ID = %s
            """
            cursor.execute(survey_query, [survey_id])
            survey = cursor.fetchone()

            if not survey:
                return Response({"error": "Survey not found."}, status=status.HTTP_404_NOT_FOUND)

            survey_data = {
                "survey_id": survey_id,
                "title": survey[0],
                "description": survey[1],
                "multiple-choice-questions": [],
                "textual-questions": []
            }

            # Fetch all questions for the survey
            questions_query = """
                SELECT q.SurveyPosition, q.QuestionText
                FROM mydb.Question q
                WHERE q.Surveys_Survey_ID = %s
                ORDER BY q.SurveyPosition
            """
            cursor.execute(questions_query, [survey_id])
            questions = cursor.fetchall()

            for question in questions:
                survey_position, question_text = question

                # Check for multiple-choice questions
                mc_question_query = """
                    SELECT mcq.MaxSelectionNumber
                    FROM mydb.MultipleChoiceQuestion mcq
                    WHERE mcq.Question_SurveyPosition = %s AND mcq.Surveys_Survey_ID = %s
                """
                cursor.execute(mc_question_query, [survey_position, survey_id])
                mc_result = cursor.fetchone()

                if mc_result:
                    # It's a multiple-choice question
                    mc_question = {
                        "question_text": question_text,
                        "survey_position": survey_position,
                        "multiple-choice-options": [],
                        "multiple-choice-responses": []
                    }

                    # Retrieve the options
                    options_query = """
                        SELECT OptionPosition, OptionText
                        FROM mydb.MultipleChoiceOption
                        WHERE Question_SurveyPosition = %s AND Surveys_Survey_ID = %s
                        ORDER BY OptionPosition
                    """
                    cursor.execute(options_query, [survey_position, survey_id])
                    options = cursor.fetchall()
                    mc_question["multiple-choice-options"] = [opt[1] for opt in options]

                    # Retrieve the responses
                    responses_query = """
                        SELECT SelectedOption
                        FROM mydb.MultipleChoiceResponse
                        WHERE Question_SurveyPosition = %s AND Surveys_Survey_ID = %s
                    """
                    cursor.execute(responses_query, [survey_position, survey_id])
                    responses = cursor.fetchall()
                    mc_question["multiple-choice-responses"] = [resp[0] for resp in responses]

                    survey_data["multiple-choice-questions"].append(mc_question)

                # Check for textual questions
                else:
                    textual_question_query = """
                        SELECT tq.CharLimit
                        FROM mydb.TextualQuestion tq
                        WHERE tq.Question_SurveyPosition = %s AND tq.Surveys_Survey_ID = %s
                    """
                    cursor.execute(textual_question_query, [survey_position, survey_id])
                    tq_result = cursor.fetchone()

                    if tq_result:
                        # It's a textual question
                        textual_question = {
                            "question_text": question_text,
                            "survey_position": survey_position,
                            "textual-responses": []
                        }

                        # Retrieve the responses
                        textual_responses_query = """
                            SELECT ResponseText
                            FROM mydb.TextualResponse
                            WHERE Question_SurveyPosition = %s AND Surveys_Survey_ID = %s
                        """
                        cursor.execute(textual_responses_query, [survey_position, survey_id])
                        responses = cursor.fetchall()
                        textual_question["textual-responses"] = [resp[0] for resp in responses]

                        survey_data["textual-questions"].append(textual_question)

        return Response(survey_data, status=status.HTTP_200_OK)

    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
