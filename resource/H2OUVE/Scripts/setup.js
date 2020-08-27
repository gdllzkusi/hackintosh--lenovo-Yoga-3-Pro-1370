jQuery.support.cors = true;

//------------------
// Global Constants
//------------------
var SYSTEM_REBOOT_TRUE            = "xREBOOTx=1";
var SYSTEM_REBOOT_FALSE           = "xREBOOTx=0";
var UPDATE_REMOTE_SERVER_WARNING  = "Depends on how many servers you select" +
      ", the process time may take long time.<br />" +
      "Please do <b>NOT</b> refresh this page.";

var DEFAULT_TAB_NAME              = "Main";


//------------------
// Global variables
//------------------
//
// Keep uninitializing global variables uninitialized, or it may occur errors
//
var gSysTimeIntervalFd;
var gSysTimeArray;
var gSysTimeUpdateCount;
var gIsSetSysTime                 = false;
var gIsInitSysTime                = false;
var gExitFun                      = 0;
//-[start-130118-IB10500006-add]
var gShowHelpMsg                  = false;
//-[end-130118-IB10500006-add]

//var gDefatultTabFormHeight = (parseInt (document.documentElement.clientHeight) > (330 + 170)) ? (parseInt (document.documentElement.clientHeight) - 170) : 330;
//
// Do not initialize this global variable!
// It would be changed when we use index.html to process xml and xslt,
// because this variable will be loaded twice, and the second time initialization would be the last result.
//
var gDefatultTabFormHeight;
var gTempFormId = null;

//
// Operate after popup a loading page
//
var gThisNode = null;
var gAjaxServerInfo = null;
var gRemoteServers = new Array();
var gUploadFilesInfo = null;
var gAjaxSubmitObjs = null;
var gIsSubmitOneByOne = false;
var gAjaxFormData = null;
var gStopAction = false;
var gIsTxtConfig = false;
var gThisServerInfo = null;

var gFormStack = new Array ();
var gFormNameStack = new Array ();

//------------------
// Initilaizing
//------------------

$.ajaxSetup ({
  //
  // Disable caching of AJAX responses or it may cause problem on IE
  //
  cache: false
});

//------------------
// Functions
//------------------

function AutoAdjustDateTime () {
  var Year, Month, Day, Hour, Minute, Second;
  var DateObj, NewDateObj;
  var OriginalTimeNum;

  DateObj = new Date ();

  Second = FillNumberWithZero (DateObj.getSeconds ());
  Minute = FillNumberWithZero (DateObj.getMinutes ());
  Hour = FillNumberWithZero (DateObj.getHours ());
  Day = FillNumberWithZero (DateObj.getDate ());
  Month = FillNumberWithZero (DateObj.getMonth () + 1);
  Year = DateObj.getFullYear ();

//  alert (Month + "/" + Day +"/" + Year + " " + Hour + ":" +Minute + ":"+ Second);
  $('#SystemDate').html("[" + Month + "/" + Day + "/" + Year + "]");
  $('#SystemTime').html("[" + Hour + ":" + Minute + ":" + Second + "]");

  if ((gIsSetSysTime == true) && ($('#EditSystime').css("display") == "none")) {
    $('#Year').val(Year);
    $('#Month').val(Month);
    $('#Day').val(Day);
    $('#Hour').val(Hour);
    $('#Minute').val(Minute);
    $('#Second').val(Second);
  }
}

function UrlReload() {
    var url = window.location.href;
    window.location.href = url;
    //  window.location.reload (true);
}

