create-writing file:
    typst compile --pdf-standard=2.0 --input word-list={{ file }} template-writing-ru.typ {{ file }}-writing.pdf

create-list file:
    typst compile --pdf-standard=2.0 --input word-list={{ file }} template-list-ru.typ {{ file }}-list.pdf
