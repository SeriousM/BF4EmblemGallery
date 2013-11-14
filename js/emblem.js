// prerequisites
var clientside = {};
var S = {
    globalContext: bf4data
};
window.emblem = {};

// this is a dump from the EmblemClass, build by dice
(function() {
    var clientside = typeof window !== "undefined" && window.emblem;
    var fabriclib;
    if (clientside) {
        fabriclib = window.fabric;
    } else {
        var fs = require("fs");
        fabriclib = require("./fabric.js").fabric;
    }
    var EmblemClass = (function() {
        function F(elementId) {
            var self = this;
            this._cache = {};
            this.assetsPath = "/public/emblems/mohw/shapes/";
            this.size = 320;
            this.controlsColor = "#353535";
            this.controlsSize = 12;
            this.loaded = false;
            this.headless = false;
            this.data = false;
            this.logging = true;
            var element;
            if (elementId) {
                element = document.getElementById(elementId);
            } else {
                this.headless = true;
                element = document.createElement("canvas");
            }
            this.canvas = new fabriclib.Canvas(element, {perPixelTargetFind: true,controlsAboveOverlay: true,selection: false});
            this.canvas.setWidth(this.size);
            this.canvas.setHeight(this.size);
            this.canvas.observe("after:render", function() {
                if (!self.loaded) {
                    return;
                }
                var object;
                for (var i = 0; i < self.canvas._objects.length; i++) {
                    object = self.canvas._objects[i];
                    object.emblemObject.opacity = object.get("opacity");
                    object.emblemObject.fill = object.get("fill");
                    object.emblemObject.left = object.get("left");
                    object.emblemObject.top = object.get("top");
                    object.emblemObject.width = object.get("scaleX") * object.width;
                    object.emblemObject.height = object.get("scaleY") * object.height;
                    object.emblemObject.angle = object.get("angle");
                    object.emblemObject.flipX = object.get("flipX");
                    object.emblemObject.flipY = object.get("flipY");
                    object.emblemObject.selectable = object.get("selectable");
                }
            });
        }
        F.OBJECT_DEFAULTS = {left: 50,top: 50,angle: 0,width: 100,height: 100,opacity: 1,fill: "#353535",flipX: false,flipY: false,selectable: true};
        F.log = function() {
            if (this.logging && typeof console !== "undefined" && console.log && console.log.apply) {
                console.log.apply(console, arguments);
            }
        };
        F.debug = function() {
            if (this.logging && typeof console !== "undefined" && console.debug && console.debug.apply) {
                console.debug.apply(console, arguments);
            }
        };
        F.info = function() {
            if (this.logging && typeof console !== "undefined" && console.info && console.info.apply) {
                console.info.apply(console, arguments);
            }
        };
        F.prototype.load = function(data, callback) {
            var self = this;
            EmblemClass.debug("Emblem data to load", data);
            if (data == "" || arguments.length === 0 || !data) {
                data = {objects: []};
            }
            if (typeof data === "object") {
                self.data = data;
            } else {
                self.data = JSON.parse(data);
            }
            if (clientside && S) {
                self.data.objects = self.data.objects.filter(function(object) {
                    return !!S.globalContext.badgeParts[object.asset];
                });
            }
            if (self.data.background) {
                EmblemClass.debug("Setting background for emblem");
                self.setBackground(self.data.background);
            }
            if (!self.data.objects.length) {
                runComplete();
                return this;
            }
            EmblemClass.debug("Starting rendering of emblem objects.");
            var renderedObjects = 0;
            for (var i = 0; i < self.data.objects.length; i++) {
                var object = self.data.objects[i];
                self.renderObject(object, function() {
                    renderedObjects++;
                    if (renderedObjects === self.data.objects.length) {
                        runComplete();
                    }
                });
            }
            function runComplete() {
                EmblemClass.debug("Emblem is now fully loaded and rendered.");
                self.canvas.observe("object:removed", function(e) {
                    var object = e.target;
                    EmblemClass.debug("Object removed from emblem", object);
                    var emblemObjectIndex = self.data.objects.indexOf(object.emblemObject);
                    self.data.objects.splice(emblemObjectIndex, 1);
                });
                self.canvas.deactivateAllWithDispatch();
                self.render();
                self.loaded = true;
                if (callback) {
                    callback();
                }
            }
            return this;
        };
        F.prototype.loadLegacy = function(badgeData, callback) {
            var data = {objects: [],background: "#F4F4F4"};
            for (var i = 0; i < badgeData.objects.length; i++) {
                var legacyObject = badgeData.objects[i];
                var object = {};
                object.asset = legacyObject.partId;
                legacyObject.width *= legacyObject.scaleX;
                legacyObject.height *= legacyObject.scaleY;
                data.objects.push(object);
                for (var key in F.OBJECT_DEFAULTS) {
                    if (!F.OBJECT_DEFAULTS.hasOwnProperty(key)) {
                        continue;
                    }
                    object[key] = typeof legacyObject[key] === "undefined" ? F.OBJECT_DEFAULTS[key] : legacyObject[key];
                }
            }
            if (typeof badgeData.background !== "undefined") {
                data.background = badgeData.background;
            }
            return this.load(data, callback);
        };
        F.prototype.createImage = function(size) {
            this.canvas.deactivateAll();
            return this.canvas.toDataURL({format: "png",multiplier: size ? parseInt(size, 10) / this.size : 1});
        };
        F.prototype.fetchShapeData = function(key, callback) {
            EmblemClass.debug("Fetching shape data for", key);
            if (this._cache[key]) {
                EmblemClass.debug("Shape data was cached for", key);
                if (callback) {
                    callback(this._cache[key]);
                }
            } else {
                var shapeUrl = this.assetsPath + key + ".svg";
                var that = this;
                EmblemClass.debug("Shape data was not cached for", key, "... fetching...");
                var cacheAsset = function(data) {
                    that._cache[key] = data;
                    if (callback) {
                        callback(that._cache[key]);
                    }
                };
                if (clientside) {
                    fabriclib.util.request(shapeUrl, {method: "get",onComplete: function(r) {
                            cacheAsset(r.responseText);
                        }});
                } else {
                    if (fs.exists(shapeUrl)) {
                        cacheAsset(fs.read(shapeUrl));
                    } else {
                        EmblemClass.error("File does not exists, can not fetch it.", shapeUrl);
                        if (callback) {
                            callback(null);
                        }
                    }
                }
            }
        };
        F.prototype.getFabricObject = function(key, callback) {
            EmblemClass.debug("Getting (fabric) object", key);
            this.fetchShapeData(key, function(string) {
                if (string === null) {
                    if (callback) {
                        callback(null);
                    }
                    return;
                }
                fabriclib.loadSVGFromString(string, function(objects, options) {
                    EmblemClass.debug("Loaded SVG", key);
                    var object = fabriclib.util.groupSVGElements(objects, options);
                    object.hasRotatingPoint = true;
                    EmblemClass.debug("Object fully loaded", key, object);
                    if (callback) {
                        callback(object);
                    }
                });
            });
        };
        F.prototype.render = function() {
            var self = this;
            this.canvas._objects.sort(function(a, b) {
                var aIndex = self.data.objects.indexOf(a.emblemObject);
                var bIndex = self.data.objects.indexOf(b.emblemObject);
                return aIndex - bIndex;
            });
            this.canvas.renderAll();
            return this;
        };
        F.prototype.setBackground = function(color) {
            this.data.background = color;
            this.canvas.backgroundColor = color;
            this.render();
        };
        F.prototype.setOverlay = function(src, callback) {
            var self = this;
            this.canvas.setOverlayImage(src, function() {
                self.render();
                if (callback) {
                    callback();
                }
            });
        };
        F.prototype.renderObject = function(object, callback) {
            var self = this;
            EmblemClass.debug("Render object", object);
            this.getFabricObject(object.asset, function(fabricObject) {
                if (fabricObject === null) {
                    EmblemClass.debug("Could not get asset", object.asset, "... Ignoring");
                    if (callback) {
                        callback(null);
                    }
                    return;
                }
                EmblemClass.debug("Got (fabric)object", fabricObject, "... Adding it to canvas", object);
                fabricObject.emblemObject = object;
                if (object.width && object.height) {
                    fabricObject.set({scaleX: object.width / fabricObject.width,scaleY: object.height / fabricObject.height}).setCoords();
                } else {
                    if (fabricObject.width > fabricObject.height) {
                        fabricObject.scaleToWidth(EmblemClass.OBJECT_DEFAULTS.width).setCoords();
                    } else {
                        fabricObject.scaleToHeight(EmblemClass.OBJECT_DEFAULTS.height).setCoords();
                    }
                }
                if (object.left && object.top) {
                    fabricObject.set({left: object.left,top: object.top}).setCoords();
                } else {
                    fabricObject.set({left: self.size / 2,top: self.size / 2}).setCoords();
                }
                fabricObject.set({opacity: object.opacity,fill: object.fill,angle: object.angle,flipX: object.flipX,flipY: object.flipY,selectable: object.selectable,borderColor: self.controlsColor,cornerColor: self.controlsColor,cornerSize: self.controlsSize,transparentCorners: false,rotatingPointOffset: 16 + self.controlsSize}).setCoords();
                self.canvas.add(fabricObject);
                self.render();
                if (callback) {
                    callback(fabricObject);
                }
            });
            return this;
        };
        F.prototype.toJson = function() {
            return JSON.stringify(this.data);
        };
        F.prototype.createObject = function(assetKey, options, callback) {
            if (this.headless) {
                EmblemClass.error("Cannot create emblem item. Emblem is not editable.");
                return false;
            }
            options = options || {};
            var optionsSelectableSet = typeof options.selectable !== "undefined";
            var object = {asset: assetKey,left: options.left || false,top: options.top || false,angle: options.angle || 0,width: options.width || false,height: options.height || false,opacity: options.opacity || EmblemClass.OBJECT_DEFAULTS.opacity,fill: options.fill || EmblemClass.OBJECT_DEFAULTS.fill,flipX: options.flipX || false,flipY: options.flipY || false,selectable: optionsSelectableSet ? options.selectable : EmblemClass.OBJECT_DEFAULTS.selectable};
            this.data.objects.push(object);
            this.renderObject(object, callback);
            return this;
        };
        return F;
    })();
    if (clientside) {
        window.emblem.EmblemClass = EmblemClass;
    } else {
        exports.EmblemClass = EmblemClass;
    }
})();

var initEmblem = function(canvasElementId, assetsPath){
    emblem.emblem = new emblem.EmblemClass(canvasElementId);
    emblem.emblem.assetsPath = assetsPath;
    emblem.emblem.clear = function(){
        emblem.emblem.canvas.clear();
    };
    emblem.emblem.logging = false;
};