function InitSystemTimer () {
  gSysTimeIntervalFd = setInterval (AutoAdjustDateTime, 1000);
  gSysTimeUpdateCount = 0;

  $("#Month, #Day, #Year, #Hour, #Minute, #Second").change (function () {
    var Node = $(this);
    var Value = parseInt ($(this).val());

    if (Value < 0) {
      alert ("Error:" +Value);
      return;
    }
    //
    // Timer is set by user, we don't flush timer from server
    //
    gIsSetSysTime = true;

    if (Node.attr('id') == 'Month') {
      if ((Value > 0) && (Value < 13)) {
        gSysTimeArray.Month = Value;
      }
    } else if (Node.attr('id') == 'Day') {
      if ((Value > 0) && (Value < 32)) {
        gSysTimeArray.Day = Value;
      }
    } else if (Node.attr('id') == 'Year') {
      gSysTimeArray.Year = Value;
    } else if (Node.attr('id') == 'Hour') {
      if ((Value >= 0) && (Value < 24)) {
        gSysTimeArray.Hour = Value;
      }
    } else if (Node.attr('id') == 'Minute') {
      if ((Value >= 0) && (Value < 60)) {
        gSysTimeArray.Minute = Value;
      }
    } else if (Node.attr('id') == 'Second') {
      if ((Value >= 0) && (Value < 60)) {
        gSysTimeArray.Second = Value;
      }
    }
  });

  $('#Systime .TimeContentField').click(function () {
    //
    // Time has been set, clear those input field
    //
    $('#Systime').css("display", "none");
    $('#EditSystime').css("display", "");
    $('#Year').val("");
    $('#Month').val("").focus();
    $('#Day').val("");
    $('#Hour').val("");
    $('#Minute').val("");
    $('#Second').val("");
  });

  $('#EditSystime :input').keyup(function (event) {
    if(event.keyCode == 13) {
      $('#EditSystime').css("display", "none");
      $('#Systime').css("display", "");
    }
  });
}

function InitGlobalObjects () {
  gUploadFilesInfo = null;
  //
  // Server information is an JSON object
  //
  if (!gThisServerInfo) {
    gThisServerInfo = GetServerInfo ();
    if (!gThisServerInfo) {
      return false;
    }
  }
  if (gRemoteServers.length > 0) {
    gRemoteServers.splice (0, gRemoteServers.length);
  }

  return true;
}

function SubmitData (FunNum, IsReboot) {
  var HttpLink = "";
  var RestartInfo = "";
  var PopupMsg;
  var Result;
  var Data;

//  if (IsReboot == true) {
//    RestartInfo = "&" + SYSTEM_REBOOT_TRUE;
//    PopupMsg = "Processing...<br /><br />" +
//      "<b>System will reboot when operation is finished</b><br /><br />" +
//      "Please do <b>NOT</b> refresh this page!";
//  } else {
//    PopupMsg = "Processing...<br /><br />" +
//      "Please do <b>NOT</b> refresh this page!";
//  }
//  PopupInfo ("Send request", PopupMsg);

  //
  // To reflect floating timer
  //
//  if (gIsSetSysTime == true) {
//    $('#Month').val (gSysTimeArray.Month);
//    $('#Day').val (gSysTimeArray.Day);
//    $('#Year').val (gSysTimeArray.Year);
//    $('#Hour').val (gSysTimeArray.Hour);
//    $('#Minute').val (gSysTimeArray.Minute);
//    $('#Second').val (gSysTimeArray.Second);
//  }

  //
  // When default is disabled, those attribute should be removed before post
  //
  $(':input').not ('.NoSend').removeAttr("disabled");
//  $(':input').removeAttr("disabled");

  switch (parseInt(FunNum)) {
      case 1: // Save changes and exit
      case 3: // Save changes
      case 7:
          $('#DataForm').submit();
          break;
  }
  window.location.href = 'ExitBtn:' + FunNum;
/*
  Data = $('#DataForm').serialize() + RestartInfo;
  Result = pySaveScuData (FunNum, Data);
  switch (parseInt(FunNum)) {
  case 1: // Save changes and exit
    if (Result == 0) {
      pyExitScuCtrl (IsReboot);
    } else {
      SetPopupContent ("Save changes failed!");
    }
    break;

  case 3: // Save changes
    if (Result != 0) {
      SetPopupContent ("Save changes failed!");
    }
    break;

  case 5: // Load optimal defaults
    if (Result != 0) {
      SetPopupContent ("Load defaults failed!");
    }
    break;

  case 6: // Load customized defaults
    if (Result != 0) {
      SetPopupContent ("Load customized defaults failed!");
    }
    break;

  case 7: // Save customized defaults
    if (Result != 0) {
      SetPopupContent ("Save customized defaults failed!");
    }
    break;
  }
*/
  //SetCtrlButtons (POPUP_WIN_BTN_OK, ClosePopup);
}

