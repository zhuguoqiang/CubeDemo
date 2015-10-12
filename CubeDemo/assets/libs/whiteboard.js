/*
 * whiteboard.js
 * CubeTeam
 * 
 * Created by Zhu on 15/8/22.
 * Copyright (c) 2015 Cube Team. All rights reserved.
 */

;(function(g) {
	var resizeTimer = 0;
	var registerData = null;
	g.addEventListener('load', function (e) {
		g.app.start();
	}, false);

	window.addEventListener('resize', function (e) {
		if (resizeTimer > 0) {
			clearTimeout(resizeTimer);
		}
		
		resizeTimer = setTimeout(function() {
			clearTimeout(resizeTimer);
			g.app.resize(e);
		}, 200);
	}, false);
	
	window.addEventListener('error', function (e) {
		//error
		window.console.log('Message: ' + e.message + ' FileName: ' + e.filename + ' lineno: ' + e.lineno);
	}, false);
	
	g.app = {
		wb:null,
		bridge:null,
		registerData:null,
		start:function () {
			//cube._adjust({host:"192.168.0.198"});
			var ret = cube.startup(function () {
				g.console.log('Cube Engine 已启动' + cube.version);
				//alert('Cube Engine 已启动');
				
				// 加载白板
				g.app.wb = cube.loadWhiteboard('wb_canvas');
				// 设置注册监听器
				g.cube.setRegistrationListener(new SimpleRegistrationListener());
				// 设置白板监听器
				g.cube.setWhiteboardListener(new SimpleWhiteboardListener());
				
				var register = function(){
					if (window.cube.registered) {
						return;
					}
					//alert(g.registerData.name);
					window.cube.registerAccount(g.registerData.name, g.registerData.password, g.registerData.displayName);
				};

				//注册
				if (g.app.bridge != null) {
					//iOS
					g.app.bridge.callHandler('registerAccount', 'test', function (responseData) {
						g.registerData = responseData;
						var config = {'deviceName': g.registerData.deviceName};
						g.cube.configure(config);
						register();
					});
				}
				else if (utils.isAndroid) {
					// Android
					ajsb.addJavascriptMethod('registerAccountCallBack', function(params){
						g.registerData = params;
						var config = {'deviceName': params.deviceName};
						g.cube.configure(config);
						register();
						return {'register': 'register_start'};
					});
					ajsb.require('registerAccount', {'result': 'register'}, null);
				}

				// 重置大小
				g.app.resize();
			});
			if (!ret) {
				g.console.log('Cube Engine 启动失败！');
			}
		},
		resize:function () {
			
			if (null != this.wb) {
				this.wb.adjustSize();
			}
		},
		
		//分享
		shareWith:function(name) {
			if (name.length < 4) {
				alert('shareWith: 请输入正确的用户名');
				return;
			}
			var wb = window.cube.getWhiteboard();
			// 将白板分享给指定的用户
			if (wb.isSharing()) {
				// 停止分享
				wb.revokeSharing();
			}
			else {
				var back = wb.shareWith([name]);
			}
		},
		
		//停止分享
		revokeSharing:function () {
			var wb = window.cube.getWhiteboard();
			if (wb.isSharing())
			{
				wb.revokeSharing();
			}
		},
		
		//注册查询是否分享桥接
		isSharing:function() {
			var wb = window.cube.getWhiteboard();
			return wb.isSharing();
		},
		
		//取消选择
		unselect:function() {
			cube.getWhiteboard().unselect();
			cube.getWhiteboard().viewport.enabled = false;
		},
		
		//白板铅笔
		selectPencil:function () {
		  //cube.getWhiteboard().defaultColor = "#FE0000";
		  //cube.getWhiteboard().defaultWeight = 2;
		  var entity = cube.getWhiteboard().curEntity;
		  var pencil = null;
		  if (null == entity) {
			  pencil = new PencilEntity();
		  }else if (entity.name == 'pencil') {
			  pencil = entity;
		  }
		  cube.getWhiteboard().selectEntity(pencil);
		},
		
		//白板文本
		selectText:function () {
			var text = new TextEntity();
			cube.getWhiteboard().selectEntity(text);
		},
		
		//白板方框
		selectRect:function () {
			var rect = new RectEntity();
			cube.getWhiteboard().selectEntity(rect);
		},
		
		//白板圆圈
		selectEllipse:function () {
			var ellipse = new EllipseEntity();
			cube.getWhiteboard().selectEntity(ellipse);
		},
		
		// 白板撤销
		undo:function () {
			cube.getWhiteboard().undo();
		},
		
		// 白板重做
		redo:function () {
			cube.getWhiteboard().redo();
		},
		
		// 白板擦除
		erase:function () {
			cube.getWhiteboard().erase();
		},
		
		// 分享文件回调显示
		onSharingReady:function(file) {
		    // 如果有背景图片，则移除背景图片
		    cube.getWhiteboard().onSharingReady(file);
		},
		
		// 白板清空
		cleanup:function () {
			cube.getWhiteboard().cleanup();
		},
		
		// 设置铅笔参数
		configLine:function (options) {
			var entity = cube.getWhiteboard().curEntity;
		  if (options != undefined && null != entity && entity.name == 'pencil') {
			  entity.weight = options.weight || entity.weight || 2;
			  entity.color = options.color || entity.color || "#FE0000";
		  }
		},
		
		//下一页
		nextPage:function () {
			var slideEnitity = cube.getWhiteboard().getSlide();
			slideEnitity.nextPage();
		},
		
		//上一页
		prevPage:function () {
			var slideEnitity = cube.getWhiteboard().getSlide();
			slideEnitity.prevPage();
		},
		
		//前往某页
		gotoPage:function (num) {
			var slideEnitity = cube.getWhiteboard().getSlide();
			slideEnitity.gotoPage(num);	
		}
	};
	
	/*
	 * 实现注册白板监听器。
	 */
	g.SimpleRegistrationListener = Class(CubeRegistrationListener, {
		ctor: function() {
			// Nothing
		},

		onRegistrationProgress: function(session) {
			//正在注册
//			console.log('register WB in progress');
			if (g.app.bridge !== null) {//iOS
				g.app.bridge.callHandler('onWBRegister', {'state':'PROGRESS'}, function (responseData) {
					alert(responseData);
				});
			} else if (utils.isAndroid) {
				ajsb.require('register_Status', {'state': 'PROGRESS'}, null);
			}
		},

		onRegistrationOk: function(session) {
			//注册成功
//			console.log('register WB OK');
			if (g.app.bridge != null) {//iOS
				g.app.bridge.callHandler('onWBRegister', {'state':'OK'}, function (responseData) {
					alert(responseData);
				});
			} else if (utils.isAndroid) {
				ajsb.require('register_Status', {'state': 'OK'}, null);
			}
		},

		onRegistrationCleared: function(session) {
			//注销
//			console.log('register WB Clear');
			if (g.app.bridge !== null) {//iOS
				g.app.bridge.callHandler('onWBRegister', {'state':'CLEARED'}, function (responseData) {
					alert(responseData);
				});
			} else if (utils.isAndroid) {
				ajsb.require('register_Status', {'state': 'CLEARED'}, null);
			}
		},

		retryTimer: 0,

		onRegistrationFailed: function(session, errorCode) {
			//注册失败
//			console.log('register WB Failed');
			if (g.app.bridge !== null) {//iOS
				g.app.bridge.callHandler('onWBRegister', {'state':'FAILED', 'errorCode': errorCode}, function (responseData) {
					alert(responseData);
				});
			} else if (utils.isAndroid) {
				ajsb.require('register_Status', {'state': 'FAILED', 'errorCode':errorCode}, null);
			}

			if (this.retryTimer > 0) {
				clearTimeout(this.retryTimer);
			}
			var self = this;
			this.retryTimer = setTimeout(function() {
				clearTimeout(self.retryTimer);
				self.retryTimer = 0;

				// TODO
				if (g.registerData.name !== undefined && null != g.registerData.name) {
					window.cube.registerAccount(g.registerData.name, g.registerData.password, g.registerData.displayName);
				}
			}, 5000);
		}
	});
	
	/**
	 * 实现白板监听器。
	 */
	g.SimpleWhiteboardListener = Class(CubeWhiteboardListener, {
		ctor: function() {
			// Nothing
		},

		onShared: function(whiteboard, sharedList) {
//			window.console.log('onShared');
//			window.console.log('onShared:'+sharedList);
			if (g.app.bridge !== null) {
				//iOS
				g.app.bridge.callHandler('onWBShared', {'state':'OK', 'sharedList':sharedList}, function (responseData) {});
			} else if (utils.isAndroid) {
				ajsb.require('WBListener', {'state': 'OK', 'onShared':sharedList}, null);
			}
		},
		
		onRevoked: function(whiteboard) {
			if (g.app.bridge !== null) {
				//iOS
				g.app.bridge.callHandler('onWBRevoked', {'state':'OK'}, function (responseData) {});
			} else if (utils.isAndroid) {
				
			}
		},

		onFileShared: function(whiteboard, file) {
			if (g.app.bridge !== null) {
				g.app.bridge.callHandler('onWBFileShared', {'state':'OK', 'file':file}, function (responseData) {});
			} else if (utils.isAndroid) {
				ajsb.require('WBListener', {'state': 'OK', 'onFileShared':file}, null);
			}
		},

		onSlide: function(whiteboard, slide) {
			if (g.app.bridge !== null) {
				//iOS
				var docName = slide.getDocName();
				var numPages = slide.numPages();
			    var currentPage = slide.currentPage();
				g.app.bridge.callHandler('onWBSlide', {'state':'OK', 'slide': {'docName' : docName, 'numPages' : numPages, 'currentPage' : currentPage}}, function (responseData) {});
			} else if (utils.isAndroid ) {
				//A
				var docName = slide.getDocName();
				var numPages = slide.numPages();
			    var currentPage = slide.currentPage();
			    ajsb.require('WBListener', {'state': 'OK', 'onSlide':{'docName':docName,'numPages':numPages,'currentPage':currentPage}}, null);
			}
		},

		onFailed: function(whiteboard, errorCode) {
			if (g.app.bridge !== null) {
				//iOS
				g.app.bridge.callHandler('onWBShared', {'state':'FAILED', 'onFailed':errorCode}, function (responseData) {});
			}
			else if (utils.isAndroid) {
				ajsb.require('WBListener', {'state': 'FAILED', 'errorCode':errorCode}, null);
			}
		}
	});
})(window);
