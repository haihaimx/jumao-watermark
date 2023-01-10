<?php

namespace app\api\controller;

use app\api\model\Wxapp as WxappModel;
use app\api\model\WxappHelp;
use think\Exception;

/**
 * 解析接口配置
 * Class Apis
 * @package app\api\controller
 */
class Apis extends Controller
{


    public function analysis($videoUrl)
    {
        try {
//            return [
//                "code" => 200,  // 200表示解析成功   -1 表示失败
//                "data" => [
//                    "title" => "这里是分享文案",
//                    "cover" => "这里是封面图片链接",
//                    "images" => [], // 这里是图集的数组
//                    "video" => "这里是视频链接",
//                ],
//                "msg" => "解析成功"
//            ];
            return [
                "code" => -1,
                "data" => null,
                "msg" => "解析失败，请先配置接口"
            ];
        } catch (Exception $e) {
            return [
                "code" => -1,
                "data" => null,
                "msg" => "解析失败，出错了"
            ];
        }

    }

    function getUrl302($url)
    {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        $header = array('User-Agent:Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36');
        curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
        curl_setopt($ch, CURLOPT_VERBOSE, true);
        curl_setopt($ch, CURLOPT_HEADER, true);
        curl_setopt($ch, CURLOPT_NOBODY, true);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'GET');
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 20);
        curl_setopt($ch, CURLOPT_AUTOREFERER, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        $info = curl_getinfo($ch);
        curl_close($ch);

        return $info['url'];
    }

}