function SubmitAndRestartSystem (FunNum) {
  PopupInfo ("Reboot confirm", "Are you going to <b>reboot</b> server after this action?");
  SetCtrlButtons (POPUP_WIN_BTN_YES, function () {
    SubmitData (FunNum, true);
  });
  SetCtrlButtons (POPUP_WIN_BTN_NO, function () {
    SubmitData (FunNum, false);
  });
}

function ConfirmMsg (FunNum, FunMsg, AskIfReboot) {
  PopupInfo ("Confirm Message", "Are you sure to <b>" + FunMsg + "</b>");

  SetCtrlButtons (POPUP_WIN_BTN_NO, ClosePopup);

  switch (parseInt(FunNum)) {

  case 7: // Save customized defaults
  case 1: // Save changes and exit
  case 3: // Save changes
  case 6: // Load customized defaults
      if (AskIfReboot == true) {
          SetCtrlButtons(POPUP_WIN_BTN_YES, function() {
              SubmitAndRestartSystem(FunNum);
          });
      } else {
          SetCtrlButtons(POPUP_WIN_BTN_YES, function() {
              SubmitData(FunNum, false);
          });
      }
      break;

  case 2: // Discard changes and exit
      SetCtrlButtons(POPUP_WIN_BTN_YES, function() {
          window.location.href = 'ExitBtn:' + FunNum;
      });
      break;

  case 4: // Discard changes
      //
      // Close this window without popup another confirm window
      //
      SetCtrlButtons(POPUP_WIN_BTN_YES, function() {
          UrlReload();
      });
      break;

  case 0: // Function number is not set
  default: // This case won't happen
      break;
  }
}

$('#ExitInfo .ExitBtn').click(function() {
    var Node = $(this);
    var FuncNumber = Node.attr("funnum");
    var NodtTitle = Node.find('span').html();

    switch (parseInt(FuncNumber)) {

        case 5:
            PopupInfo("Confirm Message", "This operation will <b>REBOOT</b> the system.<br/><br/>Are you sure to <b>" + Node.find('span').html() + "</b>");
            SetCtrlButtons(POPUP_WIN_BTN_NO, ClosePopup);
            SetCtrlButtons(POPUP_WIN_BTN_YES, function() {
            SubmitData(FuncNumber, false);
            });
            break;

        case 7: // Save customized defaults
        case 1: // Save changes and exit
        case 6: // Load customized defaults
            //    if ($('#BiosImgDefault').length > 0) {
            //      //
            //      // Bios default value doesn't need to reboot
            //      //
            //      ConfirmMsg (FuncNumber, Node.find('span').html(), false);
            //    } else {
            //      ConfirmMsg (FuncNumber, Node.find('span').html(), true);
            //    }
            //    break;

        case 2: // Discard changes and exit
        case 3: // Save changes
        case 4: // Discard changes
            ConfirmMsg(FuncNumber, Node.find('span').html(), false);
            break;

        case 0: // Function number is not set
        default: // This case won't happen
            break;
    }
});

function ReadFileGenTime () {

}

