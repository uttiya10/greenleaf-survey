export default function NewQuestion() {
    return (
        <form onSubmit={(e) => e.preventDefault()}>
            <input name="type" id="textual" value="textual" type="radio"/>
            <label for="textual">Textual Question</label>
            <input name="type" id="mc" value="mc" type="radio"/>
            <label for="mc">Multiple Choice Question</label>
            <button>Ok</button>
        </form>
    );
}