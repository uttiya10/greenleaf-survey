import './Fab.css'

export default function Fab(iconName, onClick) {
    return (
        <button class="fab-btn" onClick={() => onClick()}>
            <span class="material-symbols-outlined">
                {iconName}
            </span>
        </button>
    );
}