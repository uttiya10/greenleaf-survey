import { useEffect, useState } from 'react';
import './Fab.css'
import { OVERLAY_TOGGLE, subscribe } from '../../util/events';

export default function Fab(iconName, onClick) {
    const [hidden, setHidden] = useState(false);

    useEffect(() => {
        subscribe(OVERLAY_TOGGLE, e => {
            debugger;
            setHidden(e.detail.show);
        });
    });

    return hidden ? null : (
        <button class="fab-btn" onClick={() => onClick()}>
            <span class="material-symbols-outlined">
                {iconName}
            </span>
        </button>
    );
}