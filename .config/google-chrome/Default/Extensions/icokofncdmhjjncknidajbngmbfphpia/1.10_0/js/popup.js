var version = "16";
var zoomCorrection = 1;
var channelMap, channelIndex;
var mainBoxWidth = 320;

var commandInterval = 0;

var webos = false;
var connected = false;

// GA start

var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-1718372-10']);
_gaq.push(['_trackPageview']);

(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = 'https://ssl.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
// GA end


function auth() {
	var url = webos ?
    "/udap/api/pairing" :
    "/roap/api/auth";
	var data = webos ?
    "<?xml version=\"1.0\" encoding=\"utf-8\"?><envelope><api type=\"pairing\"><name>showKey</name></api></envelope>" :
    "<?xml version=\"1.0\" encoding=\"utf-8\"?><auth><type>AuthKeyReq</type></auth>";
	var sfn = function(){showMessage("Please enter the pairing key\nyou see on your TV screen\n");};
	var efn = webos ? false : function(){webos = true; auth();};
	httpPost(url, data, sfn, efn);
}

function getSessionid(sfn, efn) {
	$("#pk").val($("#pk").val().replace(/[^0-9]/g, ""));
  var pk = $("#pk").val();
  if(pk != "") {
	  var url = webos ? 
      "/udap/api/pairing" :
      "/roap/api/auth";
	  var data = webos ? 
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><envelope><api type=\"pairing\"><name>hello</name><value>" + pk + "</value><port>8080</port></api></envelope>" :
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><auth><type>AuthReq</type><value>" + pk + "</value></auth>";
   	httpPost(url, data, sfn, efn);
  }	
  saveData('ip', $("#ip").val());
	saveData('pk', pk);
  saveData('webos', webos);
}

function command(num) {
	console.log('command:' + num);
	var url = webos ? 
    "/udap/api/command" :
    "/roap/api/command";
	var data = webos ? 
    "<?xml version=\"1.0\" encoding=\"utf-8\"?><envelope><api type=\"command\"><name>HandleKeyInput</name><value>"+num+"</value></api></envelope>" : 
    "<?xml version=\"1.0\" encoding=\"utf-8\"?><command><name>HandleKeyInput</name><value>"+num+"</value></command>";
  httpPost(url, data);
}

function fillChannelList() {
  channelMap = new Object();
  channelIndex = 0;
  httpGet(webos ? '/udap/api/data?target=channel_list' : '/roap/api/data?target=channel_list', function(d) {
    var str = getPostedData(d, 'getFillChannelListData');
    $('#channelList').html( str );
    $('#channelList').listview("refresh");
    $('.channelButton').on(
      "click", function( event ) {
        switchToChannel(event.target);
      }
    );
  });
}

function getCurrentChannel() {
  httpGet(webos ? '/udap/api/data?target=cur_channel' : '/roap/api/data?target=cur_channel', function(d) {
    var str = getPostedData(d, 'getCurrentChannelData');
    $("#infoText").html(str);
    console.log(str);
  });
}

function screenshot() {
  $('#screenshotImage').attr('src', getBaseUrl() + (webos ? '/udap/api/data?target=screen_image' : '/roap/api/data?target=screen_image'));
  _gaq.push(['_trackEvent', 'screenshot']);
}

function sendText() {
        var text = $("#textInput").val()
	console.log('sendText:' + text);
	var url = "/roap/api/event";
	var data = "<?xml version=\"1.0\" encoding=\"utf-8\"?><event><name>TextEdited</name><state>Editing</state><value>"+text+"</value></event>";
  httpPost(url, data);
  command(31);
}

function switchToChannel(t) {
  var channelIndex = $(t).attr('channelIndex');
  var ch = channelMap[channelIndex];
  var url = "/roap/api/command";
	var data = "<?xml version=\"1.0\" encoding=\"utf-8\"?><command><name>HandleChannelChange</name><major>"+ch.major+"</major><minor>"+ch.minor+"</minor><sourceIndex>"+ch.sourceIndex+"</sourceIndex><physicalNum>"+ch.physicalNum+"</physicalNum></command>";
  httpPost(url, data);
  _gaq.push(['_trackEvent', 'switchToChannel', ch.chname, ch.major]);
}

$(function() {

  printHaml('tab-tv', 'remote-controller');

  loadDataFromStorage();

  setEvents();
});

function loadDataFromStorage() {
  loadData('webos', function (v) {
	  webos = v == true ? true : false;
  });
  loadData('version', function (v) {
    saveData("version", version);
    if(v != version) {
      //showMessage('Happy new year, happy new style!');
      if(v < version) {
        zoomCorrection = 2.22;
      }
    } else {
    	showMessage("");
    }
  });
  loadData('ip', function (v) {
	  $("#ip").val(v);
  });
  loadData('pk', function (v) {
	  $("#pk").val(v);
  });
  loadData('pageModeSelect', function (v) {
    if(v == null) {
      v = 'Popup';
    }
    setZoom();
    $('input:radio[value='+v+']:nth(0)').attr('checked', true).checkboxradio("refresh");
    setPageMode();
  });
	loadData('zoomInput', function(v) {
	  if(v != null) {
      v = Math.round(v / zoomCorrection);
	  } else {
		  v = 55;
		  $( "#tabs" ).tabs("option", "active", 1);
	  }
	  $("#zoomInput").val(v);
	  doZoomChange();
  });
}

function executeTVInterval() {
    getSessionid(
      function() {
        getCurrentChannel();
      },
      function() {
      }
    );
}

function setEvents() {
  $(document).ready(
    function() {
      executeTVInterval();

      setInterval(
        function() {
          executeTVInterval();
        },
        10000
      );
    }
  );

  $(document).on('backbutton',
    function(e){
      e.preventDefault();
      command(23);
      _gaq.push(['_trackEvent', 'command', 'backbutton', 23]);
    }
  );

  $( ".button-container" ).mousedown(function( event ) {
    var id = getCommandIdFromClick(event);
    commandEvent(id, true);
    _gaq.push(['_trackEvent', 'command', 'mousedown-' + webos, id]);
  });

  $( ".button-container" ).mouseup(function( event ) {
    var id = getCommandIdFromClick(event);
    commandEvent(id, false);
  });

  $( ".button-container" ).mouseout(function( event ) {
    var id = getCommandIdFromClick(event);
    commandEvent(id, false);
  });

  $(document).keydown(function(e) {
    if(getSelectedTabIndex() != 0) return;
    var id = getCommandIdFromKey(e);
    commandEvent( id, true );
    _gaq.push(['_trackEvent', 'keydown', id]);
  });

  $(document).keyup(function(e) {
    if(getSelectedTabIndex() != 0) return;
    commandEvent( getCommandIdFromKey(e), false );
  });

  $( "#findTvButton" ).click(function( event ) {
	  showMessage("Sorry this feature is not implemeneted yet.\n\nYou can find this info on your TV.\nPress SETTINGS > NETWORK (Earth icon) > Network Status > IP Address");
    _gaq.push(['_trackEvent', event.target.id, 'click']);
  //	scan();
  });

  $( "#authButton" ).click(function( event ) {
	  auth();
    _gaq.push(['_trackEvent', event.target.id, 'click-' + webos]);
  });

  $( "#zoomInput" ).on("change", function( event ) {
    doZoomChange();
    _gaq.push(['_trackEvent', event.target.id, 'change']);
  });

  $('#pageModeSelect').on(
    "change", function( event, ui ) {
      saveData('pageModeSelect', $("#pageModeSelect :radio:checked").val());
      setPageMode();
    }
  );

  $( "#tabs" ).on( "tabsactivate", function( event, ui ) {
    getSessionid();
    if(ui.newPanel.selector == '#tab-channels') {
      fillChannelList();
    } else if(ui.newPanel.selector == '#tab-tools') {
      //screenshot();
    }
  });

  $( "#screenshotButton" ).on( "click", function() {
    screenshot();
  });

  $( "#youtubeButton" ).on( "click", function() {
    window.open("https://www.youtube.com/pair");
  });

  $( "#sendTextButton" ).on( "click", function() {
    sendText();
  });

  $('#textInput').bind("enterKey",function(e){
    sendText();
  });
  $('#textInput').keyup(function(e){
    if(e.keyCode == 13)
    {
        $(this).trigger("enterKey");
    }
  });
}

function doZoomChange() {
  showMessage("");
	setZoom();
	saveData('zoomInput', $("#zoomInput").val());
}

function showMessage(str) {
	$( ".message" ).each(function( index ) {
		$(this).html(str);
		if(str == "") {
			$(this).hide();
		} else {
			$(this).show();
		}
	});
}

function getSelectedTabIndex() { 
    return $("#tabs").tabs('option', 'active');
}

function getBaseUrl() {
  var ip = $("#ip").val();
  if(ip.indexOf(':')<0) {
    ip += ':8080';
  }
	return 'http://' + ip;
}

function setZoom() {
	var v = $( "#zoomInput" ).val();
	$( "#main-box" ).css("zoom", v + '%');
	$( "#main-box" ).css("-webkit-transform", "rotate(-0deg)");
  console.log(	$( "#tab-1" ).width());

  var w = ($( "#main-box" ).width() + 50) * v / 100;
  w = Math.max(mainBoxWidth, w);
  $("#page-1").width(w);
  $("#body").width(w);

  var h = ($( "#main-box" ).height() + 50) * v / 100 + 40;
  h = Math.max(600, h);
  $("#page-1").height(h);
  $("#body").height(h);
}

function setPageMode() {
	var v = $( "#pageModeSelect :radio:checked" ).val();

	if(v == 'Page' && window.name != 'LG') {
		window.open('index.html', 'LG');
	}

	if(v == 'Page' && window.name=='LG') {
    $( "#page-1" ).draggable({
       stop: function( event, ui ) {savePosition(ui.position);}
    });

    loadData('left', function (left) {
      loadData('top', function (top) {
        var page = $( "#page-1" );
        if(left == undefined || top == undefined) {
           left = 0;
           top = 0;
        }
        top = window.innerHeight - page.height() > top ? top : window.innerHeight - page.height();
        top = top < 0 ? 0 : top;
        left = window.innerWidth - page.width() > -left ? left : -window.innerWidth + page.width();
        left = left > 0 ? 0 : left;

        page.animate({
          top: top,
          left: left
        });
      });
    });
	}
}

function savePosition(position) {
   saveData('left', position.left);
   saveData('top', position.top);
}

function getCommandIdFromClick(event) {
	var s = $(event.target || event.srcElement);
  s = $(s).closest('.button-container').attr('id');
	s = s.replace("button-", "");
  return s;
}

function getCommandIdFromKey(e) {
  var id = -1;
  var code = e.keyCode || e.which;
  code = parseInt(code);
  if(code == 109) {
	  id = 25;
  } else if(code == 107) {
	  id = 24;
  } else if(code >= 96 && code < 106) {
	  id = code - 94;
  } else if(code >= 48 && code < 58) {
	  id = code - 46;
  } else if(code == 46) {
	  id = 412;
  } else if(code == 40) {
	  id = 13;
  } else if(code == 39) {
	  id = 15;
  } else if(code == 38) {
	  id = 12;
  } else if(code == 37) {
	  id = 14;
  } else if(code == 35 || code == 36) {
	  id = 21;
  } else if(code == 33 || code == 34) {
	  id = code - 6;
  } else if(code == 13) {
	  id = 20;
  } else if(code == 8) {
	  id = 23;
  }
  return id;
}

function commandEvent(num, start) {
  showMessage("");
//  console.log('commandEvent:' + num + "," + start + "," + commandInterval);
  if ( num <= 0 ) return;
  var $but = $('#button-' + num);
  if ( start ) {
    if(commandInterval != 0) {
//      console.log('event break');
      return;
    }
    $but.addClass('button-container-selected');
    command(num);
    commandInterval = setInterval(
      function () {
        command(num)
      },
      300
    );
  } else {
    clearInterval(commandInterval);
    commandInterval = 0;
    var $but = $('#button-' + num);
    $but.removeClass('button-container-selected');
  }
}

function httpPost(url, data, sfn, efn) {
	$.ajax({
		type: "POST",
		processData: false,
		contentType: webos ? "text/xml; charset=utf-8" : "application/atom+xml",
		dataType: "xml",
		url: getBaseUrl() + url,
		data: data, 
		success : function (d){
			if(sfn) {
				sfn(d);
			}
		},
		error : function (xhr, ajaxOptions, thrownError){
			if(efn) {
				efn(xhr);
			} else {
  			showMessage("Error!\nMaybe TV is off, or settings are not valid. Please check IP address and pairing key code on settings tab.\n\n(" + xhr.status +"-"+ thrownError + ")");
      }
      _gaq.push(['_trackEvent', 'httpPost', 'error', xhr.status]);
		}
	});
}

function httpGet(url, sfn) {
	$.ajax({
		type: "GET",
		url: getBaseUrl() + url,
		success : function (d){
			if(sfn) {
				sfn(d);
			}
		},
		error : function (xhr, ajaxOptions, thrownError){  
			showMessage("Error!\nMaybe TV is off, or settings are not valid. Please check IP address and pairing key code on settings tab.\n\n(" + xhr.status +"-"+ thrownError + ")");
      _gaq.push(['_trackEvent', 'httpGet', 'error', xhr.status]);
		}
	});
}

function getPostedData(d, fn) {
  var str = "";
  var cs = d.documentElement.children;
  for(var i in cs) {
    var ch = cs[i];
    if(ch.localName == 'data') {
      var ts = ch.children;
      str += eval(fn + '(ts)');
    }
  }
  return str;
}

function getFillChannelListData(ts) {
  var ch = {
    chtype        : ts[0].innerHTML,
    sourceIndex   : ts[1].innerHTML,
    physicalNum   : ts[2].innerHTML,
    major         : ts[3].innerHTML,
    displaymayor  : ts[4].innerHTML,
    minor         : ts[5].innerHTML,
    displayminor  : ts[6].innerHTML,
    chname        : ts[7].innerHTML
  };

  channelMap[++channelIndex] = ch;
  return '<li><a class="channelButton" channelIndex="' + channelIndex + '" href="#">' + ch.major + '-' + ch.chname + '</a></li>';
}

function getCurrentChannelData(ts) {
  var chname        = ts[7].innerHTML;
  var progName      = ts[8].innerHTML;
  return "<b>" + chname + "</b><br>" + progName;
}

function scan() {
	if( navigator.getNetworkServices ) {
	  debugLog('Searching for UPnP services in the current network...');

	  navigator.getNetworkServices(
	    ['upnp:urn:schemas-upnp-org:service:RenderingControl:1'],
	    onServices,
	    function(e) {
	      debugLog( 'An error occurred obtaining UPnP Services [CODE: ' + error.code + ']');
	  });

	} else {

	  debugLog('navigator.getNetworkServices API is not supported in this browser');

	}

}

function debugLog(msg) {
  var debugEl = document.getElementById('debug');
  var logEl = document.createElement('div');
  logEl.textContent = msg;
  debugEl.appendChild( logEl );

}

function printHaml(t, sourceId) {
  var fn = haml.compileHaml({sourceId: sourceId});
  var html = fn();
  document.getElementById(t).innerHTML=html;
}

function loadData(key, fn) {
  if(typeof chrome != undefined) {
    fn(localStorage.getItem(key));
  } else {
    chrome.storage.sync.get(key, function (object) {
      console.log('loadData ' + key + ':' + object[key]);
      fn(object[key]);
    });
  }
}

function saveData(key, value, fn) {
  if(typeof chrome != undefined) {
    localStorage.setItem(key, value);
    if(fn !== undefined) {
      fn();
    }
  } else {
    var keyJson = key;
    var jsonfile = {};
    jsonfile[keyJson] = value;
    chrome.storage.sync.set(jsonfile, fn);
    console.log('saveData ' + key + ':' + value);
  }
}

function onServices( services ) {
  debugLog( services.length + ' service'
    + ( services.length !== 1 ? 's' : '' ) +
      ' found in the current network' );

  if( services.length === 0 ) {
    return;
  }

  // Get the mute status for all services
  for(var i = 0, l = services.length; i < l; i++ ) {

    var service = services[ i ];
    service._index = i;

    var upnpService = new Plug.UPnP( service, { debug: false } );

    // Let's mute the provided service (w/o API parameter type checking)
    upnpService.action('GetMute', {
      request: {
        InstanceId: 0,
        Channel: 'Master'
      },
      response: {
        CurrentMute: {
          type: upnpService.types.boolean
        }
      }
    })
    .then( function( response ) {

      // Note: we don't need to check for '== "1"' below because
      // response.data.CurrentMute is now a native JS boolean as we
      // defined in our <actionParameters> above:

      debugLog("Service[" + this.svc._index + "] is reporting MUTE=[" +
        (response.data.CurrentMute ? 'on' : 'off') +
          "]");

      return this.action('SetMute', {
        request: {
          InstanceId: 0,
          Channel: 'Master',
          DesiredMute: response.data.CurrentMute ? 0 : 1
        }
      });

    })
    .then( function( response ) {

      return this.action('GetMute', {
        request: {
          InstanceId: 0,
          Channel: 'Master'
        },
        response: {
          CurrentMute: {
            type: upnpService.types.boolean
          }
        }
      });

    })
    .then( function( response ) {

      // Note: we don't need to check for '== "1"' below because
      // response.data.CurrentMute is now a native JS boolean as we
      // defined in our <actionParameters> above:

      debugLog("Service[" + this.svc._index + "] is reporting MUTE=[" +
        (response.data.CurrentMute ? 'on' : 'off') +
          "]");

    })
    .then( null, function( error ) { // Handle any errors
      debugLog( "An error occurred: " + error.description );
    });
  }
}
