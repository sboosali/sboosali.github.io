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
/* Effects: Register Handlers ----------------- */
/* -------------------------------------------- */

document.addEventListener('keypress', sbooHandleHelp, false);

/* -------------------------------------------- */
/* EOF ---------------------------------------- */
/* -------------------------------------------- */