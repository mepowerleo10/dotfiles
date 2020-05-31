chrome.app.window.create(
	"chrome-extension://iaclnhdelkkgafbikgagphmpkbpfjkef/index.htm",
	{id:"vcastWinID",height:270,width:550,resizable:!1},
	function(b){mainWindow=b,b.resizeTo(270,550),a&&a(b)}
)
