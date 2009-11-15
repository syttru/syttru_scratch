/**
 * IE6でもlabelで囲む記述が有効になるようにする。
 */
$(function(){
  $("label:not([for]):has(:input)").each(function(){
    var input = $(this).children(":input");
    input.attr("id",input.attr("id") || generateId());
    $(this).attr("for", input.attr("id"));
  });

  /* 既存のと重複しない一意のIDを生成する関数 */
  function generateId(){
    arguments.callee.count |= 0;
    arguments.callee.count++;
    var id = "generated.input.id$" + arguments.callee.count;
    return document.getElementById(id) == null ? id : generateId();
  }
});