function ClickTab (NodeName) {
  var ThisObj;
  var TargetObj;
  var StdObj = $("#StdBody");
  var InnObj = $("#InnerBody");
  var HideObj = null;

  if (StdObj.is (":visible")) {
    //
    // Still on the top level of menu
    //
    if (StdObj.attr ("show") != undefined) {
      StdObj.removeAttr ("show");
    }
    ThisObj = StdObj.find ("div.FormFrame").filter(":visible");
    if (ThisObj.attr ("id") == (NodeName + "Info")) {
      return;
    }
    ThisObj.css ("display", "none");
  } else if (InnObj.is (":visible")) {
    HideObj = InnObj;
    if (HideObj.attr ("show") != undefined) {
      HideObj.removeAttr ("show");
    }
  } else {
    alert ("Is no presented frame?");
  }
  if (HideObj) {
    HideObj.find ("div.FormFrame").filter(":visible").css ("display", "none");
//    HideObj.css ("display", "none");
    StdObj.css ("display", "");
  }

  //
  // Back from other FormFrame
  //
  ThisObj = StdObj.find ("div.FormFrame").filter(":visible");
  if (ThisObj.attr ("id") == (NodeName + "Info")) {
    return;
  }
  ThisObj.css ("display", "none");
  TargetObj = $("#" + NodeName + "Info");
  TargetObj.css ("display", "");
  ControlFormRow ($(TargetObj));
}

function InitTab () {
  $("#MainInfo").css ("display", "");
  ControlFormRow ($("#MainInfo"));

  $("div a.LinkBtn").click (function () {
    var NodeName = $(this).html ();
    var StdBody = $("div#StdBody");
    var InnerBody = $("div#InnerBody");
    var TargetNode;

    if (gFormStack.length > 0) {
      gFormStack.splice (0, gFormStack.length);
    }
    if (gFormNameStack.length > 0) {
      gFormNameStack.splice (0, gFormNameStack.length);
    }
    $("div.FormFrame").filter (":visible").css ("display", "none");
    TargetNode = $("#" + NodeName + "Info");
    TargetNode.css ("display", "");

    ControlFormRow ($(TargetNode));
    StdBody.css ("display", "");
    InnerBody.css ("display", "none");
  });

  $(".ToPopupTitle").click (function () {
    var Fid = $(this).attr ("fid");
    var TargetNode = $("div#" + Fid + "Info");
    var TargetBody;
    var StdBody = $("div#StdBody");
    var InnerBody = $("div#InnerBody");
    var OldNode = $("div.FormFrame").filter (":visible");
    var TargetTitle = $(this).html ();
    var OldTitle = "";

    if (TargetNode.length == 0) {
      return;
    }
    OldNode.css ("display", "none");
    TargetNode.css ("display", "");
    ControlFormRow ($(TargetNode));
    if (StdBody.find ("div.FormFrame").filter (":visible").length > 0) {
      //
      // Target is in stdbody
      //
//      OldTitle = InnerBody.find ("span.InnerTitle").html ();
      gFormStack.splice (0, gFormStack.length);
      gFormNameStack.splice (0, gFormStack.length);
      StdBody.css ("display", "");
      InnerBody.css ("display", "none");
    } else if (InnerBody.find ("div.FormFrame").filter (function () {return ($(this).css ("display") == "block");}).length > 0) {
      //
      // Target is in innerbody
      //
      OldTitle = InnerBody.find ("span.InnerTitle").html ();
      InnerBody.find ("span.InnerTitle").html (TargetTitle);
      gFormStack.push (OldNode.attr ("id"));
      gFormNameStack.push (OldTitle);
      StdBody.css ("display", "none");
      InnerBody.css ("display", "");
    }
  });
}

function CloseMPage (PageObj) {
  var ShowForm;
  var BackObj;

  $("#MngBody").css ("display", "none");
  PageObj.css("display", "none");

  BackObj = $("#StdBody");
  if (BackObj.attr ("show") == undefined) {
    BackObj = $("#InnerBody");
  }
  BackObj.removeAttr ("show");
  BackObj.css ("display", "");

  $("#ManagementTool").siblings ().find ("div.SubTreeNode").css ("color", "");
//  $("#ManagementTool").siblings ().find ("div.SubTreeNode").removeClass ("TgtLinkColor");

  if (gTempFormId) {
    gTempFormId.css ("color", TREE_TGT_NODE_COLOR);
//    gTempFormId.addClass ("TgtLinkColor");
    gTempFormId = null;
  }
}

