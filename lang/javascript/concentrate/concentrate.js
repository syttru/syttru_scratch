(function(){

  function to_array(list){
    return Array.prototype.slice.apply(list);
  }

  function removeOtherThan(target){
    if(!target || !target.parentNode || target === document.body) return;
    to_array(target.parentNode.childNodes).forEach(function(brother){
      (brother !== target) && brother.parentNode.removeChild(brother);
    });
    arguments.callee(target.parentNode);
  }

  removeOtherThan(document.getElementsByClassName('section')[0]);

})();
