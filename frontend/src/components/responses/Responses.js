import { useEffect, useState } from "react";
import { redirect, useParams } from "react-router-dom";
import PieChart from "../piechart/PieChart";

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
            setResponses(responses => {
                console.log(data);
                return data['multiple-choice-questions'];
            })
        });


    }, []);

    return (
        <div>
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
                }
                return null;
            })}
        </div>
    );
}