function ClickMPageBtn (PageName) {
  var MngBody = $("#MngBody");
  var PageObj = $("#" + PageName);
  var RunningPageObj = MngBody.find ("div.FormFrame").filter (":visible");
  var BackObj;

  if (!MngBody.is (":visible")) {
    BackObj = $("#StdBody");
    gTempFormId = $("#MenuList").find ("div.TreeNode[run='run']").find ("span.MenuLink[tab='tab']");
    gTempFormId.css ("color", "");
    if (!BackObj.is (":visible")) {
      BackObj = $("#InnerBody");
    }
    BackObj.attr ("show", true);
    BackObj.css ("display", "none");
    MngBody.css ("display", "");
  }

  if ((RunningPageObj.length > 0) && (RunningPageObj.attr ("id") != PageName)) {
    RunningPageObj.css ("display", "none");
    PageObj.css("display", "");
  } else if (!PageObj.is (":visible")) {
    PageObj.css("display", "");
  } else {
//    CloseMPage (PageObj);
  }
}

function ChangeInputValue () {
  var ThisNode = $(this);
  var RowObj = ThisNode.parents('.Row');

  if ((this.tagName).toLowerCase() == "input") {
    ValidateInputValue (ThisNode);
  }
  //
  // Save value to row object to reduce operating time in getting value
  // from :input object
  //
  RowObj.attr ("value", ThisNode.val());

  ControlFormRow (RowObj.parents(".FormFrame"));
}

function SelectTargetForm (InnerBody, TgtFormId, TitleStr) {
  var PreFormIndex;
  var TargetForm = $(TgtFormId);
  var TargetTitle = TargetForm.attr('title');
  var InnerBodyTitleObj = InnerBody.find('.InnerTitle');

  //
  // Set Popup frame title
  //
  if ((TargetTitle == '') || (TargetTitle == ' ')) {
    InnerBodyTitleObj.html (TitleStr);
  } else {
    InnerBodyTitleObj.html (TargetTitle);
  }

  TargetForm.css ("display", "");
}

function ClickPopupFromInfo () {
  var TgtFormId = "#" + gThisNode.attr(EXP_STR_ATTR_FORMID) + "Info";
  var ThisForm = gThisNode.parents('.FormFrame');
  var ThisFormId = ThisForm.attr("id");
  var MemuLink;
  var InnerBody = $('#InnerBody');

  ThisForm.css('display', 'none');
  InnerBody.css("display", "");

  SelectTargetForm (InnerBody, TgtFormId, gThisNode.html());
  ControlFormRow ($(TgtFormId));

  ClosePopup ();
}

function MouseOverHelpContent () {
//-[start-130118-IB10500006-modify]
  var HelpObj;

  if (!gShowHelpMsg) {
    return;
  }

  HelpObj = $(this).siblings(".HelpField");
  if (HelpObj.length > 0) {
//    $('#HelpBody').html(ParseTxtNewLineToHtmlBr (HelpObj.html()));
    HelpObj.css ("display", "");
    HelpObj.find (".HelpPopMsg").html (ParseTxtNewLineToHtmlBr (HelpObj.find (".HelpContent").html()));
  }
//-[end-130118-IB10500006-modify]
}

function MouseOutHelpContent () {
//-[start-130118-IB10500006-modify]
  var HelpObj;

  if (!gShowHelpMsg) {
    return;
  }

  HelpObj = $(this).siblings(".HelpField");

  if (HelpObj.css ("display") != "none") {
    HelpObj.css ("display", "none");
  }
//-[end-130118-IB10500006-modify]
}

function ReadLoadTime () {
  var RefreshTime = new Date ();

  $("#FixedBottomInfo").html (
    "Last Refresh Time: " +
    RefreshTime.getHours() + ":" +
    RefreshTime.getMinutes() + ":" +
    RefreshTime.getSeconds()
  );
}

