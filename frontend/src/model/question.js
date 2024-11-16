export class Question {
    constructor(text) {
        this.text = text;
    }
}

export class MultipleChoiceQuestion extends Question {
    constructor (text, options, name) {
        super(text);
        this.options = options;
        this.name = name;
    }
}