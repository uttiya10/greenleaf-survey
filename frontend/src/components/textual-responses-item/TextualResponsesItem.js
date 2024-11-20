import { useState } from 'react';
import './TextualResponsesItem.css';

export default function TextualResponsesItem({text, responses, position}) {
    return (
        <div class="textual-responses-item">
            <h3>{text}</h3>
            <ul class="text-responses-list" style={{display: "none"}} id={"res-text-q-" + position}>
                {
                    responses.map(response => {
                        return (<li>{response}</li>);
                    })
                }
            </ul>
            <button id={"text-res-btn-pos-" + position} class="button" onClick={() => {
                var responsesContainer = document.querySelector('#res-text-q-' + position);
                var button = document.querySelector('#text-res-btn-pos-' + position);
                if (responsesContainer.style.display === 'none') {
                    document.querySelector('#res-text-q-' + position).style.display = 'block';
                    button.innerHTML = 'Hide All';
                } else {
                    document.querySelector('#res-text-q-' + position).style.display = 'none';
                    button.innerHTML = 'Read All';
                }
            }}>Read All</button>
        </div>
    );
}