//
// Initialize all objects those need to bind functions
//
function InitFunctionBinding () {
  var Node;


  $("div.FormFrame .MPageClose").click (function () {
    CloseMPage ($(this).parents (".FormFrame"));
  });

  $('#InnerBody .InnerBoddyClose').click(function() {
    var ThisForm = $("div.FormFrame:visible");
    var FromId = ThisForm.attr ("id").split ("Info")[0];
    var TargetForm;
    var InnerBody = $("div#InnerBody");

    if (gFormStack.length == 0) {
      alert ("Error: no backward form exists");
      return;
    }
    TargetForm = $("#" + gFormStack.pop());
    InnerBody.find ("span.InnerTitle").html (gFormNameStack.pop());
    ThisForm.css ("display", "none");
    TargetForm.css ("display", "");

    ControlFormRow ($(TargetForm));
    if ((ThisForm.parents ("#InnerBody").length > 0) && (TargetForm.parents ("#InnerBody").length == 0)) {
      //
      // Target form isn't under #InnerBody
      //
      InnerBody.css ("display", "none");
      $("div#StdBody").css ("display", "");
    } else if ((TargetForm.parents ("#InnerBody").length > 0) && (ThisForm.parents ("#InnerBody").length == 0)) {
      //
      // Target form is under #InnerBody
      //
      InnerBody.css ("display", "");
      $("div#StdBody").css ("display", "none");
    }
  });

  Node = $("div.FormFrame");
  Node.on("mouseover", ".Row", function () {
    var RowNode = $(this);

    RowNode.find(":input").unbind("change");
    RowNode.find(":input").change(ChangeInputValue);
    RowNode.find(".TitleField, .ContentField, .ToPopupTitle").unbind("mouseover");
    RowNode.find(".TitleField, .ContentField, .ToPopupTitle").mouseover(MouseOverHelpContent);
    RowNode.find(".TitleField, .ContentField, .ToPopupTitle").unbind("mouseout");
    RowNode.find(".TitleField, .ContentField, .ToPopupTitle").mouseout(MouseOutHelpContent);
  });
}

//-[start-130118-IB10500006-add]
$("#HelpMsgSwitch").click (function () {
  if ($(this).find ("input").is (":checked")) {
    gShowHelpMsg = true;
  } else {
    gShowHelpMsg = false;
  }
});
//-[end-130118-IB10500006-add]

function InitBootOrderTable () {
  var RowNodes = $('div#BootOrderTable').find ('span.BootDeviceRow');
  var TitleHeight = $('div#BootOrderContent').find ('span.SectionTitle').outerHeight(true);
  var RowTableheight = 0;
  var Order;

  $.each (RowNodes, function (index, obj) {
    //
    // Read order value
    //
    Order = parseInt($(obj).find('input').val());
    //
    // Set absolute position's top dependend on order value
    //
    $(obj).css('top', $(obj).outerHeight(true) * Order + TitleHeight);
    //
    // Plus all row's height
    //
    RowTableheight += $(obj).outerHeight(true);
  });

  $('#BootOrderTable').height (RowTableheight + TitleHeight);

  $('div#BootOrderContent').find ('.BootOrderControl').click (function () {
    var Node = $(this).siblings('.BootOrder'); // input text
    var TotalNum = $('div#BootOrderTable').find ('.BootOrder').length;
    var OthersRows;
    var ThisOrder = 0;
    var OtherOrder = 0;
    var IsUp = false;

    ThisOrder = parseInt(Node.val());
    //
    // Change order value
    //
    if ($(this).hasClass('BootOrderUp')) {
      if (ThisOrder == 0) {
        return;
      }
      IsUp = true;
      Node.val(ThisOrder - 1);
    } else {
      if ((ThisOrder + 1) == TotalNum) {
        return;
      }
      Node.val(ThisOrder + 1);
    }
    ThisOrder = parseInt(Node.val());
    //
    // Change absolute position
    //
    Node.parents('.BootDeviceRow').css('top', Node.parents('.BootDeviceRow').outerHeight(true) * ThisOrder + TitleHeight);
    //
    // Change positions of other items
    //
    OthersRows = Node.parents('.BootDeviceRow').siblings();
    $.each(OthersRows, function (index, obj) {
      OtherOrder = parseInt ($(obj).find('input').val());
      if (ThisOrder == OtherOrder) {
        if (IsUp == true) {
          $(obj).find('input').val(OtherOrder + 1);
        } else {
          $(obj).find('input').val(OtherOrder - 1);
        }
        //
        // Read order value again
        //
        OtherOrder = parseInt($(obj).find('input').val());
        //
        // Set absolute position's top dependend on order value
        //
        $(obj).css('top', $(obj).outerHeight(true) * OtherOrder + TitleHeight);
      }
    });
  });
  $('div#BootOrderLoading').css ("display", "none");
  $('div#BootOrderContent').css ("display", "");
}

