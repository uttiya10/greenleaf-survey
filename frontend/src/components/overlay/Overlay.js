import './Overlay.css'
import { OVERLAY_TOGGLE, publish } from '../../util/events';

export default function Overlay(title, innerContent) {
    return (
        <div class="overlay">
            <span class="material-symbols-outlined overlay-close" onClick={() => publish(OVERLAY_TOGGLE, { show: false })}>close</span>
            <header>
                <h2>{title}</h2>
            </header>
            <div>
                {innerContent}
            </div>
        </div>
    );
}
