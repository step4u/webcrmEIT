

	actionData = {
			volume: {
				x: 0,
				y: 0,
				width: 0,
				height: 0,
				backgroundSize: 0,
				defaultVolume: 1
			}
		};

	function getActionData(target) {
        // DOM measurements for volume slider
        if (!target) {
			return false;
		}

		actionData.volume.x = utils.position.getOffX(target);
		actionData.volume.y = utils.position.getOffY(target);

		actionData.volume.width = target.offsetWidth;
        actionData.volume.height = target.offsetHeight;

        // potentially dangerous: this should, but may not be a percentage-based value.
        actionData.volume.backgroundSize = parseInt(utils.style.get(target, 'background-size'), 10);

        // IE gives pixels even if background-size specified as % in CSS. Boourns.
        if (window.navigator.userAgent.match(/msie|trident/i)) {
			actionData.volume.backgroundSize = (actionData.volume.backgroundSize / actionData.volume.width) * 100;
        }
	}
	
	function Player ( url, el ) {
	  this.ac = new ( window.AudioContext || webkitAudioContext )();
	  this.url = url;
	  this.el = el;
	  this.button = el.querySelector('.sm2-button-bd');
	  this.track = el.querySelector('.sm2-progress-track');
	  this.progress = el.querySelector('.sm2-progress-bar');
	  this.scrubber = el.querySelector('.sm2-progress-ball');
	  this.volume = el.querySelector('a.sm2-volume-control');
	  this.volumeContainter = el.querySelector('#volumeContainter');
	  this.lineTime = el.querySelector('.sm2-inline-time');
	  this.lineDuration = el.querySelector('.sm2-inline-duration');
	  this.message = el.querySelector('#playertitle');
	  this.message.innerHTML = 'Loading...';
	  this.bindEvents();
	  this.fetch();
	  getActionData(this.volume);
	}
	
	Player.prototype.close = function() {
		// this.pause();
		this.ac.close();
	};

	Player.prototype.bindEvents = function() {
		this.button.addEventListener('click', this.toggle.bind(this));
		this.scrubber.addEventListener('mousedown', this.onMouseDown.bind(this));
		this.volumeContainter.addEventListener('mousedown', this.onMouseDown.bind(this));
		window.addEventListener('mousemove', this.onDrag.bind(this));
		window.addEventListener('mouseup', this.onMouseUp.bind(this));
	};

	Player.prototype.fetch = function() {
	  var xhr = new XMLHttpRequest();
	  xhr.open('GET', this.url, true);
	  xhr.responseType = 'arraybuffer';
	  xhr.onload = function() {
		this.decode(xhr.response);
		console.log('media file is loaded...');
	  }.bind(this);
	  xhr.send();
	};

	Player.prototype.decode = function( arrayBuffer ) {
	  this.ac.decodeAudioData(arrayBuffer, function( audioBuffer ) {
		this.message.innerHTML = '';
		this.buffer = audioBuffer;
		this.draw();
		this.play();
	  }.bind(this));
	};

	Player.prototype.connect = function() {
	  if ( this.playing ) {
		this.pause();
	  }
	  this.source = this.ac.createBufferSource();
	  this.source.buffer = this.buffer;
	  this.gainNode = this.ac.createGain();
	  this.source.connect(this.gainNode);
	  // this.source.connect(this.ac.destination);
	  this.gainNode.connect(this.ac.destination);
	  this.gainNode.gain.value = actionData.volume.defaultVolume;
	};

	Player.prototype.play = function( position ) {
		this.connect();
		this.position = typeof position === 'number' ? position : this.position || 0;
		this.startTime = this.ac.currentTime - ( this.position || 0 );
		this.source.start(this.ac.currentTime, this.position);
		this.playing = true;
		this.updatePlayTime();

	  	utils.css.swap(this.button, 'paused', 'playing');
	};

	Player.prototype.pause = function() {
		if ( this.source ) {
			this.source.stop(0);
			this.source = null;
			this.position = this.ac.currentTime - this.startTime;
			this.playing = false;
			
			utils.css.swap(this.button, 'playing', 'paused');
		}
	};

	Player.prototype.seek = function( time ) {
		if ( this.playing ) {
			this.play(time);
		} else {
			this.position = time;
			this.updatePlayTime(time);
		}
	};

	Player.prototype.updatePosition = function() {
		this.position = this.playing ? this.ac.currentTime - this.startTime : this.position;
		if ( this.position >= this.buffer.duration ) {
			this.position = this.buffer.duration;
			this.pause();
		}
		return this.position;
	};

	Player.prototype.toggle = function() {
	  if ( !this.playing ) {
		this.play();
	  } else {
		this.pause();
	  }
	};
	
	Player.prototype.adjustVolume = function(e) {
		var backgroundMargin,
			pixelMargin,
			target,
			value,
			volume;

		value = 0;

		target = this.volume;

        // safety net
		if (e === undefined) {
			return false;
		}

		if (!e || e.clientX === undefined) {
			// called directly or with a non-mouseEvent object, etc.
			// proxy to the proper method.
			if (arguments.length && window.console && window.console.warn) {
				console.warn('Bar UI: call setVolume(' + e + ') instead of adjustVolume(' + e + ').');
			}
			return this.setVolume.apply(this, arguments);
		}

		// based on getStyle() result
		// figure out spacing around background image based on background size, eg. 60% background size.
		// 60% wide means 20% margin on each side.
		backgroundMargin = (100 - actionData.volume.backgroundSize) / 2;

		// relative position of mouse over element
		value = Math.max(0, Math.min(1, (e.clientX - actionData.volume.x) / actionData.volume.width));

		target.style.clip = 'rect(0px, ' + (actionData.volume.width * value) + 'px, ' + actionData.volume.height + 'px, ' + (actionData.volume.width * (backgroundMargin/100)) + 'px)';

		// determine logical volume, including background margin
		pixelMargin = ((backgroundMargin/100) * actionData.volume.width);

		volume = Math.max(0, Math.min(1, ((e.clientX - actionData.volume.x) - pixelMargin) / (actionData.volume.width - (pixelMargin*2)))) * 100;

		// set volume
		this.setVolume(volume);
		// actionData.volume.defaultVolume = volume;
		// console.log('adjustVolume');

		return utils.events.preventDefault(e);
	};

	Player.prototype.setVolume = function(volume) {
        // set volume (0-100) and update volume slider UI.

        var backgroundSize,
            backgroundMargin,
            backgroundOffset,
            target,
            from,
            to;

        if (volume === undefined || isNaN(volume))
			return;

        if (this.volume) {
          target = this.volume;

          // based on getStyle() result
          backgroundSize = actionData.volume.backgroundSize;

          // figure out spacing around background image based on background size, eg. 60% background size.
          // 60% wide means 20% margin on each side.
          backgroundMargin = (100 - backgroundSize) / 2;

          // margin as pixel value relative to width
          backgroundOffset = actionData.volume.width * (backgroundMargin/100);

          from = backgroundOffset;
          to = from + ((actionData.volume.width - (backgroundOffset*2)) * (volume/100));

          target.style.clip = 'rect(0px, ' + to + 'px, ' + actionData.volume.height + 'px, ' + from + 'px)';
        }

        // apply volume to sound, as applicable
        this.gainNode.gain.value = volume / 100;
		actionData.volume.defaultVolume = volume / 100;

		// console.log('setvolume : ' + volume / 100);
	};
	
	Player.prototype.updatePlayTime = function(time) {
		// if (!this.playing) return;
	  	if (typeof(time) == 'undefined') {
			this.lineTime.innerHTML = Secs2mmss((this.ac.currentTime - this.startTime));
	  	} else {
	  		var curtime = 0;
	  		if (time <= this.startTime)
	  			curtime = this.startTime;
	  		else
	  			curtime = time - this.startTime;
	  		
	  		this.lineTime.innerHTML = Secs2mmss(curtime);
	  	}

	  	this.lineDuration.innerHTML = Secs2mmss(this.buffer.duration);
	};
	
	Player.prototype.onMouseDown = function( e ) {
		this.selectedEl = e.target || e.srcElement;
		// console.log('this.selectedEl : ' + this.selectedEl);
		if (utils.css.has(this.selectedEl, 'sm2-volume-control')) {
			console.log('grapped');
			getActionData(this.selectedEl);
			this.dragging = true;
			this.adjustVolume(e);
		} 
		if (utils.css.has(this.selectedEl, 'sm2-progress-ball')) {
			this.dragging = true;
			this.startX = e.pageX;
			this.startLeft = parseInt(this.scrubber.style.left || 0, 10);
		}
		
		console.log('onMouseDown');
	};

	Player.prototype.onDrag = function( e ) {
		if ( !this.dragging )
			return;
		
		if (utils.css.has(this.selectedEl, 'sm2-volume-control')) {
			this.adjustVolume(e);
		}
		if (utils.css.has(this.selectedEl, 'sm2-progress-ball')) {
			var width, position;
			width = this.track.offsetWidth;
			position = this.startLeft + ( e.pageX - this.startX );
			position = Math.max(Math.min(width, position), 0);
			this.scrubber.style.left = position + 'px';
		}

		console.log('onDrag');
	};

	Player.prototype.onMouseUp = function() {
		var width, left, time;
		if ( this.dragging ) {
			//if (utils.css.has(this.selectedEl, 'sm2-volume-control')) { }
			if (utils.css.has(this.selectedEl, 'sm2-progress-ball')) {
				width = this.track.offsetWidth;
				left = parseInt(this.scrubber.style.left || 0, 10);
				time = left / width * this.buffer.duration;
				this.seek(time);
			}

			this.dragging = false;
			this.selectedEl = null;
			
			console.log('onMouseUp');
		}
	};

	Player.prototype.draw = function() {
		if (this.playing)  this.updatePlayTime();
		
		var progress = ( this.updatePosition() / this.buffer.duration ),
			width = this.track.offsetWidth;
		/*
		if ( this.playing ) {
			this.button.classList.add('fa-pause');
			this.button.classList.remove('fa-play');
		} else {
			this.button.classList.add('fa-play');
			this.button.classList.remove('fa-pause');
		}
		*/
		this.progress.style.width = ( progress * width ) + 'px';
		if ( !this.dragging ) {
			this.scrubber.style.left = ( progress * width ) + 'px';
		} else {
			if (!utils.css.has(this.selectedEl, 'sm2-progress-ball')) {
				this.scrubber.style.left = ( progress * width ) + 'px';
			}
		}
		requestAnimationFrame(this.draw.bind(this));
	};
	
	Secs2mmss = function (totalsecs) {
		totalsecs = totalsecs.toFixed(0);
		var hours   = Math.floor(totalsecs / 3600);
		var minutes = Math.floor((totalsecs - (hours * 3600)) / 60);
		var seconds = totalsecs - (hours * 3600) - (minutes * 60);

		// round seconds
		seconds = Math.round(seconds * 100) / 100
		// console.log('seconds : ' + seconds);

		var result = (hours < 10 ? "0" + hours : hours);
		result += ":" + (minutes < 10 ? "0" + minutes : minutes);
		result += ":" + (seconds  < 10 ? "0" + seconds : seconds);
		
		return result;
	};

	// ��ƿ��Ƽ
	utils = {
		array: (function() {
			function compare(property) {
				var result;
				return function(a, b) {

					if (a[property] < b[property]) {
						result = -1;
					} else if (a[property] > b[property]) {
						result = 1;
					} else {
						result = 0;
					}
					return result;
				};
			}

			function shuffle(array) {
				// Fisher-Yates shuffle algo
				var i, j, temp;
				for (i = array.length - 1; i > 0; i--) {
					j = Math.floor(Math.random() * (i+1));
					temp = array[i];
					array[i] = array[j];
					array[j] = temp;
				}
				return array;
			}

			return {
				compare: compare,
				shuffle: shuffle
			};
		}()),

		css: (function() {
			function hasClass(o, cStr) {
				return (o.className !== undefined ? new RegExp('(^|\\s)' + cStr + '(\\s|$)').test(o.className) : false);
			}

			function addClass(o, cStr) {
				if (!o || !cStr || hasClass(o, cStr)) {
					return false; // safety net
				}
				o.className = (o.className ? o.className + ' ' : '') + cStr;
			}

			function removeClass(o, cStr) {
				if (!o || !cStr || !hasClass(o, cStr)) {
					return false;
				}
				o.className = o.className.replace(new RegExp('( ' + cStr + ')|(' + cStr + ')', 'g'), '');
			}

			function swapClass(o, cStr1, cStr2) {
				var tmpClass = {
					className: o.className
				};
				removeClass(tmpClass, cStr1);
				addClass(tmpClass, cStr2);
				o.className = tmpClass.className;
			}

			function toggleClass(o, cStr) {
				var found,
				method;

				found = hasClass(o, cStr);
				method = (found ? removeClass : addClass);
				method(o, cStr);
			        // indicate the new state...
					return !found;
			}

			return {
				has: hasClass,
				add: addClass,
				remove: removeClass,
				swap: swapClass,
				toggle: toggleClass
			};
		}()),

		dom: (function() {
			function getAll(param1, param2) {
				var node,
				selector,
				results;

				if (arguments.length === 1) {
					// .selector case
					node = document.documentElement;
					// first param is actually the selector
					selector = param1;
				} else {
					// node, .selector
					node = param1;
					selector = param2;
				}

				// sorry, IE 7 users; IE 8+ required.
				if (node && node.querySelectorAll) {
					results = node.querySelectorAll(selector);
				}

				return results;
			}

			function get(/* parentNode, selector */) {
				var results = getAll.apply(this, arguments);
				// hackish: if an array, return the last item.
				if (results && results.length) {
					return results[results.length-1];
				}

				// handle "not found" case
				return results && results.length === 0 ? null : results;
			}

			function ancestor(nodeName, element, checkCurrent) {
				var result;

				if (!element || !nodeName) {
					return element;
				}

				nodeName = nodeName.toUpperCase();

				// return if current node matches.
				if (checkCurrent && element && element.nodeName === nodeName) {
					return element;
				}

				while (element && element.nodeName !== nodeName && element.parentNode) {
					element = element.parentNode;
				}

				return (element && element.nodeName === nodeName ? element : null);
			}

			return {
				ancestor: ancestor,
				get: get,
				getAll: getAll
			};
		}()),

		position: (function() {
			function getOffX(o) {
				// http://www.xs4all.nl/~ppk/js/findpos.html
				var curleft = 0;

				if (o.offsetParent) {
					while (o.offsetParent) {
						curleft += o.offsetLeft;
						o = o.offsetParent;
					}
				} else if (o.x) {
					curleft += o.x;
				}
				return curleft;
			}

			function getOffY(o) {
				// http://www.xs4all.nl/~ppk/js/findpos.html
				var curtop = 0;

				if (o.offsetParent) {
					while (o.offsetParent) {
						curtop += o.offsetTop;
						o = o.offsetParent;
					}
				} else if (o.y) {
					curtop += o.y;
				}
				return curtop;
			}

			return {
				getOffX: getOffX,
				getOffY: getOffY
			};
		}()),

		style: (function() {
			function get(node, styleProp) {
				// http://www.quirksmode.org/dom/getstyles.html
				var value;

				if (node.currentStyle) {
					value = node.currentStyle[styleProp];
				} else if (window.getComputedStyle) {
					value = document.defaultView.getComputedStyle(node, null).getPropertyValue(styleProp);
				}
				return value;
			}
			
			return {
				get: get
			};
		}()),

		events: (function() {
			var add, remove, preventDefault;
			
			add = function(o, evtName, evtHandler) {
				// return an object with a convenient detach method.
				var eventObject = {
					detach: function() {
						return remove(o, evtName, evtHandler);
					}
				};
				if (window.addEventListener) {
					o.addEventListener(evtName, evtHandler, false);
				} else {
					o.attachEvent('on' + evtName, evtHandler);
				}
				return eventObject;
			};

			remove = (window.removeEventListener !== undefined ? function(o, evtName, evtHandler) {
				return o.removeEventListener(evtName, evtHandler, false);
			} : function(o, evtName, evtHandler) {
				return o.detachEvent('on' + evtName, evtHandler);
			});

			preventDefault = function(e) {
				if (e.preventDefault) {
					e.preventDefault();
				} else {
					e.returnValue = false;
					e.cancelBubble = true;
				}
				return false;
			};

			return {
				add: add,
				preventDefault: preventDefault,
				remove: remove
			};
		}()),

		features: (function() {
			var getAnimationFrame,
			localAnimationFrame,
			localFeatures,
			prop,
			styles,
			testDiv,
			transform;

			testDiv = document.createElement('div');

			/**
			* hat tip: paul irish
			* http://paulirish.com/2011/requestanimationframe-for-smart-animating/
			* https://gist.github.com/838785
			*/

			localAnimationFrame = (window.requestAnimationFrame
				|| window.webkitRequestAnimationFrame
				|| window.mozRequestAnimationFrame
				|| window.oRequestAnimationFrame
				|| window.msRequestAnimationFrame
				|| null);

				// apply to window, avoid "illegal invocation" errors in Chrome
				getAnimationFrame = localAnimationFrame ? function() {
					return localAnimationFrame.apply(window, arguments);
				} : null;

			function has(prop) {
				// test for feature support
				var result = testDiv.style[prop];
				return (result !== undefined ? prop : null);
			}

			// note local scope.
			localFeatures = {
				transform: {
					ie: has('-ms-transform'),
					moz: has('MozTransform'),
					opera: has('OTransform'),
					webkit: has('webkitTransform'),
					w3: has('transform'),
					prop: null // the normalized property value
				},

				rotate: {
					has3D: false,
					prop: null
				},

				getAnimationFrame: getAnimationFrame
			};

			localFeatures.transform.prop = (
				localFeatures.transform.w3 ||
				localFeatures.transform.moz ||
				localFeatures.transform.webkit ||
				localFeatures.transform.ie ||
				localFeatures.transform.opera
			);

			function attempt(style) {
				try {
					testDiv.style[transform] = style;
				} catch(e) {
					// that *definitely* didn't work.
					return false;
				}
				// if we can read back the style, it should be cool.
				return !!testDiv.style[transform];
			}

			if (localFeatures.transform.prop) {
				// try to derive the rotate/3D support.
				transform = localFeatures.transform.prop;
				styles = {
					css_2d: 'rotate(0deg)',
					css_3d: 'rotate3d(0,0,0,0deg)'
				};

				if (attempt(styles.css_3d)) {
					localFeatures.rotate.has3D = true;
					prop = 'rotate3d';
				} else if (attempt(styles.css_2d)) {
					prop = 'rotate';
				}
				
				localFeatures.rotate.prop = prop;
			}

			testDiv = null;
			
			return localFeatures;
		}())
	};