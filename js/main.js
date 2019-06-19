/* jshint esversion: 6 */

/* -------------------------------------------- */
/* Constants ---------------------------------- */
/* -------------------------------------------- */

const sbooHelpMessage = "« Win+Shift+h » (a.k.a. « Win+H ») was pressed (displaying this message)";

/* -------------------------------------------- */
/* Functions ---------------------------------- */
/* -------------------------------------------- */

function sbooHandleHelp (event) {
    'use strict';

    const keyName = event.key || event.keyIdentifier;
    const keyCode = event.which || event.code || event.keyCode;

    const isControl = event.ctrlKey;
    const isAlt     = event.altKey;
    const isShift   = event.shiftKey;

    const isCommand = event.metaKey;
    const isWindows = event.metaKey;

  console.log("");
  console.log(keyName);
  console.log(keyCode);

 // console.log("");
 // console.log(keyName);
 // console.log(keyCode);

    if (sbooIsKeyH(keyName, keyCode) && (isShift && (isWindows || isCommand))) {

        alert(sbooHelpMessage);

    }
}

/* -------------------------------------------- */

function sbooIsKeyH (keyName, keyCode) {
    'use strict';

    return (keyName === "h" || keyName === "H" || keyCode == 104 || keyCode == 72);

}

/* -------------------------------------------- */

function sbooIsKeyForwardSlash (keyName, keyCode) {
    'use strict';

    return (keyName === "/" || keyCode == 191);

}

/* -------------------------------------------- */
/* Effects: Register Handlers ----------------- */
/* -------------------------------------------- */

document.addEventListener('keypress', sbooHandleHelp, false);

/* -------------------------------------------- */
/* Notes ---------------------------------------*/
/* -------------------------------------------- */

// | Key                      | Virtual Key Code
// | ------------------------ | ----------------
// Semicolon (;)              | 186
// Colon (:)                  | 186
// Plus (+)                   | 187
// Equals sign (=)            | 187
// Comma (,)                  | 188
// Less than sign (<)         | 188
// Minus (-)                  | 189
// Underscore (_)             | 189
// Period (.)                 | 190
// Greater than sign (>)      | 190
// Question mark (?)          | 191
// Forward slash (/)          | 191
// Backtick (`)               | 192
// Tilde (~)                  | 192
// Opening square bracket ([) | 219
// Opening curly bracket ({)  | 219
// Backslash (\)              | 220
// Pipe (|)                   | 220
// Closing square bracket (]) | 221
// Closing curly bracket (})  | 221
// Single quote (')           | 222
// Double quote (")           | 222

/* -------------------------------------------- */
/* EOF ---------------------------------------- */
/* -------------------------------------------- */