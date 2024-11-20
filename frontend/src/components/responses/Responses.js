import { useEffect, useState } from "react";
import { redirect, useParams } from "react-router-dom";
import PieChart from "../piechart/PieChart";
import TextualResponsesItem from "../textual-responses-item/TextualResponsesItem";
import './Responses.css';

export default function Responses() {
    const [responses, setResponses] = useState([]);
    const { id } = useParams(); 

    useEffect(() => {
        // if (!id) {
        //     return redirect('/');
        // }
        //debugger;
        fetch('http://127.0.0.1:8000/api/surveys/get-responses/' + id + "/")
        .then(res => res.json())
        .then(data => {
            setResponses(_responses => {
                return data['multiple-choice-questions'].concat(data['textual-questions']);
            })
        });


    }, []);

    return (
        <div class="responses-list">
            {responses.map(res => {
                if (res['multiple-choice-options']) {
                    var options = res['multiple-choice-options'];
                    var mcResponses = res['multiple-choice-responses'];
                    var optionsFreq = [...options].map(_option => 0);
                    for (var i = 0; i < mcResponses.length; i++) {
                        optionsFreq[mcResponses[i]]++;
                    }
                    var chartData = options.map((option, i) => {
                        var obj = {};
                        obj['label'] = option;
                        obj['value'] = optionsFreq[i];
                        return obj;
                    });
                    return PieChart({ data: chartData, text: res['question_text'] })
                } else if (res['textual-responses']) {
                    return TextualResponsesItem({ text: res['question_text'], responses: res['textual-responses'], position: res['survey_position']});
                }
                return null;
            })}
        </div>
    );
}