import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

const SurveyEntry = () => {
    const { id } = useParams(); // Get survey ID from the URL
    const [survey, setSurvey] = useState(null);
    const [responses, setResponses] = useState({});

    // Fetch survey details
    useEffect(() => {
        console.log("Sending Response");
        fetch(`http://localhost:8000/api/surveys/questions/${id}/`)
            .then((res) => res.json())
            .then((data) => setSurvey(data))
            .catch((err) => console.error("Error fetching survey:", err));
    }, [id]);

    // Handle changes to responses
    const handleResponseChange = (questionId, response) => {
        setResponses((prevResponses) => ({
            ...prevResponses,
            [questionId]: response,
        }));
    };

    // Submit responses to the backend
    const submitResponses = () => {
        Object.entries(responses).forEach(([questionId, answer]) => {
            const question = survey.questions.find(
                (q) => q.SurveyPosition === parseInt(questionId)
            );

            if (question.QuestionType === "Textual") {
                fetch("http://localhost:8000/api/surveys/add-textual-response/", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({
                        ResponseText: answer,
                        Question_SurveyPosition: questionId,
                        Surveys_Survey_ID: id,
                        User_User_ID: 123, // Replace with actual user ID
                    }),
                }).catch((err) => console.error("Error submitting textual response:", err));
            } else if (question.QuestionType === "MultipleChoice") {
                fetch("http://localhost:8000/api/surveys/add-multiple-choice-response/", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({
                        SelectedOption: answer, // Submit option position
                        Question_SurveyPosition: questionId,
                        Surveys_Survey_ID: id,
                        User_User_ID: 123, // Replace with actual user ID
                    }),
                }).catch((err) => console.error("Error submitting multiple-choice response:", err));
            }
        });

        alert("Responses submitted successfully!");
    };

    if (!survey) {
        return <div>Loading survey...</div>;
    }

    return (
        <div>
            <h1>{survey.title}</h1>
            <p>{survey.description}</p>
            {survey.questions.map((question) => (
                <div key={question.SurveyPosition}>
                    <h3>{question.QuestionText}</h3>
                    {question.QuestionType === "Textual" && (
                        <textarea
                            onChange={(e) =>
                                handleResponseChange(question.SurveyPosition, e.target.value)
                            }
                        />
                    )}
                    {question.QuestionType === "MultipleChoice" &&
                        question.Options.map((option) => (
                            <label key={option.OptionPosition}>
                                <input
                                    type="radio" // Change to radio for single selection
                                    name={`question-${question.SurveyPosition}`}
                                    value={option.OptionPosition} // Use OptionPosition as the value
                                    onChange={(e) =>
                                        handleResponseChange(
                                            question.SurveyPosition,
                                            parseInt(e.target.value) // Store the position as a number
                                        )
                                    }
                                />
                                {option.OptionText}
                            </label>
                        ))}
                </div>
            ))}
            <button onClick={submitResponses}>Submit</button>
        </div>
    );
};

export default SurveyEntry;
