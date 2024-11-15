import { useEffect, useRef, useState } from "react";
import Fab from "../fab/Fab";
import Overlay from "../overlay/Overlay";
import NewQuestion from "../new-question/NewQuestion";
import { publish, OVERLAY_TOGGLE, subscribe } from "../../util/events";

function CreateSurvey() {
    const pageRef = useRef(null);
    const [showOverlay, setShowOverlay] = useState(false);

    useEffect(() => {
        subscribe(OVERLAY_TOGGLE, e => {
            setShowOverlay(e.detail.show);
        })
    }, []);

    return (
        <div>
            <header ref={pageRef}>
                <h1>Create Survey</h1>
            </header>
            {
                Fab("add", () => { publish(OVERLAY_TOGGLE, { show: true }); })
            }
            {
                showOverlay ? Overlay("New Question", NewQuestion()) : ""
            }
        </div>
    );
}

export default CreateSurvey;