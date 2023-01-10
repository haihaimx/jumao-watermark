<template>
	<view class="div">
		<view class="">
			<cu-custom bgColor="bg-gradual-orange" :isBack="true">
				<block slot="content">图集</block>
			</cu-custom>
		</view>
		
		<view style="width: 100%;" v-if="ad_id != '关闭'">
			<ad :unit-id="ad_id" ad-type="video" ad-theme="white"></ad>
		</view>
		<view class="padding">

				<view class="u-demo-block">
					<u-swiper :list="images" effect3d-previous-margin="50" :circular="false" :autoplay="false"
						border-radius="6" bgColor="#ffffff" height="800" :current="index" @change="change"
						:effect3d="true">
					</u-swiper>
				</view>

				<view class="cu-bar btn-group margin-top-xl" style="padding: 0rpx 10rpx;">
					<button class="cu-btn line-orange shadow lg radius" @click="copyText">复制链接</button>
					<button class="cu-btn bg-gradual-orange shadow lg radius" @click="dow">保存封面</button>
				</view>
				<view class="padding flex flex-direction">
					<button class="cu-btn bg-gradual-orange lg" @click="dows">全部下载</button>
				</view>

				<view class="cu-bar bg-white radius-xl margin-top">
					<view class="action sub-title">
						<text class="text-xl text-bold text-orange">文案</text>
						<text class="text-ABC text-orange">content</text>
					</view>
				</view>
				<view class="cu-form-group align-start">
					<textarea v-model="data.title" placeholder="点击下方按钮可以复制文案"
						style="height: 250rpx;background-color: #F9F9FB;border-radius: 15rpx;padding: 20rpx;"></textarea>
				</view>
				<view class="padding flex flex-direction">
					<button class="cu-btn bg-gradual-orange lg" @click="copywa">复制文案</button>
				</view>

		</view>
	</view>
</template>

<script>
	import Base64 from 'base-64';
	var App = require("@/common.js");
	export default {
		data() {
			return {
				images: [],
				data: {},
				index: 0,
				code: 403,
				image: 1,

				listBar: [
					'如遇加载失败等，请重新解析！'
				],

				TabCur: 0,
				barList: ['图集', '文案', '其他'],

				ad_id: "关闭",

			}
		},
		mounted() {
			this.data = uni.getStorageSync("videoData")
			this.images = this.data.images
			console.log(this.data.images)

			uni.setNavigationBarTitle({
				title: this.data.title
			})

			var setting = uni.getStorageSync("setting")
			if (setting.wxConfig.is_ad == '1') {
				this.ad_id = setting.wxConfig.ad_video
			}
		},
		watch: {
			code(newVal, oldVal) {
				if (newVal == 200) {
					uni.hideLoading()
					uni.showToast({
						title: "已保存到相册",
						icon: "success",
						duration: 3000
					})
				}
			},
			image(newVal, oldVal) {
				if (newVal - 1 < this.images.length) {
					uni.showLoading({
						title: "下载第" + this.image + "/" + this.images.length + "张"
					})
					var msg = this.images[newVal - 1]
					// msg = encodeURIComponent(msg)
					this.transit(msg, 1)
				} else {
					uni.hideLoading()
					uni.showToast({
						title: "已全部保存",
						icon: "success",
						duration: 3000
					})
				}
			}


		},
		methods: {
			tabSelect(e) {
				this.TabCur = e.currentTarget.dataset.id;
			},
			change(index) {
				this.index = index
			},
			transit(url, i) {
				this.download(App.download_image_url + encodeURIComponent(url), i)
				// uni.request({
				// 	url: App.download_url,
				// 	method: "POST",
				// 	header: {
				// 		'content-type': 'application/x-www-form-urlencoded'
				// 	},
				// 	data: {
				// 		'url': Base64.encode(url),
				// 		'type': 'jpg',
				// 	},
				// 	success: (res) => {
				// 		console.log("图片下载", res)
				// 		if (res.data.code == 200) {
				// 			this.download(res.data.data.url, i)
				// 		} else {
				// 			uni.hideLoading()
				// 			uni.showModal({
				// 				title: '系统提示',
				// 				content: res.data.msg,
				// 				confirmText: '好的'
				// 			})
				// 		}
				// 	},
				// 	fail(err) {
				// 		uni.hideLoading();
				// 		uni.showModal({
				// 			title: '提示',
				// 			showCancel: false,
				// 			content: '请求超时了，重新试试吧！'
				// 		})
				// 	}
				// })
			},
			//图片下载
			download(url, i) {
				uni.downloadFile({
					url: url, //图片地址
					success: (res) => {
						//图片保存到本地
						uni.saveImageToPhotosAlbum({
							filePath: res.tempFilePath,
							success: () => {
								if (i == 0) {
									this.code = 200
								} else {
									this.image = this.image + 1
								}
							},
							fail: function(err) {
								if (err.errMsg === "saveImageToPhotosAlbum:fail:auth denied" || err
									.errMsg === "saveImageToPhotosAlbum:fail auth deny" || err
									.errMsg === "saveImageToPhotosAlbum:fail authorize no response"
								) {
									// 这边微信做过调整，必须要在按钮中触发，因此需要在弹框回调中进行调用
									uni.showModal({
										title: '提示',
										content: '需要您授权保存相册',
										showCancel: false,
										success: modalSuccess => {
											uni.openSetting({
												success(settingdata) {
													console.log("settingdata",
														settingdata)
													if (settingdata
														.authSetting[
															'scope.writePhotosAlbum'
														]) {
														uni.showModal({
															title: '提示',
															content: '获取权限成功,再次点击图片即可保存',
															showCancel: false,
														})
													} else {
														uni.showModal({
															title: '提示',
															content: '获取权限失败，将无法保存到相册哦~',
															showCancel: false,
														})
													}
												},
												fail(failData) {
													console.log("failData",
														failData)
												},
												complete(finishData) {
													console.log("finishData",
														finishData)
												}
											})
										}
									})
								}
							}
						})
					}
				})
			},
			//复制图片链接
			copyText() {
				uni.setClipboardData({
					data: this.images[this.index],
					success: function(res) {
						uni.showToast({
							title: '复制成功',
						});
					},
					fail() {
						uni.showToast({
							icon: "error",
							title: '复制失败了'
						});
					}
				});
			},
			//文本复制 公
			copyText2(text) {
				console.log(this.data)
				uni.setClipboardData({
					data: text,
					success: function(res) {
						uni.showToast({
							title: '复制成功',
						});
					},
					fail() {
						uni.showToast({
							icon: "error",
							title: '复制失败了'
						});
					}
				});
			},
			copywa() {
				uni.setClipboardData({
					data: this.data.title,
					success: function(res) {
						uni.showToast({
							title: '复制成功',
						});
					},
					fail() {
						uni.showToast({
							title: '复制失败了',
						});
					}
				});
			},
			dow() {
				this.code = 403
				uni.showLoading({
					title: "拼命下载中"
				})
				var msg = this.images[this.index]
				// msg = encodeURIComponent(msg)
				this.transit(msg, 0)
			},
			dows() {
				this.code = 403
				uni.showLoading({
					title: "下载第" + this.image + "/" + this.images.length + "张"
				})
				var msg = this.images[0]
				// msg = encodeURIComponent(msg)
				this.transit(msg, 1)


			}
		}
	}
