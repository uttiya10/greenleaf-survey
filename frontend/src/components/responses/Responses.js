import { useEffect } from "react";
import { redirect, useParams } from "react-router-dom";
import PieChart from "../piechart/PieChart";

export default function Responses() {
    var responsesInfo = null;
    var responses = [];
    const { id } = useParams(); 

    async function getResponses() {
        return (await (await fetch('http://127.0.0.1:8000/api/surveys/get-responses/' + id, {
            method: 'GET',
            headers: {
                "Accepts": "application/json"
            },
        })).json());
    }

    useEffect(() => {
        if (!id) {
            return redirect('/');
        }
        responsesInfo = getResponses();
        debugger;
        responses = responses.concat(responses['multiple-choice-questions']).concat(responses['textual-questions']);
        responses.sort((r1, r2) => r1['survey-position'] - r2['survey-position']);
    });

    if (!responses) {
        return redirect('/');
    }

    return (
        <div>
            {responses.map(res => {
                if (res['multiple-choice-responses']) {
                    var options = res['multiple-choice-options'];
                    var optionsFreq = [...options].map(_option => 0);
                    for (var i = 0; i < options.length; i++) {
                        optionsFreq[i]++;
                    }
                    var chartData = Object.fromEntries(options.map((option, i) => [option, optionsFreq[i]]));
                    return PieChart({ data: chartData })
                }
                return null;
            })}
        </div>
    );
}