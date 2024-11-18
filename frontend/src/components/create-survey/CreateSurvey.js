import { useEffect, useRef, useState } from "react";
import Fab from "../fab/Fab";
import Overlay from "../overlay/Overlay";
import NewQuestion from "../new-question/NewQuestion";
import { publish, OVERLAY_TOGGLE, subscribe } from "../../util/events";
import QuestionDraft from "../question-draft/QuestionDraft";
import './CreateSurvey.css'
import { MultipleChoiceQuestion, TextualQuestion } from "../../model/question";

function CreateSurvey() {
    const pageRef = useRef(null);
    const [showOverlay, setShowOverlay] = useState(false);
    const [questions, setQuestions] = useState([]);

    useEffect(() => {
        subscribe(OVERLAY_TOGGLE, e => {
            setShowOverlay(e.detail.show);
        })
    }, []);

    async function submitNewSurveyRequest() {
        return fetch('http://127.0.0.1:8000/api/surveys/create-survey/', {
            method: 'POST',
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                name: document.querySelector('#survey-name').value,
                description: document.querySelector('#survey-descr').value
            })
        })
    }
    
    async function submitQuestion(question, idx) {
        debugger;
        if (question instanceof MultipleChoiceQuestion) {
            return fetch('http://127.0.0.1:8000/api/surveys/add-multiple-choice-question/', {
                method: 'POST',
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    'SurveyPosition': idx,
                    'QuestionText': question.text,
                    'Surveys_Survey_ID': 1,
                    'MaxSelectionNumber': 1,
                    'Options': question.options
                })
            });
        } else if (question instanceof TextualQuestion) {
            return fetch('http://127.0.0.1:8000/api/surveys/add-textual-question/', {
                method: 'POST',
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    'SurveyPosition': idx,
                    'QuestionText': question.text,
                    "CharLimit": question.charLimit,
                    'Surveys_Survey_ID': 1,
                })
            });
        } else {
            return Promise.resolve();
        }
    }

    async function submitSurvey(){
        await submitNewSurveyRequest();
        for(var i = 0; i < questions.length; i++) {
            await submitQuestion(questions[i], i);
        }
    }

    return (
        <div>
            <header ref={pageRef}>
                <h1>Create Survey</h1>
            </header>
            <div class="survey-info-input">
                <label for="survey-name">Survey Name</label>
                <input type="text" name="survey-name" id="survey-name"/>
                <label for="survey-descr">Survey Description</label>
                <input type="text" name="survey-descr" id="survey-descr"/>
            </div>
            <div>
                {questions.map(question => QuestionDraft(question, setQuestions))}
            </div>
            <button onClick={() => submitSurvey()}>Submit Survey</button>

            {Fab("add", () => { publish(OVERLAY_TOGGLE, { show: true }); })}

            {showOverlay ? Overlay("New Question", NewQuestion(setQuestions)) : ""}
        </div>
    );
}

export default CreateSurvey;