<article>

# “Universal” Widgets

<section>
## Introduction
</section>

<!-- 

### Widget

*Type*:

``` haskell
:: 
```

*Value*:

* 

Behavior:

* 

HTML:

``` html
<input type="">: <input/>
```

`Emacs`:

``` elisp
(read- ": ")
```

CLI (Completion):

``` bash
$ 
```

Examples:

* — 

Links:

- <>
- <>

-->

<section>
## *Short* Text Widget

*Type*:

``` haskell
:: String
```

*Value*:

* *single-line* text.

Behavior:

* Press `<ret>` to submit.

HTML:

``` html
<input type="">Name: <input/>
```

`Emacs`:

``` elisp
(read-string "Name :")
```

CLI (Prompting):

``` sh
#!/bin/sh

printf "Name: "
read NAME


LENGTH=$(printf "%s\n" ${NAME} | wc -m)
printf "Name Length: %d\n" ${LENGTH}

# POSIX-conformant
```

Examples:

* — 

Links:

- <>
- <>

</section>
## *Long* Text Widget
<section>

*Type*:

``` haskell
:: [String]
```

*Value*:

* *multi-line* text.

Behavior:

* Full Editing — `<ret>` is newline (i.e. doesn't submit): for HTML, by default, click a "Submit" `<button>`; for Emacs, by default, press `C-c C-c`; with a custom widget, press `<ret>` twice; with a custom widget, press `<S-ret>`.

HTML:

``` html
<textarea><textarea/>
```

`Emacs`:

``` elisp
(read-buffer? "Text :")
```

CLI (Completion):

``` bash
$ 
```

Examples:

* `magit.el` — edit the *git commit message*.

Links:

- <>
- <>

</section>
## *Secret* Text Widget
<section>

i.e. Password Input.

*Type*:

``` haskell
:: String
```

*Value*:

* text which is *secret*.

Behavior:

* **MUST NOT** echo input
* *May* echo input length (e.g. print a `*` for each character entered).
* Press `<ret>` to submit.

HTML:

``` html
<input type="password">Password: <input/>
```

`Emacs`:

``` elisp
(read-passwors "Password :") TODO
```

CLI (Prompting):

``` sh
#!/bin/sh

stty -echo
printf "Password: "
read PASSWORD
stty echo

LENGTH=$(printf "%s\n" ${PASSWORD} | wc -m)
printf "Password Length: %d\n" ${LENGTH}

# POSIX-conformant
```

Examples:

* — 

Links:

- <>
- <>

</section>
## Choices Widget
<section>

i.e. a Checklist.

*Type*:

``` haskell
:: (Enum a) => Set a
```

*Value*:

* 

Behavior:

* 

`HTML`:

``` html
<>
  <input type="checkbox">A<input/>
  <input type="checkbox">A<input/>
</>
```

Emacs (Minibuffer):

``` elisp
(TODO)
```

Emacs (Widget):

``` elisp
(widget-create)
```

Examples:

* — 

Links:

- <>
- <>

</section>
## Choice Widget (for *few* choices)
<section>

i.e. a Radio-Group.

*Type*:

``` haskell
:: (Enum a) => a
```

*Value*:

* one choice, from a set of choices

Behavior:

* Press a single key.
* Click a single button.

`HTML`:

``` html
<input type="radio">

  < label="Google Chrome">
  <option value="Firefox">
  <option value="Internet Explorer">
  <option value="Opera">
  <option value="Safari">
  <option value="Microsoft Edge">


```

`Emacs`:

``` elisp
(read-choice-
```

CLI (Prompting):

``` bash
$ read-char TODO
```

Examples:

* — 

Links:

- <>
-

</section>
## Choice Widget (for *many* choices)
<section>

i.e. a “Finite-List”.

*Type*:

``` haskell
:: (Enum a) => a
```

*Value*:

* one choice, from a set of choices

Behavior:

* Completion (possibly)
* Defaulting (possibly)
* Vertical Navigation (possibly)

`HTML`:

``` html
<!-- the chooser: -->

<label for="myBrowser">Choose a browser from this list:</label>
<input list="browsers" id="myBrowser" name="myBrowser" />


<!-- the choices: -->

<datalist id="browsers">

  <option value="Google Chrome">
  <option value="Firefox">
  <option value="Internet Explorer">
  <option value="Opera">
  <option value="Safari">
  <option value="Microsoft Edge">


</datalist>
```

`Emacs`:

``` elisp
(let ((CHOICES '(
  "Google Chrome"
  "Firefox"
  "Internet Explorer"
  "Opera"
  "Safari"
  "Microsoft Edge"
  )))

 (completing-read "Browser: " CHOICES))
```

CLI (Completion):

``` bash
$ IFS="\n" compgen ... -W <<<EOF
  "Google Chrome"
  "Firefox"
  "Internet Explorer"
  "Opera"
  "Safari"
  "Microsoft Edge"
EOF
```

Representation (*must match*):

``` haskell
data Browser

  = Firefox
  | GoogleChrome
  | InternetExplorer
  | Opera
  | Safari
  | MicrosoftEdge

  deriving ( Enum, Bounded, ... )
```

Representation (*free text*):

``` haskell
type Browser = Either UnknownBrowser KnownBrowser

--

data KnownBrowser

  = Firefox
  | GoogleChrome
  | InternetExplorer
  | Opera
  | Safari
  | MicrosoftEdge

  deriving ( Enum, Bounded, ... )

--

newtype UnknownBrowser = UnknownBrowser String

  deriving ( IsString, ... )
```

Examples:

* — 

Links:

- <>
- <https://www.gnu.org/software/emacs/manual/html_node/elisp/Minibuffer-Completion.html>

</section>
## File Widget
<section>

i.e. a File-Chooser.

*Type*:

``` haskell
:: FilePath
```

*Value*:

* one filepath, from a set of choices.
* *regular-only* (possibly) or "directory-only*(possibly).
* *must-exist* (possibly) or *can't-exist* (possibly).

Behavior:

* Vertical Navigation (possibly) between the directory contents
* Horizontal Navigation (possibly) between *returning to* the parent directory or *descending into* subdirectories.

`HTML`:

``` html

```

`read-file-name` (`Emacs`):
<label for="sn--elisp--read-file-name" class="margin-toggle sidenote-number"></label><input type="checkbox" id="sn--elisp--read-file-name" class="margin-toggle"/>
<span class="sidennote"> <code>(read-file-name <var>PROMPT</var> &optional <var>DIR</var> <var>DEFAULT-FILENAME</var> <var>MUSTMATCH</var> <var>INITIAL</var> <var>PREDICATE</var>)</code><i>(a.k.a <kbd>C-x C-f</kbd>)</i></span>

``` elisp
(read-file-name "Open File: " default-directory nil t)
```

``` elisp
(read-file-name "Open Directory: " )
```

``` elisp
(read-file-name "New File: " )
```

``` elisp
(defun sboo-elisp-filename-p (filename)
  (match filename (rx ".el" eos))) ;TODO

  (read-file-name "Open File: " default-directory nil nil nil #'sboo-elisp-filename-p))
```

<!-- TODO sidenote signature -->

CLI (Completion):

``` bash
$ compgen ... -A file
```

``` bash
$ compgen ... -A directory
```

Examples:

* — 

Links:

- <>
- <>


</section>
## Conclusion
<section>


</article>