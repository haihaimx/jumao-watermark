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


    /**
     * 抖音用户主页批量解析
     * 一个很辣鸡的方式实现的，需要定期更换cookie，因为我不会js逆向，所以只能这样了！
     * 抖音已验证cookie获取方法是浏览器使用手机端模拟访问，找到这个接口的cookie （https://m.douyin.com/web/api/v2/aweme/post/）
     * @param $url
     * @param int $times
     * @return array
     */
    public function batch($url, $times = 0)
    {
        $loc = get_headers($url, true)['Location'];
        preg_match('/user\/(.*)\?/', $loc, $id);

        $header = [
            'User-Agent:Mozilla/5.0 (Linux; U; Android 9; zh-cn; Redmi Note 5 Build/PKQ1.180904.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/71.0.3578.141 Mobile Safari/537.36 XiaoMi/MiuiBrowser/11.10.8',

            // cookie需要定期更换
            'Cookie:ttwid=1%7CvzTSa7nn_stmNT7xPN_GPjOYu9uSqY2TSnACS-AwIVE%7C1671953123%7C16a3b0605fdee111a184a31f1a4cbdb18d591c4262764a64e46d7c740be59ed6; s_v_web_id=verify_lc31pzdi_9fjf6ifs_7D50_4RcZ_8DOr_ykGvzGBfzTZz; __ac_nonce=063be67ef00910acaa370; __ac_signature=_02B4Z6wo00f01o0PXiAAAIDDkUzgn1zarG6NP1qAAMEJOcIQzgJGY7gnlkk.WyNnahCp0vG2tBA2mdJ4cqvKDQvrxxvJfjjhPgUy1z-VEeBHnavvQ5y0p3DkowTWG3TULV.7esbUIeekj.6s88; _tea_utm_cache_2018={%22utm_source%22:%22copy%22%2C%22utm_medium%22:%22android%22%2C%22utm_campaign%22:%22client_share%22}'
        ];
        $arr = json_decode($this->curl($this->splicingUrl($id[1], $times),$header), true);

        if (count($arr['aweme_list']) <= 0) {
            return $this->renderError("解析失败或该账号是私密账号");
        }

        $videoList = [];
        foreach ($arr['aweme_list'] as $item) {
            array_push($videoList, [
                "title" => $item['desc'],
                "cover" => $item['video']['origin_cover']['url_list'][0],
                "video" => $item['video']['play_addr']['url_list'][0],
            ]);
        }

        $videoList = [
            "list" => $videoList,
            "times" => $arr['has_more'] == 1 ? $arr['max_cursor'] : -1
        ];
        return $this->renderSuccess($videoList, "解析成功");
    }

    function splicingUrl($sec_uid, $max_cursor = 0, $count = 21)
    {
        $data = [
            "reflow_source" => "reflow_page",
            "sec_uid" => $sec_uid,
            "count" => $count,
            "max_cursor" => $max_cursor,
            "msToken" => "9dF1LXc8TN7d_q4QpJPCjTwKPskRHaGk-9BcjSOi8FAe1KIIoNOVuXpLQS5XvRGi_zwMawKyIZtL5c04VotilnDd_kVrhMm_7qXhDxU0frbAuedXS-pu",
            "X-Bogus" => "DFSzswSOZSkANjtISDOqCM9WX7jy",
            "_signature" => "_02B4Z6wo00001Vsi-TQAAIDB2yADdVedF-1bMv2AADV68d"
        ];

        return "https://m.douyin.com/web/api/v2/aweme/post/?reflow_source=reflow_page&sec_uid=" .
            $data['sec_uid'] . "&count=" .
            $data['count'] . "&max_cursor=" .
            $data['max_cursor'] . "&msToken=" .
            $data['msToken'] . "&X-Bogus=" .
            $data['X-Bogus'] . "&_signature=" .
            $data['_signature'] . "";

    }


    private function curl($url, $headers = [])
    {
        $header = ['User-Agent:Mozilla/5.0 (Linux; U; Android 9; zh-cn; Redmi Note 5 Build/PKQ1.180904.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/71.0.3578.141 Mobile Safari/537.36 XiaoMi/MiuiBrowser/11.10.8'];
        $con = curl_init((string)$url);
        curl_setopt($con, CURLOPT_HEADER, false);
        curl_setopt($con, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($con, CURLOPT_RETURNTRANSFER, true);
        if (!empty($headers)) {
            curl_setopt($con, CURLOPT_HTTPHEADER, $headers);
        } else {
            curl_setopt($con, CURLOPT_HTTPHEADER, $header);
        }
        curl_setopt($con, CURLOPT_TIMEOUT, 5000);
        $result = curl_exec($con);
        return $result;
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