function InitBootTypeOrderTable () {
  var RowNodes = $('div#BootTypeOrderTable').find ('span.BootDeviceRow');
  var TitleHeight = $('div#BootTypeOrderContent').find ('span.SectionTitle').outerHeight(true);
  var RowTableheight = 0;
  var Order;

  $.each (RowNodes, function (index, obj) {
    //
    // Read order value
    //
    Order = parseInt($(obj).find('input').val());
    //
    // Set absolute position's top dependend on order value
    //
    $(obj).css('top', ($(obj).outerHeight(true) * Order) + TitleHeight);
    //
    // Plus all row's height
    //
    RowTableheight += $(obj).outerHeight(true);
  });

  $('#BootTypeOrderTable').height (RowTableheight + TitleHeight);

  $('div#BootTypeOrderContent').find ('.BootOrderControl').click (function () {
    var Node = $(this).siblings('.BootOrder'); // input text
    var TotalNum = $('.BootOrder').length;
    var OthersRows;
    var ThisOrder = 0;
    var OtherOrder = 0;
    var IsUp = false;

    ThisOrder = parseInt(Node.val());
    //
    // Change order value
    //
    if ($(this).hasClass('BootOrderUp')) {
      if (ThisOrder == 0) {
        return;
      }
      IsUp = true;
      Node.val(ThisOrder - 1);
    } else {
      if ((ThisOrder + 1) == TotalNum) {
        return;
      }
      Node.val(ThisOrder + 1);
    }
    ThisOrder = parseInt(Node.val());
    //
    // Change absolute position
    //
    Node.parents('.BootDeviceRow').css('top', Node.parents('.BootDeviceRow').outerHeight(true) * ThisOrder + TitleHeight);
    //
    // Change positions of other items
    //
    OthersRows = Node.parents('.BootDeviceRow').siblings();
    $.each(OthersRows, function (index, obj) {
      OtherOrder = parseInt ($(obj).find('input').val());
      if (ThisOrder == OtherOrder) {
        if (IsUp == true) {
          $(obj).find('input').val(OtherOrder + 1);
        } else {
          $(obj).find('input').val(OtherOrder - 1);
        }
        //
        // Read order value again
        //
        OtherOrder = parseInt($(obj).find('input').val());
        //
        // Set absolute position's top dependend on order value
        //
        $(obj).css('top', $(obj).outerHeight(true) * OtherOrder + TitleHeight);
      }
    });
  });
  $('div#BootTypeOrderLoading').css ("display", "none");
  $('div#BootTypeOrderContent').css ("display", "");
}

function AsyncInitialization () {
  setTimeout (InitSystemTimer, 100);
  setTimeout (ReadFileGenTime, 500);
  setTimeout (ReadLoadTime, 900);
  setTimeout (InitBootOrderTable, 1300);
  setTimeout (InitBootTypeOrderTable, 1700);
}


