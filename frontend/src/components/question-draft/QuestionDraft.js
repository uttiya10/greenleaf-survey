import { useRef, useState } from "react";
import { MultipleChoiceQuestion } from "../../model/question";
import './QuestionDraft.css'

export default function QuestionDraft(question, setQuestions) {

    function addMultipleChoiceOption(mcq) {
        setQuestions(questions => {
            var questionIdx = questions.indexOf(mcq);
            var result = [...questions];
            var optionTextSelectorID = mcq.name + "-new-option";
            var optionText = document.getElementById(optionTextSelectorID).value;
            result.splice(questionIdx, 1, 
                new MultipleChoiceQuestion(mcq.text, mcq.options.concat(optionText), mcq.name));
            return result;
        })
    }

    return (
        <div class="question-container">
            <span onClick={() => setQuestions(questions => questions.filter(q => q !== question))} class="material-symbols-outlined question-delete">close</span>
            <header>
                <h2>{question.text}</h2>
            </header>
            {
                question instanceof MultipleChoiceQuestion ?
                    <div>
                        {question.options.map(option => (
                            <div>
                                <input type="radio" name={question.name} id={option} value={option}/>
                                <label for={option}>{option}</label>
                            </div>
                        ))}
                        <div>
                            <input id={question.name + "-new-option"} type="text" name="new-option"/>
                            <button onClick={() => addMultipleChoiceOption(question)}>Add Option</button>
                        </div>
                    </div>
                    :
                    <textarea disabled placeholder="Answer Goes Here">
                        
                    </textarea>
            }
        </div>
    );
}