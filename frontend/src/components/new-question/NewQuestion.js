import { MultipleChoiceQuestion, Question } from "../../model/question";
import { OVERLAY_TOGGLE, publish } from "../../util/events";
import './NewQuestion.css';

export default function NewQuestion(setQuestions) {
    function onSubmit() {
        setQuestions(questions => {
            var questionName = document.getElementById("question-text").value;
            if (document.getElementById("textual").checked) {
                publish(OVERLAY_TOGGLE, {show: false});
                return questions.concat(new Question(questionName));
            } else if (document.getElementById("mc").checked) {
                publish(OVERLAY_TOGGLE, {show: false});
                return questions.concat(
                    new MultipleChoiceQuestion(questionName, [], "hello-world")
                )
            } else {
                return questions;
            }
        });
    }
    return (
        <form id="new-question-form" onSubmit={e => {
            e.preventDefault();
        }}>
            <div>
                <input required name="text" id="question-text" class="overlay-input" placeholder="New Question"/>
            </div>
            <div>
                <input required name="type" id="textual" class="overlay-input" value="textual" type="radio"/>
                <label for="textual">Textual Question</label>
            </div>
            <div>
                <input required name="type" id="mc" class="overlay-input" value="mc" type="radio"/>
                <label for="mc">Multiple Choice Question</label>
            </div>
            <button class="overlay-input" onClick={() => onSubmit()}>Ok</button>
        </form>
    );
}