</script>

<style>
	page {
		background-color: #FFF;
	}

	.btn-v {
		margin: 23px 0px;
		display: flex;
		justify-content: space-between;
	}

	/* From www.lingdaima.com */
	.btn-a {
		background-image: linear-gradient(45deg, #FF512F 0%, #F09819 51%, #FF512F 100%)
	}

	.btn-a {
		font-size: 14px;
		margin: 0px;
		width: 45%;
		text-align: center;
		transition: 0.5s;
		background-size: 200% auto;
		color: white;
		border-radius: 5px;
		display: block;
		border: 0px;
		box-shadow: 0px 0px 14px -7px #f09819;
	}

	.btn-a:hover {
		background-position: right center;
		/* change the direction of the change here */
		color: #fff;
		text-decoration: none;
	}

	.btn-a:active {
		transform: scale(0.95);
	}

	.btn-b {
		background-image: linear-gradient(45deg, #7a74d9 0%, #8a8ac9 51%, #806fe2 100%)
	}

	.btn-b {
		font-size: 14px;
		margin: 0px;
		width: 45%;
		text-align: center;
		transition: 0.5s;
		background-size: 200% auto;
		color: white;
		border-radius: 5px;
		display: block;
		border: 0px;
		box-shadow: 0px 0px 14px -7px #f09819;
	}

	.btn-b:hover {
		background-position: right center;
		/* change the direction of the change here */
		color: #fff;
		text-decoration: none;
	}

	.btn-b:active {
		transform: scale(0.95);
	}



	/* From www.lingdaima.com */
	button {
		font-size: 14px;
		position: relative;
		display: block;
		text-decoration: none;
		overflow: hidden;
		border-radius: 5px;
		border: none;
	}

	button span {
		position: relative;
		color: #fff;
		font-family: Arial;
		letter-spacing: 8px;
		z-index: 1;
	}

	button .liquid {
		position: absolute;
		top: -80px;
		left: 0;
		width: 100%;
		height: 200px;
		background: #4973ff;
		box-shadow: inset 0 0 50px rgba(0, 0, 0, .5);
		transition: .5s;
	}

	button .liquid::after,
	button .liquid::before {
		content: '';
		width: 200%;
		height: 200%;
		position: absolute;
		top: 0;
		left: 50%;
		transform: translate(-50%, -75%);
		background: #fff;
	}

	button .liquid::before {
		border-radius: 45%;
		background: rgba(20, 20, 20, 1);
		animation: animate 5s linear infinite;
	}

	button .liquid::after {
		border-radius: 40%;
		background: rgba(20, 20, 20, .5);
		animation: animate 10s linear infinite;
	}

	button:hover .liquid {
		top: -120px;
	}

	@keyframes animate {
		0% {
			transform: translate(-50%, -75%) rotate(0deg);
		}

		100% {
			transform: translate(-50%, -75%) rotate(360deg);
		}
	}

	.bottom-tx {
		margin-top: 30px;
		text-align: center;
		font-size: 12px;
	}
</style>
