# Zettel.vim
WARNING: Requires [Zettel](https://github.com/grantmiiller/zettel)

## Why?
Didn't really like all the Zettel editors, I use vim a lot, and the other editors required too much setup/plugins.

## Usage
`:call ZettelNew('<Your Note Name Here>')`
- Creates a new note with the ID that `zettel` above uses as well as the passed note name
- Opens the note in a new buffer
- Copies the notes ID to the `a` register

`:call ZettelGetId()`
- Tries to grab the ID of the current file and copies it to the `a` register

`:call ZettelFindFile()`
- With no params, it will attempt to find and open the first note using the `<cword>` the cursor is over
- With a param, will attempt to find and open the first file using the param as a search word

`:call ZettelPasteLink()`
- Will insert `[[<note id>]]<optional note name>` under the cursor, using passed parameter or what is in register `a`
