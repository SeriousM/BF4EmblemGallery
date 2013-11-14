window.loadEmblem = function(text){
    text = text.trim();
    if (text.indexOf("emblem.emblem") >= 0){
        text = /emblem.emblem.load\(([.\S\s]*)\);?/.exec(text)[1];
    }
    
    window.clearEmblem();
    emblem.emblem.load(text);
};

window.clearEmblem = function(){
    emblem.emblem.clear();
};