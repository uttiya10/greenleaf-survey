import { useEffect } from 'react';
import './Overlay.css'
import { OVERLAY_TOGGLE, publish } from '../../util/events';

export default function Overlay(title, innerContent) {
    return (
        <div class="overlay">
            <button onClick={() => publish(OVERLAY_TOGGLE, { show: false })} class="overlay-close">X</button>
            <header>
                <h2>{title}</h2>
            </header>
            <div>
                {innerContent}
            </div>
        </div>
    );
}
