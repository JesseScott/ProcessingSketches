/**
 *    This script is run via Rhino once upon export to see if
 *    any errors surface.
 *
 *    http://github.com/fjenett/processingjstool
 *
 *    See:
 *       Rhino, http://www.mozilla.org/rhino/
 *       Env.js, http://www.envjs.com/
 */

// load(), print() are implemented in PJSDebuggerEnvironment,
// applet_js is exported directly into the rhino context

// this is read in applet.html
var RUNNING_PROCESSING_JS_EXPORT_TOOL_DEBUGGER = true;

load( 'envjs/env.rhino.js' );

Envjs( {
   logLevel: Envjs.DEBUG,
   scriptTypes: { 'text/javascript': true }
});

window.location = applet_js + "/index.html";