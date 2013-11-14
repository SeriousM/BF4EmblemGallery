var loadEmblemData = function(text){
    text = text.trim();
    if (text.indexOf("emblem.emblem") >= 0){
        text = /emblem.emblem.load\(([.\S\s]*)\);?/.exec(text)[1];
    }
    
    emblem.emblem.clear();
    emblem.emblem.load(text);
};